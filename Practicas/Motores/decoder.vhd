library IEEE; use IEEE.STD_LOGIC_1164.ALL;

entity decoder is
  port(
    control,duty: in std_logic_vector(7 downto 0);
    pwm_in_M1,pwm_in_M2: in std_logic;
    R_PWM_M1,L_PWM_M1,R_PWM_M2,L_PWM_M2: out std_logic;
    R_EN_M1,L_EN_M1,R_EN_M2,L_EN_M2: out std_logic );
end;

architecture rtl of decoder is
  signal en_code: std_logic_vector(1 downto 0);
  signal sel1,dir1,sel2,dir2: std_logic;
  signal en_r1,en_l1,en_r2,en_l2: std_logic;
begin
  en_code<=control(5 downto 4);
  sel2<=control(3); dir2<=control(2);
  sel1<=control(1); dir1<=control(0);

  -- 00 ninguno / 01 M1 / 10 M2 / 11 ambos
  en_r1<='1' when ((en_code="01" or en_code="11") and dir1='0') else '0';
  en_l1<='1' when ((en_code="01" or en_code="11") and dir1='1') else '0';
  en_r2<='1' when ((en_code="10" or en_code="11") and dir2='0') else '0';
  en_l2<='1' when ((en_code="10" or en_code="11") and dir2='1') else '0';

  R_EN_M1<=en_r1; L_EN_M1<=en_l1;
  R_EN_M2<=en_r2; L_EN_M2<=en_l2;

  R_PWM_M1<=pwm_in_M1 when (sel1='0' and en_r1='1') else '0';
  L_PWM_M1<=pwm_in_M1 when (sel1='1' and en_l1='1') else '0';
  R_PWM_M2<=pwm_in_M2 when (sel2='0' and en_r2='1') else '0';
  L_PWM_M2<=pwm_in_M2 when (sel2='1' and en_l2='1') else '0';
end;
