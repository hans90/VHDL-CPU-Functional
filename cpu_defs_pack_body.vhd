package body CPU_DEFS_PACK is


procedure EXEC_ADDC ( A,B      : in  data_type;
                      CI       : in  boolean := FALSE;
                      R        : out data_type;
                      Z,CO,N,O : out boolean   ) is
variable T: integer := A+B+Boolean'Pos( CI );
variable A_s, B_s, T_s : integer;
begin
   if A >= 2**(data_width-1) then
      A_s := A - 2**(data_width);
   else
      A_s := A;
   end if;
   if B >= 2**(data_width-1) then
      B_s := B - 2**(data_width);
   else
      B_s := B;
   end if;
   T_s := A_s+B_s+Boolean'Pos( CI );
   if T >= 2**data_width then
      R := T - 2**data_width;
      CO := TRUE;
   else
      R := T;
      CO := FALSE;
   end if;
   if T mod 2**data_width = 0 then
      Z := TRUE;
   else
      Z := FALSE;
   end if;
   if T_s < 0 then
      N := TRUE;
   else
      N := FALSE;
   end if;
   if (T_s < -2**(data_width-1)) or (T_s >= 2**(data_width-1)) then
      O := TRUE;
   else
      O := FALSE;
   end if; 
end EXEC_ADDC;

end CPU_DEFS_PACK;
