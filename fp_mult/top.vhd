----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:06:17 07/17/2019 
-- Design Name: 
-- Module Name:    top - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is

    Port ( i_reset : in  STD_LOGIC;
			  i_clk : in  STD_LOGIC;
			  i_data : in  STD_LOGIC_VECTOR (7 downto 0);
			  i_button : in STD_LOGIC;
			  o_leds : out STD_LOGIC_VECTOR(7 downto 0)
			  );
	ATTRIBUTE LOC: STRING;
	ATTRIBUTE LOC OF i_clk : SIGNAL IS "B8"; -- system clock 50 MHz (Nexys2)
	ATTRIBUTE LOC OF i_data  : SIGNAL IS "R17,N17,L13,L14,K17,K18,H18,G18"; 
	ATTRIBUTE LOC OF i_button : SIGNAL IS "H13";	
	ATTRIBUTE LOC OF i_reset : SIGNAL IS "B18";	
   ATTRIBUTE LOC OF o_leds : SIGNAL IS "R4,F4,P15,E17,K14,K15,J15,J14";
	

	
end top;

architecture Behavioral of top is

	
	signal clk_div : std_logic := '0';
	signal mr_pulse : std_logic := '0';
	signal result_ready: std_logic := '0';
   signal s_OP_STATE : STD_LOGIC_VECTOR (2 downto 0);
   signal s_OP_PART : STD_LOGIC_VECTOR (2 downto 0);
   signal s_DISP : STD_LOGIC_VECTOR (7 downto 0); --00 in reset

	
	COMPONENT freq_div
	Generic(MAX_COUNT :INTEGER := 3);
	PORT(
		i_clk : IN std_logic;
		i_reset : IN std_logic;          
		o_clk : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT debounce_and_pulse
	PORT(
		in_button : IN std_logic;
		in_reset : IN std_logic;
		in_clk : IN std_logic;          
		o_dp_button : OUT std_logic
		);
	END COMPONENT;
	


	COMPONENT control_path
	PORT(
		I_CLK : IN std_logic;
		I_RESET : IN std_logic;
		I_BUTTON_NEXT : IN std_logic;
		I_RESULT_READY : IN std_logic;          
		O_OP_STATE : OUT std_logic_vector(2 downto 0);
		O_OP_PART : OUT std_logic_vector(2 downto 0);
		O_DISP : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
	
	
	COMPONENT data_path
	PORT(
		i_clk : IN std_logic;
		i_data_part : IN std_logic_vector(7 downto 0);
		i_op_state : IN std_logic_vector(2 downto 0);
		i_op_part : IN std_logic_vector(2 downto 0);
		i_pulse : IN std_logic;          
		o_data_part : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

begin

	Inst_freq_div: freq_div PORT MAP(
		i_clk => i_clk,
		o_clk => clk_div,
		i_reset => i_reset
	);
	
	Inst_debounce_and_pulse: debounce_and_pulse PORT MAP(
		in_button => i_button,
		in_reset => i_reset,
		in_clk => i_clk,
		o_dp_button => mr_pulse
	);
	
		Inst_control_path: control_path PORT MAP(
		I_CLK => clk_div,
		I_RESET => i_reset,
		I_BUTTON_NEXT => mr_pulse,
		I_RESULT_READY => result_ready ,
		O_OP_STATE => s_OP_STATE,
		O_OP_PART => s_OP_PART,
		O_DISP => s_DISP
	);
	
		Inst_data_path: data_path PORT MAP(
		i_clk => clk_div,
		i_data_part => i_data,
		i_op_state => s_OP_STATE,
		i_op_part => s_OP_PART,
		o_data_part => o_leds,
		i_pulse => mr_pulse
	);
end Behavioral;

