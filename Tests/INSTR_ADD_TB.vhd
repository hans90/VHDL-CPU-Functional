-- Testbench for ADD and ADDC Instructions.
-- This is just one TB since ADD is not implemented seperately.
-- Thus each test repeats twice, once for Carry = False and once for Carry = True.
use work.CPU_DEFS_PACK.all;





entity INSTR_ADD_TB is
end INSTR_ADD_TB;





architecture TESTBENCH of INSTR_ADD_TB is
begin

   STIMUL : process

      function TEST_ADDC (
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
         Z_ACTUAL := NOT Z;
         C_ACTUAL := NOT CO;
         N_ACTUAL := NOT N;
         O_ACTUAL := NOT O;
         EXEC_ADDC(A, B, CI, R_ACTUAL, Z_ACTUAL, C_ACTUAL, N_ACTUAL, O_ACTUAL);
         assert R_ACTUAL = R report "Test #" & integer'image(TEST_NUM) & ": " & TEST_NAME & " failed: R = " & integer'image(R_ACTUAL) & ", should be " & integer'image(R) severity ERROR;
         assert Z_ACTUAL = Z report "Test #" & integer'image(TEST_NUM) & ": " & TEST_NAME & " failed: Z = " & boolean'image(Z_ACTUAL) & ", should be " & boolean'image(Z) severity ERROR;
         assert C_ACTUAL = CO report "Test #" & integer'image(TEST_NUM) & ": " & TEST_NAME & " failed: C = " & boolean'image(C_ACTUAL) & ", should be " & boolean'image(CO) severity ERROR;
         assert N_ACTUAL = N report "Test #" & integer'image(TEST_NUM) & ": " & TEST_NAME & " failed: N = " & boolean'image(N_ACTUAL) & ", should be " & boolean'image(N) severity ERROR;
         assert O_ACTUAL = O report "Test #" & integer'image(TEST_NUM) & ": " & TEST_NAME & " failed: O = " & boolean'image(O_ACTUAL) & ", should be " & boolean'image(O) severity ERROR;

         return true;

      end TEST_ADDC;

      variable RES : boolean := false;

   begin




      -- Good Values: Just try some values that we don't expect anything fancy to happen for.

      --               #  Name                 A   B   R   CI     Z      CO     N      O
      RES := TEST_ADDC(1, "Good Values, CI=0", 5,  3,  8,  false, false, false, false, false);
      RES := TEST_ADDC(2, "Good Values, CI=1", 5,  3,  9,  true,  false, false, false, false);
      RES := TEST_ADDC(3, "Good Values, CI=0", 57, 32, 89, false, false, false, false, false);
      RES := TEST_ADDC(4, "Good Values, CI=1", 57, 32, 90, true,  false, false, false, false);


      -- Flags: Test flag generation for each flag

      --               #  Name           A   B                 R  CI     Z     CO    N      O
      RES := TEST_ADDC(5, "Flags, CI=0", 5, (2**DATA_WIDTH)-5, 0, false, true, true, false, false);
      RES := TEST_ADDC(6, "Flags, CI=1", 4, (2**DATA_WIDTH)-5, 0, true,  true, true, false, false);

      --               #  Name           A   B                  R  CI     Z      CO    N      O
      RES := TEST_ADDC(7, "Flags, CI=0", 10, (2**DATA_WIDTH)-8, 2, false, false, true, false, false);
      RES := TEST_ADDC(8, "Flags, CI=1", 9,  (2**DATA_WIDTH)-8, 2, true,  false, true, false, false);

      --               #   Name           A  B                  R                  CI     Z      CO     N     O
      RES := TEST_ADDC(9,  "Flags, CI=0", 3, (2**DATA_WIDTH)-5, (2**DATA_WIDTH)-2, false, false, false, true, false);
      RES := TEST_ADDC(10, "Flags, CI=1", 2, (2**DATA_WIDTH)-5, (2**DATA_WIDTH)-2, true,  false, false, true, false);

      --               #   Name           A  B                    R                  CI     Z      CO     N      O
      RES := TEST_ADDC(11, "Flags, CI=0", 1, 2**(DATA_WIDTH-1)-1, 2**(DATA_WIDTH-1), false, false, false, false, true);
      RES := TEST_ADDC(12, "Flags, CI=1", 0, 2**(DATA_WIDTH-1)-1, 2**(DATA_WIDTH-1), true,  false, false, false, true);


      -- Border Values

      --               #   Name                   A  B  R  CI     Z      CO     N      O
      RES := TEST_ADDC(13, "Border Values, CI=0", 0, 0, 0, false, true,  false, false, false);
      RES := TEST_ADDC(14, "Border Values, CI=1", 0, 0, 1, true,  false, false, false, false);

      --               #   Name                   A                  B                  R                  CI     Z      CO    N     O
      RES := TEST_ADDC(15, "Border Values, CI=0", (2**DATA_WIDTH)-1, (2**DATA_WIDTH)-1, (2**DATA_WIDTH)-2, false, false, true, true, false);
      RES := TEST_ADDC(16, "Border Values, CI=1", (2**DATA_WIDTH)-1, (2**DATA_WIDTH)-1, (2**DATA_WIDTH)-1, true,  false, true, true, false);


      assert FALSE report "Tests completed, see above for errors" severity NOTE;

      wait;

   end process;

end TESTBENCH; -- Julian Leyh
