--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:34:18 08/02/2019
-- Design Name:   
-- Module Name:   Y:/xilinx/frank (2)/proyecto_2.5/Multiplicador_pf/test_top.vhd
-- Project Name:  Multiplicador_pf
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: top
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
 
ENTITY test_top IS
END test_top;
 
ARCHITECTURE behavior OF test_top IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT top
    PORT(
         reset : IN  std_logic;
         clk : IN  std_logic;
         Dato : IN  std_logic_vector(7 downto 0);
         button : IN  std_logic;
         C_p : OUT  std_logic_vector(7 downto 0);
         LED_out : OUT  std_logic_vector(6 downto 0);
         Anode_Activate : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
   
	 procedure PressButton (signal button : inout std_logic) is 
 
 begin
		wait for 500 ns;
		
		button <= '1';
		
		wait for 500 ns;
		button <= '0';
 end procedure;
	
	procedure InputData(
						signal inAllData : inout std_logic_vector (31 downto 0);
						signal data : inout std_logic_vector(7 downto 0);
						signal button : inout std_logic
						) is
					
	begin
	
		data <= inAllData(31 downto 24);
		PressButton(button);
		
		data <= inAllData(23 downto 16);
		PressButton(button);
		
		data <= inAllData(15 downto 8);
		PressButton(button);
		
		data <= inAllData(7 downto 0);
		PressButton(button);
		
	end procedure;

	procedure InputAndShow( --takes about 20us
						signal inAllDataA : inout std_logic_vector (31 downto 0);
						signal inALlDataB : inout std_logic_vector (31 downto 0);
						signal data : inout std_logic_vector(7 downto 0);
						signal button : inout std_logic
						) is
					
	begin
	
		--Middle
		PressButton(button);-- this needs to be below A_I, B_I for some reason
		
		-- Input A
		InputData(inAllDataA,data,button);
		-- Input B
		InputData(inAllDataB,data,button);
		
		-- Middle
		PressButton(button);
		
		-- Show
		PressButton(button);
		PressButton(button);
		PressButton(button);
		PressButton(button);
	
	end procedure;
   --Inputs
   signal reset : std_logic := '0';
   signal clk : std_logic := '0';
   signal Dato : std_logic_vector(7 downto 0) := (others => '0');
   signal button : std_logic := '0';

 	--Outputs
   signal C_p : std_logic_vector(7 downto 0);
   signal LED_out : std_logic_vector(6 downto 0);
   signal Anode_Activate : std_logic_vector(3 downto 0);
	
	--Auxiliar Signals
	signal A_I : std_logic_vector (31 downto 0) :=(others => '0');
	signal B_I : std_logic_vector (31 downto 0) :=(others => '0');
	
   -- Clock period definitions
   constant clk_period : time := 10 ns;
	

 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: top PORT MAP (
          reset => reset,
          clk => clk,
          Dato => Dato,
          button => button,
          C_p => C_p,
          LED_out => LED_out,
          Anode_Activate => Anode_Activate
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
	

   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;
		-- insert stimulus here 
		
		-- Both Inputs Zero
		-- Should get Zero
		
		InputAndShow(A_I,B_I,Dato,button); -- 0
		
		
		A_I <= "11000001100100000000000000000000"; -- -18 : 0xC190000
		B_I <= "01000001000110000000000000000000"; -- 9.5 : 0x41180000
		InputAndShow(A_I,B_I,Dato,button); -- -171 : 0xC32B0000
		-- C_I <= "11000011 00101011 00000000 00000000"; -- -171 : 0xC32B0000
      
		A_I <= "01000001010110000000000000000000"; -- 13.5 : 0x41580000
		B_I <= "11000001100100000000000000000000"; -- -18 : 0xc1900000
		
		InputAndShow(A_I,B_I,Dato,button); -- -243 : 0xc3730000
		-- C_I <= "11000011 01110011 00000000 00000000"; -- -243 : 0xc3730000
		
		A_I <= "01000001010110000000000000000000"; -- 13.5 : 0x41580000
		B_I <= "11000001110100000000000000000000"; -- -26 : 0xc1d00000
		InputAndShow(A_I,B_I,Dato,button); -- -351 : 0xc3af8000
		-- C_I <= "11000011 10101111 10000000 00000000"; -- -351 : 0xc3af8000
		
		A_I <= "01000001010110000000000000000000"; -- 13.5 : 0x41580000
		B_I <= "11111111100000000000000000000000"; -- -inf : 0xff800000
		InputAndShow(A_I,B_I,Dato,button);  -- -inf : 0xff800000
		-- C_I <= "11111111 10000000 00000000 00000000" -- -inf : 0xff800000
		
		A_I <= "01000001010110000000000000000000"; -- 13.5 : 0x41580000
		B_I <= "01111111100000000000000000000000"; -- +inf : 0x7f800000
		InputAndShow(A_I,B_I,Dato,button); -- +inf : 0x7f800000
		-- C_I <= "01111111 10000000 00000000 00000000"; -- +inf : 0x7f800000
		
		A_I <= "01000001010110000000000000000000"; -- 13.5 : 0x41580000
		B_I <= "11111111110000000000000000000001"; -- NaN : 0xffc00001
		InputAndShow(A_I,B_I,Dato,button); -- NaN : 0x7fffffff (NaN)
		-- C_I <= "01111111 11111111 11111111 11111111";-- NaN : 0x7fffffff
      wait;
   end process;

END;
