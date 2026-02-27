library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package pwm_pkg is
  function clog2(val : natural) return natural;
end;

package body pwm_pkg is
  function clog2(val : natural) return natural is
    variable v : natural := val-1; variable n : natural := 0;
  begin
    while v>0 loop v := v/2; n := n+1; end loop;
    return n;
  end;
end;
