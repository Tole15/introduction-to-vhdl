library IEEE; use IEEE.STD_LOGIC_1164.ALL;

entity regP is
  generic ( WIDTH:natural:=8 );
  port ( clk,rst,load: in std_logic;
         d:  in std_logic_vector(WIDTH-1 downto 0);
         q:  out std_logic_vector(WIDTH-1 downto 0) );
end;

architecture rtl of regP is
  signal r: std_logic_vector(WIDTH-1 downto 0):=(others=>'0');
begin
  process(clk) begin
    if rising_edge(clk) then
      if rst='1' then r<=(others=>'0');
      elsif load='1' then r<=d;
      end if;
    end if;
  end process;
  q<=r;
end;
