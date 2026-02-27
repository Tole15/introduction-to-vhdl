library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.funPackage.all;

entity ContGen is
	generic (cuentaFinal:integer:=4);
	port (clk: in std_logic;
			CE: in std_logic;
			RST: in std_logic;
			conteo: out std_logic_vector (nbitsFun(cuentaFinal)-1 downto 0);
			CEO: out std_logic);
end ContGen;

architecture Behavioral of ContGen is
		signal countaux: std_logic_vector (nbitsFun(cuentaFinal)-1 downto 0):=(others=>'0');
		signal TC: std_logic;
	begin
		conteo <= countaux;
		TC <= '1' when countaux=cuentaFinal else '0';
		process(clk)	
			begin
			if rising_edge(clk) then
				if RST='1' then
				countaux <= (others=>'0');
				elsif CE='1' then
					if TC='1' then
						countaux <= (others=>'0');
					else
						countaux <= countaux + 1;
					end if;
				end if;
			end if;
		end process;
		CEO <= '1' when TC='1' and CE='1' else '0';
end Behavioral;