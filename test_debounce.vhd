--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:17:30 07/22/2019
-- Design Name:   
-- Module Name:   /home/boole/Desktop/Frank/proyecto2/test_debounce.vhd
-- Project Name:  proyecto2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: debounce
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
 
ENTITY test_debounce IS
END test_debounce;
 
ARCHITECTURE behavior OF test_debounce IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT debounce
    PORT(
         button_in : IN  std_logic;
         clk : IN  std_logic;
         button_out : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal button_in : std_logic := '0';
   signal clk : std_logic := '0';

 	--Outputs
   signal button_out : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: debounce PORT MAP (
          button_in => button_in,
          clk => clk,
          button_out => button_out
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
	button_in_process : process
	
	begin
	
	for i in 0 to 20 loop
	
		Button_in <= '1';
		
		wait for 2*clk_period;
		
		Button_in <= '0';
		
		wait for 2*clk_period;
	end loop;	
	
		Button_in <= '1';
		
		wait for 10 us;
		
		Button_in <= '0';
		
		wait for 10 us;

	end process;
   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 

		-- swait for 
      wait;
   end process;

END;
