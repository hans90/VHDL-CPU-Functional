-- Testbench for SUB and SUBC Instructions.

-- This is just one TB since SUB is not implemented seperately, thus each test
-- repeats twice, once for Carry = False and once for Carry = True.

-- Some simulators (like Xilinx isim) might perform some fancy optimization
-- which results in the simulator not performing any more tests, after one of them
-- failed. One should consider disabling those optimizations.

use work.CPU_DEFS_PACK.all;





entity INSTR_SUB_TB is
end INSTR_SUB_TB;





architecture TESTBENCH of INSTR_SUB_TB is
begin




   STIMUL : process


      -- This function simplifies the testing. It pretty much just calls
      -- EXEC_SUBC and compares the actual output values to the value they should
      -- have.
      function TEST_SUBC (
         constant TEST_NUM    : in integer range 1 to integer'high;
         constant TEST_NAME   : in string;
         constant A, B        : in integer range 0 to (2**DATA_WIDTH)-1;
         constant R           : in integer range 0 to (2**DATA_WIDTH)-1;
         constant CI          : in boolean;
         constant Z, CO, N, O : in boolean
      ) return boolean is
         variable R_ACTUAL : integer range 0 to (2**DATA_WIDTH)-1 := 0;
         variable Z_ACTUAL : boolean;
         variable C_ACTUAL : boolean;
         variable N_ACTUAL : boolean;
         variable O_ACTUAL : boolean;
      begin
         -- Initialize flags with the wrong value to make sure EXEC_SUBC actually sets them correctly.
         Z_ACTUAL := NOT Z;
         C_ACTUAL := NOT CO;
         N_ACTUAL := NOT N;
         O_ACTUAL := NOT O;

         -- Call SUBC
         EXEC_SUBC(A, B, CI, R_ACTUAL, Z_ACTUAL, C_ACTUAL, N_ACTUAL, O_ACTUAL);

         -- Check for correct return values
         assert R_ACTUAL = R report "Test #" & integer'image(TEST_NUM) & ": " & TEST_NAME & " failed: R = " & integer'image(R_ACTUAL) & ", should be " & integer'image(R) severity ERROR;
         assert Z_ACTUAL = Z report "Test #" & integer'image(TEST_NUM) & ": " & TEST_NAME & " failed: Z = " & boolean'image(Z_ACTUAL) & ", should be " & boolean'image(Z) severity ERROR;
         assert C_ACTUAL = CO report "Test #" & integer'image(TEST_NUM) & ": " & TEST_NAME & " failed: C = " & boolean'image(C_ACTUAL) & ", should be " & boolean'image(CO) severity ERROR;
         assert N_ACTUAL = N report "Test #" & integer'image(TEST_NUM) & ": " & TEST_NAME & " failed: N = " & boolean'image(N_ACTUAL) & ", should be " & boolean'image(N) severity ERROR;
         assert O_ACTUAL = O report "Test #" & integer'image(TEST_NUM) & ": " & TEST_NAME & " failed: O = " & boolean'image(O_ACTUAL) & ", should be " & boolean'image(O) severity ERROR;

         -- Hopefully everything's alright so we can print a nice message.
         if R_ACTUAL = R and Z_ACTUAL = Z and C_ACTUAL = CO and N_ACTUAL = N and O_ACTUAL = O then
            assert FALSE report "Test #" & integer'image(TEST_NUM) & ": " & TEST_NAME & " completed successfully" severity NOTE;
            return true;
         else
            return false;
         end if;

      end TEST_SUBC;


      -- Locally used variables
      variable RES : boolean := true;




   begin




      -- Good Values: Just try some values that we don't expect anything fancy to happen for.

      --                       #  Name                 A   B   R   CI     Z      CO     N      O
      RES := RES AND TEST_SUBC(1, "Good Values, CI=0", 8,  5,  3,  false, false, false, false, false);
      RES := RES AND TEST_SUBC(2, "Good Values, CI=1", 8,  5,  2,  true,  false, false, false, false);
      RES := RES AND TEST_SUBC(3, "Good Values, CI=0", 57, 32, 25, false, false, false, false, false);
      RES := RES AND TEST_SUBC(4, "Good Values, CI=1", 57, 32, 24, true,  false, false, false, false);


      -- Flags: Test flag generation for each flag

      --                       #  Name           A  B  R  CI     Z     CO     N      O
      RES := RES AND TEST_SUBC(5, "Flags, CI=0", 5, 5, 0, false, true, false, false, false);
      RES := RES AND TEST_SUBC(6, "Flags, CI=1", 6, 5, 0, true,  true, false, false, false);

      --                       #  Name           A  B                  R  CI     Z      CO    N      O
      RES := RES AND TEST_SUBC(7, "Flags, CI=0", 5, (2**DATA_WIDTH)-2, 7, false, false, true, false, false);
      RES := RES AND TEST_SUBC(8, "Flags, CI=1", 6, (2**DATA_WIDTH)-2, 7, true,  false, true, false, false);

      --                       #   Name           A                  B  R                  CI     Z      CO     N     O
      RES := RES AND TEST_SUBC(9,  "Flags, CI=0", (2**DATA_WIDTH)-3, 5, (2**DATA_WIDTH)-8, false, false, false, true, false);
      RES := RES AND TEST_SUBC(10, "Flags, CI=1", (2**DATA_WIDTH)-2, 5, (2**DATA_WIDTH)-8, true,  false, false, true, false);

      --                       #   Name           A                  B  R                    CI     Z      CO     N      O
      RES := RES AND TEST_SUBC(11, "Flags, CI=0", 2**(DATA_WIDTH-1), 1, 2**(DATA_WIDTH-1)-1, false, false, false, false, true);
      RES := RES AND TEST_SUBC(12, "Flags, CI=1", 2**(DATA_WIDTH-1), 0, 2**(DATA_WIDTH-1)-1, true,  false, false, false, true);


      -- Border Values

      --                       #   Name                   A  B  R                  CI     Z      CO     N      O
      RES := RES AND TEST_SUBC(13, "Border Values, CI=0", 0, 0, 0,                 false, true,  false, false, false);
      RES := RES AND TEST_SUBC(14, "Border Values, CI=1", 0, 0, (2**DATA_WIDTH)-1, true,  false, false, true,  false);

      --                       #   Name                   A                  B                  R                  CI     Z      CO     N      O
      RES := RES AND TEST_SUBC(15, "Border Values, CI=0", (2**DATA_WIDTH)-1, (2**DATA_WIDTH)-1, 0,                 false, true,  false, false, false);
      RES := RES AND TEST_SUBC(16, "Border Values, CI=1", (2**DATA_WIDTH)-1, (2**DATA_WIDTH)-1, (2**DATA_WIDTH)-1, true,  false, false, true,  false);



      -- Print a good-bye message
      assert RES = false report "All tests completed successfully" severity NOTE;
      assert RES = true  report "Some tests failed, see above for errors" severity ERROR;

      wait;

   end process;

end TESTBENCH; -- Julian Leyh
