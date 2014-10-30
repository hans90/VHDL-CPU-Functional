-- Implementation Testbench for Operation SLL
-- Specification Section 3.3.1.14
-- Author: Johannes L.

use work.CPU_DEFS_PACK.all;

entity INSTR_SLL_TB is

end INSTR_SLL_TB;

architecture tb of INSTR_SLL_TB is
	
	begin process
	
	-- inputs: manual computed
	-- output: Test passed/fail
	function TEST_SLL ( A : in DATA_TYPE;
							  R : in DATA_TYPE;
							  Z, CO, N, O : in BOOLEAN
							 )	return BOOLEAN is

	-- variables for results
	variable res_R  : DATA_TYPE := 0;
	variable res_Z  : BOOLEAN := NOT Z;
	variable res_CO : BOOLEAN := NOT CO;
	variable res_N  : BOOLEAN := NOT N;
	variable res_O  : BOOLEAN := NOT O;

	begin
		EXEC_SLL(A,res_R,res_Z,res_CO,res_N,res_O);
		assert res_R  = R report "Wrong result." severity error;
		assert res_Z  = Z report "Zero Flag wrong." severity error;
		assert res_CO = CO report "Carry Out Flag wrong." severity error;
		assert res_N  = N report "Negative Flag wrong." severity error;
		assert res_O  = O report "Overflow Flag wrong." severity error;
	
	if (res_R = R) and (res_Z = Z) and (res_CO = CO) and (res_N = N) and (res_O = O) then
		return true;
	else 
		return false;
	end if;

	end TEST_SLL;
	-----------------------------------------
	
	begin -- (Testing with ...)

	-- Random Values.
	--                      A                      R               Z     CO      N      O
	assert TEST_SLL ( 45                  , 90                 , false, false, false, false) report "Test 1 failed." severity error;
	
	-- Values at or near Margins
	assert TEST_SLL ( 0                   , 0                  , true,  false, false, false) report "Test 2 failed." severity error;
	
	--                    FFF                 FFE
	assert TEST_SLL ( 2**data_width-1     , 2**data_width-2    , false, true , true , false) report "Test 3 failed." severity error;
	
	--                    01111...             1111...10
	assert TEST_SLL ( 2**(data_width-1)-1 , 2**data_width-1    , false, false, true , true ) report "Test 4 failed." severity error; --3.2.7.2

	wait;
	end process;
end tb;