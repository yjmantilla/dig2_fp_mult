----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:06:07 08/01/2019 
-- Design Name: 
-- Module Name:    display_module - Behavioral 
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
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity display_module is

Port ( clock_100Mhz : in STD_LOGIC;-- 100Mhz clock on Basys 3 FPGA board
           reset : in STD_LOGIC; -- reset
           Anode_Activate : out STD_LOGIC_VECTOR (3 downto 0);-- 4 Anode signals
			  in_LED_BCD_0: in STD_LOGIC_VECTOR (3 downto 0);
			  in_LED_BCD_1: in STD_LOGIC_VECTOR (3 downto 0);
           LED_out : out STD_LOGIC_VECTOR (6 downto 0));-- Cathode patterns of 7-segment display
			  
end display_module;

architecture Behavioral of display_module is
signal refresh_counter: STD_LOGIC_VECTOR (19 downto 0):=(others => '0');
-- creating 10.5ms refresh period
signal LED_activating_counter: std_logic_vector(1 downto 0):="00";
signal LED_BCD : STD_LOGIC_VECTOR (3 downto 0):="1111";
-- the other 2-bit for creating 4 LED-activating signals
-- count         0    ->  1  ->  2  ->  3
-- activates    LED1    LED2   LED3   LED4
-- and repeat
begin

process(LED_BCD)
begin
    case LED_BCD is
    when "0000" => LED_out <= "0000001"; -- "0"     
    when "0001" => LED_out <= "1001111"; -- "1" 
    when "0010" => LED_out <= "0010010"; -- "2" 
    when "0011" => LED_out <= "0000110"; -- "3" 
    when "0100" => LED_out <= "1001100"; -- "4" 
    when "0101" => LED_out <= "0100100"; -- "5" 
    when "0110" => LED_out <= "0100000"; -- "6" 
    when "0111" => LED_out <= "0001111"; -- "7" 
    when "1000" => LED_out <= "0000000"; -- "8"     
    when "1001" => LED_out <= "0000100"; -- "9" 
    when "1010" => LED_out <= "0000010"; -- a
    when "1011" => LED_out <= "1100000"; -- b
    when "1100" => LED_out <= "0110001"; -- C
    when "1101" => LED_out <= "1000010"; -- d
    when "1110" => LED_out <= "0110000"; -- E
    when "1111" => LED_out <= "0111000"; -- F
	 when others => LED_out <= "1111111"; 
    end case;
end process;
-- 7-segment display controller
-- generate refresh period of 10.5ms



process(clock_100Mhz,reset)
begin 
    if(reset='1') then
        refresh_counter <= (others => '0');
    elsif(rising_edge(clock_100Mhz)) then
        refresh_counter <= refresh_counter + 1;
		  
    end if;
end process;

LED_activating_counter <= refresh_counter(19 downto 18);
 

-- 4-to-1 MUX to generate anode activating signals for 4 LEDs 
process(LED_activating_counter,in_LED_BCD_0,in_LED_BCD_1)
begin
    case LED_activating_counter is
    when "00" =>
        Anode_Activate <= "0111"; 
        -- activate LED1 and Deactivate LED2, LED3, LED4
        LED_BCD <= in_LED_BCD_0;
        -- the first hex digit of the 16-bit number
    when "01" =>
        Anode_Activate <= "1011"; 
        -- activate LED2 and Deactivate LED1, LED3, LED4
        LED_BCD <= in_LED_BCD_1;
        -- the second hex digit of the 16-bit number
    when "10" =>
        --Anode_Activate <= "1101";
		  Anode_Activate <= "1111"; 		  
        -- activate LED3 and Deactivate LED2, LED1, LED4
        LED_BCD <= "1111";
        -- the third hex digit of the 16-bit number
    when "11" =>
        --Anode_Activate <= "1110";
		  Anode_Activate <= "1111";
        -- activate LED4 and Deactivate LED2, LED3, LED1
        LED_BCD <= "1111";
        -- the fourth hex digit of the 16-bit number
	 when others => Anode_Activate <= "1111"; 
    end case;
end process;


end Behavioral;

