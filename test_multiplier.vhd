--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:25:17 07/23/2019
-- Design Name:   
-- Module Name:   Y:/xilinx/fp_mul/test_multiplier.vhd
-- Project Name:  fp_mul
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: multiplier
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
use ieee.numeric_std.all;

 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test_multiplier IS
END test_multiplier;
 
ARCHITECTURE behavior OF test_multiplier IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT multiplier
    PORT(
         i_a : IN  std_logic_vector(23 downto 0);
         i_b : IN  std_logic_vector(23 downto 0);
         o_p : OUT  std_logic_vector(47 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal i_a : std_logic_vector(23 downto 0) := (others => '0');
   signal i_b : std_logic_vector(23 downto 0) := (others => '0');

 	--Outputs
   signal o_p : std_logic_vector(47 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 

BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: multiplier PORT MAP (
          i_a => i_a,
          i_b => i_b,
          o_p => o_p
        );

   -- Clock process definitions

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 10 ns;	
		i_a <= std_logic_vector (to_unsigned(245, i_a'length));
		i_b <= std_logic_vector (to_unsigned(175, i_b'length));
		wait for 10 ns;
      wait for 100 ns;
   end process;
	
	MONITOR:
    process (o_p)
    begin
        if now > 10 ns then
            report "a = " & natural'image (to_integer(unsigned(i_a)));
            report "b = " & natural'image (to_integer(unsigned(i_b)));
            report "product = " & natural'image (to_integer(unsigned(o_p)));
            report "expected product = " & 
                    natural'image (to_integer(unsigned(i_a) * unsigned(i_b)));
        end if;
    end process;

END;
