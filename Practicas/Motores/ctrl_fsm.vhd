library IEEE; use IEEE.STD_LOGIC_1164.ALL;

entity ctrl_fsm is
  port ( clk,reset_sys,ss: in std_logic;
         LOAD_CTRL,LOAD_PWM: out std_logic );
end;

architecture rtl of ctrl_fsm is
  type S is (EXPECT_CTRL,EXPECT_DUTY); signal st:S:=EXPECT_CTRL;
begin
  process(clk) begin
    if rising_edge(clk) then
      if reset_sys='1' then
        st<=EXPECT_CTRL; LOAD_CTRL<='0'; LOAD_PWM<='0';
      else
        LOAD_CTRL<='0'; LOAD_PWM<='0';
        if ss='1' then
          case st is
            when EXPECT_CTRL => LOAD_CTRL<='1'; st<=EXPECT_DUTY;
            when EXPECT_DUTY => LOAD_PWM <='1'; st<=EXPECT_CTRL;
          end case;
        end if;
      end if;
    end if;
  end process;
end;
