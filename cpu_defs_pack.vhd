package CPU_DEFS_PACK is

   constant bus_width      : natural := 12;        --2.1.1
   constant data_width     : natural := bus_width; -- 2.1.2
   constant addr_width     : natural := bus_width; -- 2.1.3

   constant reg_addr_width : natural := 2;         -- do not change
   constant opcode_width   : natural := 6;         -- do not change

   subtype data_type is
      natural range 0 to 2**data_width-1;

   subtype addr_type is
      natural range 0 to 2**addr_width-1;

   subtype reg_addr_type is
      natural range 0 to 2**reg_addr_width-1;

   subtype opcode_type is
      natural range 0 to 2**opcode_width-1;

   type reg_type is array(reg_addr_type) of data_type;

   type mem_type is array(addr_type) of data_type;

   constant code_nop  : opcode_type:= 0;       -- 3.5.1
   constant code_stop : opcode_type:= 1;       -- 3.5.2



   -----------------------------------------------------
   --
   -- BIT SHIFT/ROTATIONs
   --
   -----------------------------------------------------

   -- Logical Shift Left
   procedure EXEC_SLL  ( A        : in  data_type;
                         R        : out data_type;
                         Z,CO,N,O : out boolean   );

   -- Logical Shift Right
   procedure EXEC_SRL  ( A        : in  data_type;
                         R        : out data_type;
                         Z,CO,N,O : out boolean   );

   -- Arithmetic Shift Right
   procedure EXEC_SRA  ( A        : in  data_type;
                         R        : out data_type;
                         Z,CO,N,O : out boolean   );

   -- Rotate Right
   procedure EXEC_ROR  ( A        : in  data_type;
                         R        : out data_type;
                         Z,CO,N,O : out boolean   );

   -- Rotate Right through Carry
   procedure EXEC_RORC ( A        : in  data_type;
                         CI       : in  boolean;
                         R        : out data_type;
                         Z,CO,N,O : out boolean   );

   -- Rotate Left
   procedure EXEC_ROL  ( A        : in  data_type;
                         R        : out data_type;
                         Z,CO,N,O : out boolean   );

   -- Rotate Left through Carry
   procedure EXEC_ROLC ( A        : in  data_type;
                         CI       : in  boolean;
                         R        : out data_type;
                         Z,CO,N,O : out boolean   );


end CPU_DEFS_PACK;
