library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity button_module is

    Port ( in_button : in STD_LOGIC;
			  in_switch_vector : in  STD_LOGIC_VECTOR (7 downto 0);
           in_reset : in  STD_LOGIC;
			  in_clk : in  STD_LOGIC;
			  out_switch_vector : out STD_LOGIC_VECTOR(7 downto 0)
			 ); 

	ATTRIBUTE LOC: STRING;
	ATTRIBUTE LOC OF in_clk : SIGNAL IS "B8";	-- system clock 50 MHz (Nexys2)
	ATTRIBUTE LOC OF in_button : SIGNAL IS "H13";	-- button 3
	ATTRIBUTE LOC OF out_switch_vector: SIGNAL IS "R4,F4,P15,E17,K14,K15,J15,J14";
	ATTRIBUTE LOC OF in_switch_vector : SIGNAL IS "R17,N17,L13,L14,K17,K18,H18,G18"; 


	
end button_module;

architecture Behavioral of button_module is

signal debounced_button  : std_logic := '0';
signal pulsed_button  : std_logic := '0';
signal flip : std_logic := '0';
signal vector : STD_LOGIC_VECTOR (7 downto 0):= "00000000";

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



power_leds: process(flip,vector) --in_clk
	begin
		if (flip = '1') then --and flip = '1'
			out_switch_vector <= vector;
		else
			out_switch_vector <= "00000000";
		end if;
	end process;
	
flip_process: process (in_clk,pulsed_button,flip)
	begin
		flip <= flip;
		if(pulsed_button = '1' and RISING_EDGE(in_clk)) then --and 
			flip <= not flip;
		--else 
			--
		end if;
		
	end process;
	
	vector <= in_switch_vector;
end Behavioral;

