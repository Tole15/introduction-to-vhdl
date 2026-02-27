library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity contBCD29 is
	Port (clk: in std_logic;
			Unidades: out std_logic_vector (3 downto 0);
			Decenas: out std_logic_vector (1 downto 0);
			CEO: out std_logic);
end contBCD29;

architecture Behavioral of contBCD29 is
	signal CEO_uni:std_logic;
	component ContGen is
		generic(Nbits: integer:=4;		--Número de bits para almacenar la cuenta
			Cuenta_Fin: integer:=15);	--Máximo número que alcanza la cuenta
		port(clk: in std_logic;			--Señal de reloj
			CE: in std_logic;			--Clock Enable
			RST: in std_logic;		--RESET Síncrono
			conteo: out std_logic_vector (Nbits-1 downto 0);	--Cuenta
			CEO: out std_logic); 			--Clock Enable Output
	end component;
begin
	--Contador de unidades de 0 a 9
	cont_uni: ContGen 	generic map(Nbits=>4,Cuenta_Fin=>9)
			Port map (clk=>clk, CE=>'1', RST=>'0', conteo=>Unidades, CEO=>CEO_uni);	
	--Contador de unidades de 0 a 2
	cont_dec: ContGen 	generic map(Nbits=>2,Cuenta_Fin=>2)
			Port map(clk=>clk, CE=>CEO_uni, RST=>'0', conteo=>Decenas, CEO=>CEO);
end Behavioral;

