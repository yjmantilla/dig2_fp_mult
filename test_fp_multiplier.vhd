--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:09:48 07/24/2019
-- Design Name:   
-- Module Name:   Y:/xilinx/fp_mult/test_fp_multiplier.vhd
-- Project Name:  fp_mul
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: fp_multiplier
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
 
ENTITY test_fp_multiplier IS
END test_fp_multiplier;
 
ARCHITECTURE behavior OF test_fp_multiplier IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT fp_multiplier
    PORT(
         i_fp_a : IN  std_logic_vector(31 downto 0);
         i_fp_b : IN  std_logic_vector(31 downto 0);
         o_fp_p : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal i_fp_a : std_logic_vector(31 downto 0) := (others => '0');
   signal i_fp_b : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal o_fp_p : std_logic_vector(31 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: fp_multiplier PORT MAP (
          i_fp_a => i_fp_a,
          i_fp_b => i_fp_b,
          o_fp_p => o_fp_p
        );

 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 10 ns;	
		-- insert stimulus here 
		i_fp_a <= "11000001100100000000000000000000"; -- -18
		i_fp_b <= "01000001000110000000000000000000"; -- 9.5
		-- -171
		
      wait for 10 ns;
		i_fp_a <= "01000001010110000000000000000000"; -- 13.5
		i_fp_b <= "11000001100100000000000000000000"; -- -18
		-- -243
		
		wait for 10 ns;
		i_fp_a <= "01000001010110000000000000000000"; -- 13.5
		i_fp_b <= "11000001110100000000000000000000"; -- -26
		-- -351
		-- there are still problems with normalization
		
		wait for 10 ns;

      wait;
   end process;

END;
