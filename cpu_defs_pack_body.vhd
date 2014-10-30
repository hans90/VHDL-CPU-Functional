library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;





package body CPU_DEFS_PACK is


   -----------------------------------------------------
   --
   -- BIT SHIFT/ROTATIONs
   --
   -- These instructions provide for operations to shift or rotate registers by
   -- one bit.
   --
   -- Implementations by Julian Leyh
   -- Testbenches by Johannes Linder, Hassib Belhaj
   --
   -----------------------------------------------------



   -- Logical Shift Left
   procedure EXEC_SLL  ( A        : in  data_type;
                         R        : out data_type;
                         Z,CO,N,O : out boolean   ) is

      constant A_u   : unsigned (DATA_WIDTH-1 downto 0) := to_unsigned(A,DATA_WIDTH);
      variable R_b   : integer range 0 to 2**DATA_WIDTH-1 := 0;

   begin

      R_b := to_integer(A_u(DATA_WIDTH-2 downto 0) & '0');

      if R_b = 0 then -- ->3.2.4.1
         Z := true;
      else
         Z := false;
      end if;

      if A_u(DATA_WIDTH-1) = '1' then -- ->3.2.5.4
         CO := true;
      else
         CO := false;
      end if;

      -- ->3.2.6.2
      -- Since A_u(DATA_WIDTH-2) is MSB of R we'll just use A_u(DATA_WIDTH-2)
      -- This should be faster and it's less code
      if A_u(DATA_WIDTH-2) = '1' then
         N := true;
      else
         N := false;
      end if;
      
      -- ->3.2.7.2
      -- Since A_u(DATA_WIDTH-2) is MSB of R and A_u(DATA_WIDTH-1) is MSB of we
      -- we'll just use those two. This should be faster and it's less code
      if A_u(DATA_WIDTH-2) /= A_u(DATA_WIDTH-1) then
         O := true;
      else
         O := false;
      end if;

      R := R_b;

   end procedure; -- Julian Leyh



   -- Logical Shift Right
   procedure EXEC_SRL  ( A        : in  data_type;
                         R        : out data_type;
                         Z,CO,N,O : out boolean   ) is

      constant A_u   : unsigned (DATA_WIDTH-1 downto 0) := to_unsigned(A,DATA_WIDTH);
      variable R_b   : integer range 0 to 2**DATA_WIDTH-1 := 0;

   begin

      R_b := to_integer('0' & A_u(DATA_WIDTH-1 downto 1));

      if R_b = 0 then -- ->3.2.4.1
         Z := true;
      else
         Z := false;
      end if;

      -- ->3.2.5.5
      if A_u(0) = '1' then
         CO := true;
      else
         CO := false;
      end if;

      -- ->3.2.6.2
      -- MSB of R is always '0'
      N := false;

      O := false; -- ->3.2.7.3

      R := R_b;

   end procedure; -- Julian Leyh



   -- Arithmetic Shift Right
   procedure EXEC_SRA  ( A        : in  data_type;
                         R        : out data_type;
                         Z,CO,N,O : out boolean   ) is

      constant A_u   : unsigned (DATA_WIDTH-1 downto 0) := to_unsigned(A,DATA_WIDTH);
      variable R_b   : integer range 0 to 2**DATA_WIDTH-1 := 0;

   begin

      R_b := to_integer(A_u(DATA_WIDTH-1) & A_u(DATA_WIDTH-1 downto 1));

      if R_b = 0 then -- ->3.2.4.1
         Z := true;
      else
         Z := false;
      end if;

      -- ->3.2.5.5
      if A_u(0) = '1' then
         CO := true;
      else
         CO := false;
      end if;

      -- ->3.2.6.2
      -- A_u(DATA_WIDTH-1 remains MSB of R
      if A_u(DATA_WIDTH-1) = '1' then
         N := true;
      else
         N := false;
      end if;

      O := false; -- ->3.2.7.3

      R := R_b;

   end procedure; -- Julian Leyh



   -- Rotate Right
   procedure EXEC_ROR  ( A        : in  data_type;
                         R        : out data_type;
                         Z,CO,N,O : out boolean   ) is

      constant A_u   : unsigned (DATA_WIDTH-1 downto 0) := to_unsigned(A,DATA_WIDTH);
      variable R_b   : integer range 0 to 2**DATA_WIDTH-1 := 0;

   begin

      R_b := to_integer(A_u(0) & A_u(DATA_WIDTH-1 downto 1));

      if R_b = 0 then -- ->3.2.4.1
         Z := true;
      else
         Z := false;
      end if;

      CO := false; -- ->3.2.5.1

      -- ->3.2.6.2
      -- Since A_u(0) is MSB of R we'll just use A_u(0)
      -- This should be faster and it's less code
      if A_u(0) = '1' then
         N := true;
      else
         N := false;
      end if;

      O := false; -- ->3.2.7.3

      R := R_b;

   end procedure; -- Julian Leyh



   -- Rotate Right through Carry
   procedure EXEC_RORC ( A        : in  data_type;
                         CI       : in  boolean;
                         R        : out data_type;
                         Z,CO,N,O : out boolean   ) is

      constant A_u   : unsigned (DATA_WIDTH-1 downto 0) := to_unsigned(A,DATA_WIDTH);
      variable R_b   : integer range 0 to 2**DATA_WIDTH-1 := 0;

   begin

      if CI = true then
        R_b := to_integer('1' & A_u(DATA_WIDTH-1 downto 1));
      else
        R_b := to_integer('0' & A_u(DATA_WIDTH-1 downto 1));
      end if;

      if R_b = 0 then -- ->3.2.4.1
         Z := true;
      else
         Z := false;
      end if;

      if A_u(0) = '1' then -- ->3.2.5.5
         CO := true;
      else
         CO := false;
      end if;

      -- ->3.2.6.2
      -- Since CI is MSB of R we'll just use CI
      N := CI;

      O := false; -- ->3.2.7.3

      R := R_b;

   end procedure; -- Julian Leyh



   -- Rotate Left
   procedure EXEC_ROL  ( A        : in  data_type;
                         R        : out data_type;
                         Z,CO,N,O : out boolean   ) is

      constant A_u   : unsigned (DATA_WIDTH-1 downto 0) := to_unsigned(A,DATA_WIDTH);
      variable R_b   : integer range 0 to 2**DATA_WIDTH-1 := 0;

   begin

      R_b := to_integer(A_u(DATA_WIDTH-2 downto 0) & A_u(DATA_WIDTH-1));

      if R_b = 0 then -- ->3.2.4.1
         Z := true;
      else
         Z := false;
      end if;

      CO := false; -- ->3.2.5.1

      -- ->3.2.6.2
      -- Since A_u(DATA_WIDTH-2) is MSB of R we'll just use A_u(DATA_WIDTH-2)
      -- This should be faster and it's less code
      if A_u(DATA_WIDTH-2) = '1' then
         N := true;
      else
         N := false;
      end if;

      O := false; -- ->3.2.7.3

      R := R_b;

   end procedure; -- Julian Leyh



   -- Rotate Left through Carry
   procedure EXEC_ROLC ( A        : in  data_type;
                         CI       : in  boolean;
                         R        : out data_type;
                         Z,CO,N,O : out boolean   ) is

      constant A_u   : unsigned (DATA_WIDTH-1 downto 0) := to_unsigned(A,DATA_WIDTH);
      variable R_b   : integer range 0 to 2**DATA_WIDTH-1 := 0;

   begin

      if CI = true then
        R_b := to_integer(A_u(DATA_WIDTH-2 downto 0) & '1');
      else
        R_b := to_integer(A_u(DATA_WIDTH-2 downto 0) & '0');
      end if;

      if R_b = 0 then -- ->3.2.4.1
         Z := true;
      else
         Z := false;
      end if;

      if A_u(DATA_WIDTH-1) = '1' then -- ->3.2.5.4
         CO := true;
      else
         CO := false;
      end if;

      -- ->3.2.6.2
      -- Since A_u(DATA_WIDTH-2) is MSB of R we'll just use A_u(DATA_WIDTH-2)
      -- This should be faster and it's less code
      if A_u(DATA_WIDTH-2) = '1' then
         N := true;
      else
         N := false;
      end if;

      O := false; -- ->3.2.7.3

      R := R_b;

   end procedure; -- Julian Leyh

   -- Logical Instructions
   -----------------------
  
   -- NOT (OpCode 6) -> 3.3.1.7
   procedure EXEC_NOT ( A           : in  DATA_TYPE;
                        R           : out DATA_TYPE;
                        Z, CO, N, O : out BOOLEAN    ) is
      
      begin
        
        R := -A -1 + 2**data_width;
        
        -- Check & Assign Zero Flag (3.2.4)
        if A mod 2**data_width = 0 then 
          Z := true;
        else
          Z := false;
        end if;
        
        CO := false;  -- 3.2.5.1
        
        -- Check if Result is Negative (3.2.6.2)
        if A >= 2**(data_width-1)  then
          N := false;
        else
          N := true;
        end if;
        
        O := false; -- 3.2.7.3
      
   end EXEC_NOT; -- Johannes L.
  
   -- AND (OpCode 7) -> 3.3.1.8
   procedure EXEC_AND ( A, B       : in  DATA_TYPE;
                       R           : out DATA_TYPE;
                       Z, CO, N, O : out BOOLEAN    ) is
      
		variable R_tmp : DATA_TYPE := 0;
		variable A_tmp : DATA_TYPE := A;
		variable B_tmp : DATA_TYPE := B;
		
		begin
		
		-- Slide 56 lecture
		for i in 0 to data_width loop
			R_tmp := R_tmp + 2**i * ( A_tmp mod 2 ) * ( B_tmp mod 2 );
			A_tmp := A_tmp / 2; -- >>
			B_tmp := B_tmp / 2; -- >>
		end loop;

      -- Check & Assign Zero Flag (3.2.4)
      if R_tmp mod 2**data_width = 0 then 
          Z := true;
      else
          Z := false;
      end if;
      
      CO := false; -- 3.2.5.1
      
       -- Check for negative Result (3.2.6.2)
      if R_tmp >= 2**(data_width-1) then
          N := true;
      else
          N := false;
      end if;
      
		O := false; -- 3.2.7.3

		R := R_tmp;
      
   end EXEC_AND; -- Johannes L.

   -- OR (OpCode 8) -> 3.3.1.9
   procedure EXEC_OR ( A, B        : in  DATA_TYPE;
                       R           : out DATA_TYPE;
                       Z, CO, N, O : out BOOLEAN    ) is
      
		variable R_tmp : DATA_TYPE := 0;
		variable A_tmp : DATA_TYPE := A;
		variable B_tmp : DATA_TYPE := B;
		
		begin
		
		-- Manual OR
		for i in 0 to data_width loop
			if ((A_tmp mod 2) = 1) OR ((B_tmp mod 2) = 1) then
				R_tmp := R_tmp + 2**i;
			end if;
			A_tmp := A_tmp / 2; -- >>
			B_tmp := B_tmp / 2; -- >>
		end loop;

      -- Check & Assign Zero Flag (3.2.4)
      if R_tmp mod 2**data_width = 0 then 
          Z := true;
      else
          Z := false;
      end if;
      
      CO := false; -- 3.2.5.1
      
       -- Check for negative Result (3.2.6.2)
      if R_tmp >= 2**(data_width-1) then
          N := true;
      else
          N := false;
      end if;
      
		O := false; -- 3.2.7.3

		R := R_tmp;
      
   end EXEC_OR; -- Johannes L.


   -- XOR (OpCode 9) -> 3.3.1.10
   procedure EXEC_XOR ( A, B        : in  DATA_TYPE;
                       R           : out DATA_TYPE;
                       Z, CO, N, O : out BOOLEAN    ) is
      
		variable R_tmp : DATA_TYPE := 0;
		variable A_tmp : DATA_TYPE := A;
		variable B_tmp : DATA_TYPE := B;
		
		begin
		
		-- Manual XOR
		for i in 0 to data_width loop
			if ((A_tmp mod 2) = 1) XOR ((B_tmp mod 2) = 1) then
				R_tmp := R_tmp + 2**i;
			end if;
			A_tmp := A_tmp / 2; -- >>
			B_tmp := B_tmp / 2; -- >>
		end loop;

      -- Check & Assign Zero Flag (3.2.4)
      if R_tmp mod 2**data_width = 0 then 
          Z := true;
      else
          Z := false;
      end if;
      
      CO := false; -- 3.2.5.1
      
       -- Check for negative Result (3.2.6.2)
      if R_tmp >= 2**(data_width-1) then
          N := true;
      else
          N := false;
      end if;
      
		O := false; -- 3.2.7.3

		R := R_tmp;
      
   end EXEC_XOR; -- Johannes L.

   -- REA (OpCode 10) -> 3.3.1.11
   procedure EXEC_REA ( A          : in  DATA_TYPE;
                       R           : out DATA_TYPE;
                       Z, CO, N, O : out BOOLEAN    ) is
		
		variable R_tmp : DATA_TYPE := 0;

		begin
		
		-- Reduced AND ?!
		-- i.e. check for all bits set '1'
		if A = 2**data_width - 1 then -- xFFF
			-- Assign LSB = 1
			if (A mod 2) = 0 then
				R_tmp := A + 1;
			else
				R_tmp := A;
			end if;
		else
			-- Assign LSB = 0
			if (A mod 2) = 0 then
				R_tmp := A;
			else
				R_tmp := A - 1;
			end if;
		end if;
		

      -- Check Result & Assign Zero Flag (3.2.4)
      if R_tmp mod 2**data_width = 0 then 
          Z := true;
      else
          Z := false;
      end if;
      
      CO := false; -- 3.2.5.1
      
       -- Check for negative Result (3.2.6.2)
      if R_tmp >= 2**(data_width-1) then
          N := true;
      else
          N := false;
      end if;
      
		O := false; -- 3.2.7.3

		R := R_tmp;
      
   end EXEC_REA; -- Johannes L.
	
	-- REO (OpCode 11) -> 3.3.1.12
   procedure EXEC_REO ( A          : in  DATA_TYPE;
                       R           : out DATA_TYPE;
                       Z, CO, N, O : out BOOLEAN    ) is
		
		variable R_tmp : DATA_TYPE := 0;
		variable A_tmp : DATA_TYPE := A;

		begin

		-- Assign LSB = 0
		if (A mod 2) = 0 then
			R_tmp := A;
		else
			R_tmp := A - 1;
		end if;

		-- Reduced OR Operation
		-- i.e. check if >= one bit is set '1'
		for i in 0 to data_width loop
			if (A_tmp mod 2) = 1 then
				R_tmp := A + 1; -- Set LSB '1'
				exit;           -- Reduced OR evaluates to true anyways
			end if;
			A_tmp := A_tmp / 2; -- >>
		end loop;
		

      -- Check Result & Assign Zero Flag (3.2.4)
      if R_tmp mod 2**data_width = 0 then 
          Z := true;
      else
          Z := false;
      end if;
      
      CO := false; -- 3.2.5.1
      
       -- Check for negative Result (3.2.6.2)
      if R_tmp >= 2**(data_width-1) then
          N := true;
      else
          N := false;
      end if;
      
		O := false; -- 3.2.7.3

		R := R_tmp;
      
   end EXEC_REO; -- Johannes L.

	-- REX (OpCode 12) -> 3.3.1.13
   procedure EXEC_REX ( A          : in  DATA_TYPE;
                       R           : out DATA_TYPE;
                       Z, CO, N, O : out BOOLEAN    ) is
		
		variable R_tmp : DATA_TYPE := 0;
		variable A_tmp : DATA_TYPE := A;
		variable parity : integer := 0;

		begin

		-- Reduced XOR Operation
		-- i.e. count ones (comp. even parity bit)
		for i in 0 to data_width loop
			if (A_tmp mod 2) = 1 then
				parity := parity + 1;
			end if;
			A_tmp := A_tmp / 2; -- >>
		end loop;
		
		if (parity mod 2) = 1 then
			-- Assign LSB = 1
			if (A mod 2) = 0 then
				R_tmp := A + 1;
			else
				R_tmp := A;
			end if;
		else
			-- Assign LSB = 0
			if (A mod 2) = 0 then
				R_tmp := A;
			else
				R_tmp := A - 1;
			end if;
		end if;

      -- Check Result & Assign Zero Flag (3.2.4)
      if R_tmp mod 2**data_width = 0 then 
          Z := true;
      else
          Z := false;
      end if;
      
      CO := false; -- 3.2.5.1
      
       -- Check for negative Result (3.2.6.2)
      if R_tmp >= 2**(data_width-1) then
          N := true;
      else
          N := false;
      end if;
      
		O := false; -- 3.2.7.3

		R := R_tmp;
      
   end EXEC_REX; -- Johannes L.

end CPU_DEFS_PACK;

