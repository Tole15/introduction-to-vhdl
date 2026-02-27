library IEEE;
use IEEE.STD_LOGIC_1164.ALL; use IEEE.NUMERIC_STD.ALL;
use work.pwm_pkg.all;

entity pwm_module is
  generic ( CNT_WIDTH: natural:=4; DUTY_WIDTH: natural:=4; DIV_CONST: natural:=155 );
  port ( clk,rst,load: in std_logic;
         ancho: in std_logic_vector(DUTY_WIDTH-1 downto 0);
         pwm: out std_logic );
end;

architecture rtl of pwm_module is
  constant DIV_WIDTH: natural:=clog2(DIV_CONST+1);
  signal ce_pwm,reload: std_logic;
  signal cnt: std_logic_vector(CNT_WIDTH-1 downto 0);
  signal shadow,cmp: std_logic_vector(DUTY_WIDTH-1 downto 0);
begin
  u_div: entity work.ContGen
    generic map(Nbits=>DIV_WIDTH, Cuenta_Fin=>DIV_CONST)
    port map(clk, '1', rst, open, ce_pwm);

  u_cnt: entity work.ContGen
    generic map(Nbits=>CNT_WIDTH, Cuenta_Fin=>15)
    port map(clk, ce_pwm, rst, cnt, reload);

  u_sh : entity work.regP generic map(WIDTH=>DUTY_WIDTH)
    port map(clk, rst, load, ancho, shadow);

  u_cmp: entity work.regP generic map(WIDTH=>DUTY_WIDTH)
    port map(clk, rst, reload, shadow, cmp);

  pwm <= '1' when unsigned(cnt) < unsigned(cmp) else '0';
end;
