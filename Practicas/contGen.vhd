
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ContGen is
	generic (Nbits:integer:=4;			--Número de bits para almacenar la cuenta
	         Cuenta_Fin:integer:=15);--Máximo número que alcanza la cuenta
	port (clk: in std_logic;		--Señal de reloj
			CE: in std_logic;				--Clock Enable
			RST: in std_logic;			--RESET Síncrono
			conteo: out std_logic_vector (Nbits-1 downto 0);	--Cuenta
			CEO: out std_logic); 			--Clock Enable Output
end ContGen;

architecture Behavioral of ContGen is
		signal countaux: std_logic_vector (Nbits-1 downto 0):=(others=>'0');	--Cuenta auxiliar
		signal TC: std_logic; 			--TC: Bandera de la cuenta máxima
	begin
		conteo <= countaux;			--Al puerto cuenta se conecta la cuenta auxiliar
		TC <= '1' when countaux=Cuenta_Fin else '0'; --Terminal Count: 
		process(clk)	
			begin
			if rising_edge(clk) then				--Flanco positivo de clk 
				if RST='1' then						--Si está activo el RESET
				countaux <= (others=>'0');			--Se Resetea cuenta
				elsif CE='1' then						--CE='1'
					if TC='1' then						--Si se llega a la cuenta Final
						countaux <= (others=>'0');	--Se Resetea cuenta
					else									--Si no
						countaux <= countaux + 1;	--Se sigue incrementando la cuenta
					end if;
				end if;
			end if;
		end process;
		--La salida CEO
		CEO <= '1' when TC='1' and CE='1' else '0';		--Habilitador de la cuenta externa
end Behavioral;

