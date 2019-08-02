--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:19:30 08/01/2019
-- Design Name:   
-- Module Name:   Y:/xilinx/fp_mult/test_data_path.vhd
-- Project Name:  fp_mul
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: data_path
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test_data_path IS
	 	Generic
	(
		NBITS_DATA_PART: integer:=8;
		NBITS:integer:= 32;
		NBITS_OP:integer:=3;
		
		    -- Use opcode way for controlling data path
        OP_INPUT_A : STD_LOGIC_VECTOR := "000";
        OP_INPUT_B : STD_LOGIC_VECTOR := "001";
        OP_MULTIPLY : STD_LOGIC_VECTOR := "010";
        OP_SHOW_C : STD_LOGIC_VECTOR := "011";
        OP_RESET_STATE : STD_LOGIC_VECTOR := "111";
        OP_RESET_PART : STD_LOGIC_VECTOR := "111";
        OP_PART_3 : STD_LOGIC_VECTOR := "011";
        OP_PART_2 : STD_LOGIC_VECTOR := "010";
        OP_PART_1 : STD_LOGIC_VECTOR := "001";
        OP_PART_0 : STD_LOGIC_VECTOR := "000";
        CODE_A : STD_LOGIC_VECTOR := "1010";
        CODE_B : STD_LOGIC_VECTOR := "1011";
        CODE_C : STD_LOGIC_VECTOR := "1100";
        CODE_F : STD_LOGIC_VECTOR := "1111"
	);
END test_data_path;
 
ARCHITECTURE behavior OF test_data_path IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT data_path
	 
	 	Generic
	(
		NBITS_DATA_PART: natural:=8;
		NBITS:natural:= 32;
		NBITS_OP:natural:=3;
		
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
	
    PORT(
         i_clk : IN  std_logic;
         i_data_part : IN  std_logic_vector(7 downto 0);
         i_op_state : IN  std_logic_vector(2 downto 0);
         i_op_part : IN  std_logic_vector(2 downto 0);
         o_data_part : OUT  std_logic_vector(7 downto 0);
			i_pulse : IN std_LOGIC
        );
    END COMPONENT;
    

   --Inputs
   signal i_clk : std_logic := '0';
   signal i_data_part : std_logic_vector(7 downto 0) := (others => '0');
   signal i_op_state : std_logic_vector(2 downto 0) := (others => '1');
   signal i_op_part : std_logic_vector(2 downto 0) := (others => '1');
	signal i_pulse : std_logic := '0';

 	--Outputs
   signal o_data_part : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant i_clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: data_path PORT MAP (
          i_clk => i_clk,
          i_data_part => i_data_part,
          i_op_state => i_op_state,
          i_op_part => i_op_part,
          o_data_part => o_data_part,
			 i_pulse => i_pulse
        );

   -- Clock process definitions
   i_clk_process :process
   begin
		i_clk <= '0';
		wait for i_clk_period/2;
		i_clk <= '1';
		wait for i_clk_period/2;
   end process;
	
--	   i_pulse_process :process
--   begin
--		i_pulse <= '0';
--		wait for i_clk_period*10;
--		i_pulse <= '1';
--		wait for i_clk_period/2;
--   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for i_clk_period*20;	

      wait for i_clk_period*10;

      -- insert stimulus here 
		i_op_state <= OP_INPUT_A;
		i_op_part <= OP_PART_3;
		i_data_part <= "11000001";
		
		wait for i_clk_period*4;
		
		i_pulse <= '1';
		
		wait for i_clk_period*4;
		
		i_pulse <= '0';
		
		wait for i_clk_period*20;
		
		i_op_state <= OP_INPUT_A;
		i_op_part <= OP_PART_2;
		i_data_part <= "10010000";
		
		wait for i_clk_period*4;
		
		i_pulse <= '1';
		
		wait for i_clk_period*4;
		
		i_pulse <= '0';
		
		wait for i_clk_period*20;
		
		i_op_state <= OP_INPUT_A;
		i_op_part <= OP_PART_1;
		i_data_part <= "00000000";
		
		wait for i_clk_period*4;
		
		i_pulse <= '1';
		
		wait for i_clk_period*4;
		
		i_pulse <= '0';

		wait for i_clk_period*20;
		
		i_op_state <= OP_INPUT_A;
		i_op_part <= OP_PART_0;
		i_data_part <= "00000000";
		
		wait for i_clk_period*4;
		
		i_pulse <= '1';
		
		wait for i_clk_period*4;
		
		i_pulse <= '0';
		

		wait for i_clk_period*20;
		
		i_op_state <= OP_INPUT_B;
		i_op_part <= OP_PART_3;
		i_data_part <= "01000001";
		
		wait for i_clk_period*4;
		
		i_pulse <= '1';
		
		wait for i_clk_period*4;
		
		i_pulse <= '0';
		
		wait for i_clk_period*20;
		
		
		i_op_state <= OP_INPUT_B;
		i_op_part <= OP_PART_2;
		i_data_part <= "00011000";
		
		wait for i_clk_period*4;
		
		i_pulse <= '1';
		
		wait for i_clk_period*4;
		
		i_pulse <= '0';
		
		wait for i_clk_period*20;
		
		i_op_state <= OP_INPUT_B;
		i_op_part <= OP_PART_1;
		i_data_part <= "00000000";
		
		wait for i_clk_period*4;
		
		i_pulse <= '1';
		
		wait for i_clk_period*4;
		
		i_pulse <= '0';

		wait for i_clk_period*20;
		
		i_op_state <= OP_INPUT_B;
		i_op_part <= OP_PART_0;
		i_data_part <= "00000000";
		
		wait for i_clk_period*4;
		
		i_pulse <= '1';
		
		wait for i_clk_period*4;
		
		i_pulse <= '0';
		
		wait for i_clk_period*20;
		
		i_op_state <= OP_SHOW_C;
		i_op_part <= OP_PART_3;
		
		wait for i_clk_period*4;
		
		i_pulse <= '1';
		
		wait for i_clk_period*4;
		
		i_pulse <= '0';
		
		wait for i_clk_period*20;
		
		i_op_state <= OP_SHOW_C;
		i_op_part <= OP_PART_2;
		
		wait for i_clk_period*4;
		
		i_pulse <= '1';
		
		wait for i_clk_period*4;
		
		i_pulse <= '0';
		
		wait for i_clk_period*20;

		i_op_state <= OP_SHOW_C;
		i_op_part <= OP_PART_1;
		
		wait for i_clk_period*4;
		
		i_pulse <= '1';
		
		wait for i_clk_period*4;
		
		i_pulse <= '0';
		
		wait for i_clk_period*20;
		
		i_op_state <= OP_SHOW_C;
		i_op_part <= OP_PART_0;

		wait for i_clk_period*4;
		
		i_pulse <= '1';
		
		wait for i_clk_period*4;
		
		i_pulse <= '0';
		
		wait for i_clk_period*20;
				
      wait;
   end process;

END;
