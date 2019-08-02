--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   00:09:01 07/18/2019
-- Design Name:   
-- Module Name:   Y:/xilinx/fp_mul/test_control.vhd
-- Project Name:  fp_mul
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: control_path
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
 
ENTITY test_control IS
END test_control;
 
ARCHITECTURE behavior OF test_control IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT control_path
    PORT(
         I_CLK : IN  std_logic;
         I_RESET : IN  std_logic;
         I_BUTTON_NEXT : IN  std_logic;
         I_BUTTON_PREV : IN  std_logic;
         I_RESULT_READY : IN  std_logic;
         O_OP_STATE : OUT  std_logic_vector(2 downto 0);
         O_OP_PART : OUT  std_logic_vector(2 downto 0);
         O_DISP : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal I_CLK : std_logic := '0';
   signal I_RESET : std_logic := '0';
   signal I_BUTTON_NEXT : std_logic := '0';
   signal I_BUTTON_PREV : std_logic := '0';
   signal I_RESULT_READY : std_logic := '0';

 	--Outputs
   signal O_OP_STATE : std_logic_vector(2 downto 0);
   signal O_OP_PART : std_logic_vector(2 downto 0);
   signal O_DISP : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant I_CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: control_path PORT MAP (
          I_CLK => I_CLK,
          I_RESET => I_RESET,
          I_BUTTON_NEXT => I_BUTTON_NEXT,
          I_BUTTON_PREV => I_BUTTON_PREV,
          I_RESULT_READY => I_RESULT_READY,
          O_OP_STATE => O_OP_STATE,
          O_OP_PART => O_OP_PART,
          O_DISP => O_DISP
        );

   -- Clock process definitions
   I_CLK_process :process
   begin
		I_CLK <= '0';
		wait for I_CLK_period/2;
		I_CLK <= '1';
		wait for I_CLK_period/2;
   end process;
 
	NEXT_process: process
	begin
		I_BUTTON_NEXT <= '0';
		wait for i_clk_period*4; -- 12 = timer_green + timer_yellow to introduce a phase
		I_BUTTON_NEXT <= '1';
		wait for i_clk_period/2;
	end process;
	
	RESULT_process: process
	begin
		I_RESULT_READY <= '0';
		wait for i_clk_period*25; -- 12 = timer_green + timer_yellow to introduce a phase
		I_RESULT_READY <= '1';
		wait for i_clk_period/2;
	end process;
   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for I_CLK_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
