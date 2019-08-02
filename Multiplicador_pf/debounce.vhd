----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:19:11 07/24/2019 
-- Design Name: 
-- Module Name:    debounce - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity debounce is

Generic(counter_size : integer := 2); --19,(7 to simulated) tamaño de cuenta, perido para establecer el estado del button

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

	process(clk,counter,button_in,button_prev,outB)
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

