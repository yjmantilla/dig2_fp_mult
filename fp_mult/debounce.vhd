
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity debounce is

Generic(counter_size : integer := 7); --19 to ms(7 to simulated) tamaño de cuenta, perido para establecer el estado del button

    Port ( button_in : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           --reset : in  STD_LOGIC;
           button_out : out  STD_LOGIC);
end debounce;

architecture Behavioral of debounce is

signal button_prev   : std_logic := '0';
--vector del tamaño del contador, inicializado en cero
signal counter : std_logic_vector(Counter_SIZE downto 0) := (others => '0');
signal outB : std_logic := '0';
begin

	process(clk,button_in,button_prev,outB)
   begin
		if (clk'event and clk='1') then -- otra forma de definir flano de subida
			if (button_prev xor button_in) = '1' then-- si son diferentes
				counter <= (others => '0');--reinicie counter
				button_prev <= button_in;
				--outB <= '0';
			elsif (counter(Counter_SIZE) = '0') then-- si el vector en la posicion counter_size (19) es 0
				counter <= counter + 1;
			else
				outB <= button_prev;
				--button_out <= button_prev;
			end if;
		end if;
		button_out <= outB;

   end process;
	

end Behavioral;
-------------------------------------------------------------------
--library ieee;
--use ieee.std_logic_1164.all;
--use ieee.std_logic_unsigned.all;

--entity debouncer_top is
--    port (
--        clk	: in std_logic;
--	btn_in	: in std_logic;
--	btn_out	: out std_logic);
--end debouncer_top;

--architecture beh of debouncer_top is
--   constant CNT_SIZE : integer := 19;
--    signal btn_prev   : std_logic := '0';
--    signal counter    : std_logic_vector(CNT_SIZE downto 0) := (others => '0');

--begin
--    process(clk)
--    begin
--	if (clk'event and clk='1') then
--		if (btn_prev xor btn_in) = '1' then
--			counter <= (others => '0');
--			btn_prev <= btn_in;
--		elsif (counter(CNT_SIZE) = '0') then
--			counter <= counter + 1;
--        	else
--			btn_out <= btn_prev;
--		end if;
--	end if;
--    end process;
--end beh;