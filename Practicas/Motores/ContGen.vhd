library IEEE; use IEEE.STD_LOGIC_1164.ALL; use IEEE.NUMERIC_STD.ALL;

entity ContGen is
  generic ( Nbits: integer:=4; Cuenta_Fin: integer:=15 );
  port ( clk,CE,RST: in std_logic;
         conteo: out std_logic_vector(Nbits-1 downto 0);
         CEO:    out std_logic );
end;

architecture rtl of ContGen is
  signal cnt: unsigned(Nbits-1 downto 0):=(others=>'0');
begin
  conteo<=std_logic_vector(cnt);
  CEO <= '1' when (cnt=Cuenta_Fin and CE='1') else '0';

  process(clk) begin
    if rising_edge(clk) then
      if RST='1' then cnt<=(others=>'0');
      elsif CE='1' then
        if cnt=Cuenta_Fin then cnt<=(others=>'0');
        else cnt<=cnt+1;
        end if;
      end if;
    end if;
  end process;
end;
