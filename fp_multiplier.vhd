----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:16:37 07/23/2019 
-- Design Name: 
-- Module Name:    fp_multiplier - Behavioral 
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fp_multiplier is

    Generic
	 (
		NBITS_FP : integer := 32;
		NBITS_FP_FRAC : integer := 23;
		NBITS_FP_EXP : integer := 8;
		BIAS : integer := 127
		-- sign is 1 bit always
    );
	
    port (
        i_fp_a:  in  std_logic_vector  (NBITS_FP - 1 downto 0);
        i_fp_b:  in  std_logic_vector  (NBITS_FP - 1 downto 0);
        o_fp_p:  out std_logic_vector (NBITS_FP - 1 downto 0)
    );
end fp_multiplier;



architecture Behavioral of fp_multiplier is

--signal A : unsigned (NBITS_FP - 1 downto 0):= (others => '0');
--signal B : unsigned (NBITS_FP - 1 downto 0):= (others => '0');
signal A_FRAC : unsigned (NBITS_FP_FRAC + 1 - 1 downto 0):= (others => '0');
signal B_FRAC : unsigned (NBITS_FP_FRAC + 1 - 1 downto 0):= (others => '0');
signal P_FRAC : unsigned (2*(NBITS_FP_FRAC + 1) - 1 downto 0):= (others => '0');
signal P_FRAC_LOGIC :  std_logic_vector (2*(NBITS_FP_FRAC + 1) - 1 downto 0):= (others => '0');
signal P_FRAC_NORM : unsigned (2*(NBITS_FP_FRAC + 1) - 1 downto 0):= (others => '0');
signal P_FRAC_DIM : unsigned (NBITS_FP_FRAC - 1 downto 0):= (others => '0');
signal A_EXP : unsigned (NBITS_FP_EXP - 1 downto 0) := (others => '0');
signal B_EXP : unsigned (NBITS_FP_EXP - 1 downto 0) := (others => '0');
signal P_EXP : unsigned (NBITS_FP_EXP - 1 downto 0) := (others => '0');
signal A_SIGN : unsigned (0 downto 0):= "0"; -- it would be nice to know how to slice to a single bit (parentheses wont work)
signal B_SIGN : unsigned (0 downto 0):= "0";
signal P_SIGN : unsigned (0 downto 0):= "0";
signal PRODUCT_EXPONENT_CORRECTION : std_logic := '0';

COMPONENT multiplier
	Generic ( NBITS : integer:= NBITS_FP_FRAC + 1); --extend 1 for integer part
	PORT(
		i_a : IN std_logic_vector(NBITS - 1 downto 0);
		i_b : IN std_logic_vector(NBITS - 1 downto 0);          
		o_p : OUT std_logic_vector(2*NBITS - 1 downto 0)
		);
	END COMPONENT;


begin
	Inst_multiplier: multiplier 
	
	PORT MAP(
		i_a => std_logic_vector(A_FRAC),
		i_b => std_logic_vector(B_FRAC),
		o_p => P_FRAC_LOGIC
	);

-- cast_data: process(i_fp_a,i_fp_b) not necessary
	get_frac: process (P_FRAC_LOGIC)
		begin
			P_FRAC <= unsigned(P_FRAC_LOGIC);
		end process;
	
	slice_data: process(i_fp_a, i_fp_b)
		begin
			A_FRAC(NBITS_FP_FRAC - 1  downto 0) <= unsigned(i_fp_a(NBITS_FP_FRAC - 1  downto 0));
			B_FRAC(NBITS_FP_FRAC - 1  downto 0) <= unsigned(i_fp_b(NBITS_FP_FRAC - 1  downto 0));
			A_EXP <= unsigned(i_fp_a(NBITS_FP_EXP + NBITS_FP_FRAC - 1 downto NBITS_FP_FRAC));
			B_EXP <= unsigned(i_fp_b(NBITS_FP_EXP + NBITS_FP_FRAC - 1 downto NBITS_FP_FRAC));
			A_SIGN <= unsigned(i_fp_a(NBITS_FP - 1 downto NBITS_FP - 1));
			B_SIGN <= unsigned(i_fp_b(NBITS_FP - 1 downto NBITS_FP - 1));
		end process;
		
	concatenate_1 : process(A_FRAC(NBITS_FP_FRAC - 1  downto 0),B_FRAC(NBITS_FP_FRAC - 1  downto 0))
		begin
			A_FRAC(NBITS_FP_FRAC downto NBITS_FP_FRAC) <= "1";
			B_FRAC(NBITS_FP_FRAC downto NBITS_FP_FRAC) <= "1";
		end process;
		
	normalization: process (P_FRAC) -- fractional point always between 2*(NBITS_FP_FRAC) and 2*(NBITS_FP_FRAC) - 1  
		begin
			-- 11.XXXXXX
			if(P_FRAC(2*(NBITS_FP_FRAC + 1) - 1 downto 2*(NBITS_FP_FRAC + 1) - 1) = "1") then
				P_FRAC_NORM <= shift_right(P_FRAC, 1); -- we add (+1) to the exponent
				PRODUCT_EXPONENT_CORRECTION <= '1'; -- FRAC is then 2*(NBITS_FP_FRAC + 1) - 1 - 1 downto 2*(NBITS_FP_FRAC + 1) - 1 - 1 - NBITS_FP_FRAC + 1
			else -- 01.XXXXXXX 
				P_FRAC_NORM <= P_FRAC; -- FRAC is then 2*(NBITS_FP_FRAC + 1) - 1 - 2 downto 2*(NBITS_FP_FRAC + 1) - 1 - 2 - NBITS_FP_FRAC + 1
				PRODUCT_EXPONENT_CORRECTION <= '0'; -- We dont add anything to the exponent
			end if;
		end process;
		
	diminish_frac: process(P_FRAC_NORM,PRODUCT_EXPONENT_CORRECTION)
		begin
			-- it is the same for both, remember we shifted so the position of each bit changes
			--if (PRODUCT_EXPONENT_CORRECTION = '1') then
			--	P_FRAC_DIM <= P_FRAC_NORM(2*(NBITS_FP_FRAC + 1) - 1 - 1 downto 2*(NBITS_FP_FRAC + 1) - 1 - 1 - NBITS_FP_FRAC + 1);
			--else
				P_FRAC_DIM <= P_FRAC_NORM(2*(NBITS_FP_FRAC + 1) - 1 - 2 downto 2*(NBITS_FP_FRAC + 1) - 1 - 2 - NBITS_FP_FRAC + 1);
			--end if; 
		end process;
		
	calc_exponent: process (PRODUCT_EXPONENT_CORRECTION,A_EXP,B_EXP)
	-- what did we learn boys ? combinatorial loops are dangerous
	variable exp : unsigned (NBITS_FP_EXP - 1 downto 0) := (others => '0');
	begin
		exp := (others => '0');
		exp := A_EXP + B_EXP - to_unsigned(BIAS,P_EXP'length);
		if (PRODUCT_EXPONENT_CORRECTION = '1') then
			exp := exp + 1;
		end if;
		
		P_EXP <= exp;
	end process;
	
	calc_sign: process(A_SIGN,B_SIGN)
	begin
			P_SIGN <= A_SIGN xor B_SIGN;
	end process;
	
	results: process(P_SIGN,P_EXP,P_FRAC_DIM)
	begin
			o_fp_p <= std_logic_vector(P_SIGN & P_EXP & P_FRAC_DIM);
	end process;
	

end Behavioral;

