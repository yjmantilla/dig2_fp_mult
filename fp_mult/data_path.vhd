----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:09:22 07/17/2019 
-- Design Name: 
-- Module Name:    data_path - Behavioral 
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

entity data_path is

	Generic
	(
		constant NBITS_DATA_PART: natural:=8;
		constant NBITS:natural:= 32;
		constant NBITS_OP:natural:=3;
		
		    -- Use opcode way for controlling data path
        constant OP_INPUT_A : STD_LOGIC_VECTOR := "000";
        constant OP_INPUT_B : STD_LOGIC_VECTOR := "001";
        constant OP_MULTIPLY : STD_LOGIC_VECTOR := "010";
        constant OP_SHOW_C : STD_LOGIC_VECTOR := "011";
        constant OP_RESET_STATE : STD_LOGIC_VECTOR := "111";
        constant OP_RESET_PART : STD_LOGIC_VECTOR := "111";
        constant OP_PART_3 : STD_LOGIC_VECTOR := "011";
        constant OP_PART_2 : STD_LOGIC_VECTOR := "010";
        constant OP_PART_1 : STD_LOGIC_VECTOR := "001";
        constant OP_PART_0 : STD_LOGIC_VECTOR := "000";
        constant CODE_A : STD_LOGIC_VECTOR := "1010";
        constant CODE_B : STD_LOGIC_VECTOR := "1011";
        constant CODE_C : STD_LOGIC_VECTOR := "1100";
        constant CODE_F : STD_LOGIC_VECTOR := "1111"
	);
--critical path?
	PORT
	(
		i_clk: in std_logic;
		i_data_part: in std_logic_vector(NBITS_DATA_PART - 1 downto 0);
		i_op_state : in std_logic_vector(NBITS_OP - 1 downto 0);
		i_op_part: in std_logic_vector(NBITS_OP - 1 downto 0); 
		o_data_part: out std_logic_vector(NBITS_DATA_PART -1 downto 0);--to leds
		i_pulse : in std_logic
		
	);
end data_path;

architecture Behavioral of data_path is

	COMPONENT fp_multiplier
	
	    Generic
	 (
		NBITS_FP : integer := 32;
		NBITS_FP_FRAC : integer := 23;
		NBITS_FP_EXP : integer := 8;
		BIAS : integer := 127
    );
	 
	PORT(
		i_fp_a : IN std_logic_vector(31 downto 0);
		i_fp_b : IN std_logic_vector(31 downto 0);          
		o_fp_p : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;
	

constant A_3 : STD_LOGIC_VECTOR (5 downto 0) := (OP_INPUT_A & OP_PART_3);
constant A_2 : STD_LOGIC_VECTOR (5 downto 0) := (OP_INPUT_A & OP_PART_2);
constant A_1 : STD_LOGIC_VECTOR (5 downto 0) := (OP_INPUT_A & OP_PART_1);
constant A_0 : STD_LOGIC_VECTOR (5 downto 0) := (OP_INPUT_A & OP_PART_0);
constant B_3 : STD_LOGIC_VECTOR (5 downto 0) := (OP_INPUT_B & OP_PART_3);
constant B_2 : STD_LOGIC_VECTOR (5 downto 0) := (OP_INPUT_B & OP_PART_2);
constant B_1 : STD_LOGIC_VECTOR (5 downto 0) := (OP_INPUT_B & OP_PART_1);
constant B_0 : STD_LOGIC_VECTOR (5 downto 0) := (OP_INPUT_B & OP_PART_0);
constant C_3 : STD_LOGIC_VECTOR (5 downto 0) := (OP_SHOW_C & OP_PART_3);
constant C_2 : STD_LOGIC_VECTOR (5 downto 0) := (OP_SHOW_C & OP_PART_2);
constant C_1 : STD_LOGIC_VECTOR (5 downto 0) := (OP_SHOW_C & OP_PART_1);
constant C_0 : STD_LOGIC_VECTOR (5 downto 0) := (OP_SHOW_C & OP_PART_0);
signal A : std_logic_vector(NBITS - 1 downto 0):= (others => '0');
signal B : std_logic_vector(NBITS - 1 downto 0):= (others => '0');
signal dummy : std_logic_vector(NBITS - 1 downto 0):= (others => '0');
signal C : std_logic_vector(NBITS - 1 downto 0):= (others => '0');
signal OP : std_logic_vector (5 downto 0) := (others => '1');
signal show : std_logic_vector (NBITS_DATA_PART - 1 downto 0) := (others => '0');
--signal enable_A: std_logic := '0';
--signal enable_B: std_logic := '0';
--signal enable_C: std_logic := '0';
--signal enable_MULTIPLY: std_logic := '0';
--signal enable_RESET: std_logic := '0';



-- las senales se actualizan de manera secuencial	
begin

	Inst_fp_multiplier: fp_multiplier PORT MAP(
		i_fp_a => A,
		i_fp_b => B,
		o_fp_p => C
		);
get_op: process(i_clk)
	begin
		if i_clk'event and i_clk='1' then
			OP <= i_op_state & i_op_part;
		end if;
	end process;

decide: process(OP,i_clk,i_data_part,i_pulse)
	begin
	if i_clk'event and i_clk='1' then
		if(i_pulse = '1') then

		case OP is
			when (A_3) =>
				A(31 downto 24) <= i_data_part;
				show <= i_data_part;
			when (A_2) =>
				A(23 downto 16) <= i_data_part;
				show <= i_data_part;
			when (A_1) =>
				A(15 downto 8) <= i_data_part;
				show <= i_data_part;
			when (A_0) =>
				A(7 downto 0) <= i_data_part;
				show <= i_data_part;
			when (B_3) =>
				B(31 downto 24) <= i_data_part;
				show <= i_data_part;
			when (B_2) =>
				B(23 downto 16) <= i_data_part;
				show <= i_data_part;
			when (B_1) =>
				B(15 downto 8) <= i_data_part;
				show <= i_data_part;
			when (B_0) =>
				B(7 downto 0) <= i_data_part;
				show <= i_data_part;
			when (C_3) =>
				show <= C(31 downto 24);
			when (C_2) =>
				show <= C(23 downto 16);
			when (C_1) =>
				show <= C(15 downto 8);
			when (C_0) =>
				show <= C(7 downto 0);
			when others =>
				show <= "00000000";
			end case;
			end if;
		end if;
	end process;

show_it: process(i_clk,OP)
begin
	if RISING_EDGE(i_clk) then
		o_data_part <= show;
	end if;
end process;

end Behavioral;

