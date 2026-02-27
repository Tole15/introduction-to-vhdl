library IEEE;
use IEEE.STD_LOGIC_1164.ALL; use IEEE.NUMERIC_STD.ALL;
use work.pwm_pkg.all;

entity motor_ctrl_top is
  port(
    clk_sys, reset_sys : in  std_logic;
    SCLK_in, MOSI_in, SS_in_raw : in std_logic;
    -- Motor 1
    R_PWM_M1, L_PWM_M1 : out std_logic;
    R_EN_M1 , L_EN_M1  : out std_logic;
    -- Motor 2
    R_PWM_M2, L_PWM_M2 : out std_logic;
    R_EN_M2 , L_EN_M2  : out std_logic
  );
end;

architecture rtl of motor_ctrl_top is
  signal rst_sync : std_logic;
  signal ss1,ss2,SS_in : std_logic:='1';
  signal spi_byte: std_logic_vector(7 downto 0);
  signal byte_valid: std_logic;
  signal ld_ctrl,ld_pwm: std_logic;
  signal control,duty : std_logic_vector(7 downto 0);
  signal pwm1,pwm2 : std_logic;
begin
  -- reset síncrono
  process(clk_sys,reset_sys)
  begin
    if reset_sys='1' then rst_sync<='1';
    elsif rising_edge(clk_sys) then rst_sync<='0';
    end if;
  end process;

  -- filtro SS
  process(clk_sys) begin
    if rising_edge(clk_sys) then
      ss1<=SS_in_raw; ss2<=ss1;
      if ss1=ss2 then SS_in<=ss1; end if;
    end if;
  end process;

  -- SPI
  u_spi: entity work.spi_slave_sync
    port map(clk_sys,rst_sync,SCLK_in,MOSI_in,SS_in,
             spi_byte,byte_valid,open);

  -- FSM
  u_fsm: entity work.ctrl_fsm
    port map(clk_sys,rst_sync,byte_valid,ld_ctrl,ld_pwm);

  -- registros
  u_rc: entity work.regP generic map(WIDTH=>8)
    port map(clk_sys,rst_sync,ld_ctrl,spi_byte,control);
  u_rd: entity work.regP generic map(WIDTH=>8)
    port map(clk_sys,rst_sync,ld_pwm ,spi_byte,duty);

  -- PWMs
  u_pwm1: entity work.pwm_module
    generic map(CNT_WIDTH=>4,DUTY_WIDTH=>4,DIV_CONST=>155)
    port map(clk_sys,rst_sync,ld_pwm,duty(7 downto 4),pwm1);

  u_pwm2: entity work.pwm_module
    generic map(CNT_WIDTH=>4,DUTY_WIDTH=>4,DIV_CONST=>155)
    port map(clk_sys,rst_sync,ld_pwm,duty(3 downto 0),pwm2);

  -- Decoder
  u_dec: entity work.decoder
    port map(control,duty,pwm1,pwm2,
             R_PWM_M1,L_PWM_M1,R_PWM_M2,L_PWM_M2,
             R_EN_M1,L_EN_M1,R_EN_M2,L_EN_M2);
end;
