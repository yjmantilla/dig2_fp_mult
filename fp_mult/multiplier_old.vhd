
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity multiplier is
end multiplier;

architecture Behavioral of multiplier is

begin

-- add and shift, easier to describe, problem it needs N cycles of the clock
-- array multiplier, do it in 1 cycle, it takes N*propagation_time, you need to wait for that time 
-- check max frequency given by xilinx
-- you may use array from std_logic_vector
-- A(0) <= A(0) + B(0)
-- A(0) + A(1) +++... A(N)
-- use for 1 0 to 23, from 1 because from zero will give 2 times de 1st
-- A(0) <= A(0) + A(i)
end Behavioral;

