library IEEE;
use IEEE.STD_LOGIC_1164.ALL; use IEEE.NUMERIC_STD.ALL;

entity spi_slave_sync is
  generic ( DATA_WIDTH:integer:=8; TIMEOUT_MAX:integer:=1000 );
  port (
    clk_sys, reset_sys : in std_logic;
    SCLK_in, MOSI_in, SS_in : in std_logic;
    data_out  : out std_logic_vector(DATA_WIDTH-1 downto 0);
    data_valid: out std_logic;
    MISO_byte : out std_logic_vector(DATA_WIDTH-1 downto 0));
end;

architecture rtl of spi_slave_sync is
  signal sclk1,sclk2,mosi1,mosi2,ss1,ss2: std_logic:='0';
  signal prev_sclk,sclk_rise: std_logic:='0';
  type tS is (IDLE,SHIFT,WAIT_H); signal st:tS:=IDLE;
  signal sh,final: std_logic_vector(DATA_WIDTH-1 downto 0):=(others=>'0');
  signal bit_cnt: integer range 0 to DATA_WIDTH:=0;
  signal timeout: integer range 0 to TIMEOUT_MAX:=0;
  signal v: std_logic:='0';
begin
  -- sincronizar entradas
  process(clk_sys) begin
    if rising_edge(clk_sys) then
      sclk1<=SCLK_in; sclk2<=sclk1;
      mosi1<=MOSI_in; mosi2<=mosi1;
      ss1  <=SS_in;   ss2  <=ss1;
    end if;
  end process;

  -- flanco subida SCLK
  process(clk_sys) begin
    if rising_edge(clk_sys) then
      sclk_rise<='0';
      if sclk2='1' and prev_sclk='0' then sclk_rise<='1'; end if;
      prev_sclk<=sclk2;
    end if;
  end process;

  -- FSM
  process(clk_sys,reset_sys) begin
    if reset_sys='1' then
      st<=IDLE; sh<=(others=>'0'); final<=(others=>'0');
      bit_cnt<=0; timeout<=0; v<='0';
    elsif rising_edge(clk_sys) then
      v<='0';
      case st is
        when IDLE =>
          if ss2='0' then st<=SHIFT; bit_cnt<=0; timeout<=0; end if;

        when SHIFT =>
          if ss2='0' then
            if sclk_rise='1' then
              -- desplaza MSB-first correcto
              sh <= sh(DATA_WIDTH-2 downto 0) & mosi2;
              bit_cnt <= bit_cnt + 1;
            end if;
            if timeout<TIMEOUT_MAX then timeout<=timeout+1;
            else st<=WAIT_H;
            end if;
          else
            if bit_cnt = DATA_WIDTH then
              final<=sh; v<='1';
            end if;
            st<=WAIT_H;
          end if;

        when WAIT_H =>
          if ss2='1' then st<=IDLE; timeout<=0; end if;
      end case;
    end if;
  end process;

  data_out<=final; data_valid<=v; MISO_byte<=final;
end;
