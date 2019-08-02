--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:54:19 07/25/2019
-- Design Name:   
-- Module Name:   Y:/xilinx/Frank/Frank/proyecto2/test_button_module.vhd
-- Project Name:  proyecto2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: button_module
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
 
ENTITY test_button_module IS
END test_button_module;
 
ARCHITECTURE behavior OF test_button_module IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT button_module
	 
    PORT(
         in_button : IN  std_logic;
         in_switch_vector : IN  std_logic_vector(7 downto 0);
         in_reset : IN  std_logic;
         in_clk : IN  std_logic;
         out_switch_vector : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal in_button : std_logic := '0';
   signal in_switch_vector : std_logic_vector(7 downto 0) := (others => '0');
   signal in_reset : std_logic := '0';
   signal in_clk : std_logic := '0';

 	--Outputs
   signal out_switch_vector : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant in_clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: button_module PORT MAP (
          in_button => in_button,
          in_switch_vector => in_switch_vector,
          in_reset => in_reset,
          in_clk => in_clk,
          out_switch_vector => out_switch_vector
        );

   -- Clock process definitions
   in_clk_process :process
   begin
		in_clk <= '0';
		wait for in_clk_period/2;
		in_clk <= '1';
		wait for in_clk_period/2;
   end process;
	
	button_process :process
   begin
		in_button <= '0';
		wait for in_clk_period*500;
		in_button <= '1';
		wait for in_clk_period*500;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for in_clk_period*10;

      -- insert stimulus here 
		in_switch_vector <= "10101010";
		wait for 10 ns;
		
      wait;
   end process;

END;
