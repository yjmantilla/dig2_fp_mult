library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity debounce_and_pulse is

    Port ( 
			  in_button : in STD_LOGIC;
           in_reset : in  STD_LOGIC;
			  in_clk : in  STD_LOGIC;
			  o_dp_button: out STD_LOGIC
			 ); 

	
end debounce_and_pulse;

architecture Behavioral of debounce_and_pulse is

signal debounced_button  : std_logic := '0';
signal pulsed_button  : std_logic := '0';

	COMPONENT debounce
	
	Generic(counter_size : integer := 19); --19 to ms(7 to simulated) tamaño de cuenta, perido para establecer el estado del button

	
	PORT(
		button_in : IN std_logic;
		clk : IN std_logic;          
		button_out : OUT std_logic
		);
	END COMPONENT;

	COMPONENT Pulse
	PORT(
		Button_in : IN std_logic;
		clk : IN std_logic;          
		don_pulso : OUT std_logic
		);
	END COMPONENT;


begin

	Inst_debounce: debounce PORT MAP(
		button_in => in_button,
		clk => in_clk,
		button_out => debounced_button
	);
	
		Inst_Pulse: Pulse PORT MAP(
		Button_in => debounced_button,
		clk => in_clk,
		don_pulso => pulsed_button
	);

process
begin 
		o_dp_button <= pulsed_button;
end process;


end Behavioral;

