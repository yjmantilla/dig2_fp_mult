
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Control is
   Port (
		reset : in  STD_LOGIC;
		clk : in  STD_LOGIC;
		Dato : in  STD_LOGIC_VECTOR (7 downto 0);
		button : in STD_LOGIC;
		C_p : out STD_LOGIC_VECTOR(7 downto 0);
		LED_out:   out   STD_LOGIC_VECTOR (6 downto 0);
		Anode_Activate : out STD_LOGIC_VECTOR (3 downto 0)
	);

	ATTRIBUTE LOC: STRING;
	ATTRIBUTE LOC OF clk : SIGNAL IS "B8";-- system clock 50 MHz (Nexys2)
	ATTRIBUTE LOC OF Dato  : SIGNAL IS "R17,N17,L13,L14,K17,K18,H18,G18"; 
	ATTRIBUTE LOC OF button : SIGNAL IS "H13";	
   ATTRIBUTE LOC OF C_p : SIGNAL IS "R4,F4,P15,E17,K14,K15,J15,J14";
	ATTRIBUTE LOC OF Anode_Activate  : SIGNAL IS "F15,C18,H17,F17"; 
	ATTRIBUTE LOC OF LED_out : SIGNAL IS "L18,F18,D17,D16,G14,J17,H14,C17";
	ATTRIBUTE LOC OF reset : SIGNAL IS "B18";
end Control;

architecture Behavioral of Control is

	type state_type is (INPUT,MULT,SHOW);
		signal current_state : state_type := INPUT;
		signal next_state : state_type := INPUT;

--------señales de control----------------
	signal s_in1 :STD_LOGIC := '0';
	signal s_in2 : STD_LOGIC := '0';
	signal s_in3 : STD_LOGIC := '0';
	--next three are driven by datapath
	signal s_data_ready : STD_LOGIC ;--:= '0';
	signal s_multi_ready : STD_LOGIC ;--:= '0';
	signal s_show_ready : STD_LOGIC ;--:= '0';
	
	signal clk_div : STD_LOGIC := '0';
	signal dpart : std_logic_vector (3 downto 0):= "1111";
	signal dstate : std_logic_vector (3 downto 0):= "1111";

-------- componentes a usar-------------------------------------------------


	COMPONENT data_path
	PORT(
		Dato : IN std_logic_vector(7 downto 0);
		clk : IN std_logic;
		button : IN std_logic;
		in1 : IN std_logic;
		in2 : IN std_logic;
		in3 : IN std_logic;          
		data_ready : OUT std_logic;
		multi_ready : OUT std_logic;
		show_ready : OUT std_logic;
		display : OUT std_logic_vector(3 downto 0);
		display_part : OUT std_logic_vector(3 downto 0);
		C_p : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
	
	COMPONENT freq_div
	Generic(MAX_COUNT :INTEGER := 3);
	PORT(
		i_clk : IN std_logic;
		i_reset : IN std_logic;          
		o_clk : OUT std_logic
		);
	END COMPONENT;
	
		COMPONENT display_module
	PORT(
		clock_100Mhz : IN std_logic;
		reset : IN std_logic;
		in_LED_BCD_0 : IN std_logic_vector(3 downto 0);
		in_LED_BCD_1 : IN std_logic_vector(3 downto 0);          
		Anode_Activate : OUT std_logic_vector(3 downto 0);
		LED_out : OUT std_logic_vector(6 downto 0)
		);
	END COMPONENT;
-----------------------------------------------------------------------------
begin

-----------------mapeo de componentes----------------------------------------
	Inst_data_path : data_path PORT MAP
	(	Dato => Dato,
		clk =>clk_div,
		button => button,	
		in1 => s_in1,
		in2 => s_in2,
		in3 => s_in3,
		data_ready => s_data_ready,
	   multi_ready => s_multi_ready,
		show_ready => s_show_ready,		
		display => dstate,
		display_part => dpart,
		C_p => C_p
	);





	Inst_freq_div: freq_div PORT MAP
	(
		i_clk => clk,
		o_clk => clk_div,
		i_reset => reset
	);
	
		Inst_display_module: display_module PORT MAP(
		clock_100Mhz => clk,
		reset => reset,
		Anode_Activate => Anode_Activate,
		in_LED_BCD_0 => dstate,
		in_LED_BCD_1 => dpart,
		LED_out => LED_out
	);
	
------------------------------------------------------------------------------- 

	
	maquina_control: process(clk_div,reset,current_state, s_data_ready, s_multi_ready,s_show_ready)
	begin
		if(reset = '1') then 
			current_state <= INPUT;
		elsif (RISING_EDGE(clk_div))then
			current_state <= next_state;
		end if;
			
		s_in1 <= '0';
		s_in2 <= '0';
		s_in3 <= '0';
		case current_state is
			
			when INPUT =>
				s_in1 <= '1';
				if (s_data_ready = '1') then 
					next_state <= MULT;
					s_in1 <= '0';
				else
					next_state <= INPUT;
				end if;
				
			when MULT =>
				s_in2 <= '1';
				if (s_multi_ready = '1') then
					next_state <= SHOW;
					s_in2 <= '0';
				else
					next_state <= MULT;
				end if;
					
			when SHOW =>
				s_in3 <= '1';
				if (s_show_ready = '1') then
					next_state <= input;
					s_in3 <= '0';
				else
					next_state <= show;
				end if;
				--next_state <= SHOW; --dudas acá
		end case;
		
	end process;
	
end Behavioral;



