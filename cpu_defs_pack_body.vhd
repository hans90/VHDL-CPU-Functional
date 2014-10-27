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



end CPU_DEFS_PACK;

