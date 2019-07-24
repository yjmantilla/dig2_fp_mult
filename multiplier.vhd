library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplier is
	
    port (
        i_a:  in  std_logic_vector  (23 downto 0);
        i_b:  in  std_logic_vector  (23 downto 0);
        o_p:  out std_logic_vector (47  downto 0)
    );
end entity;

architecture multiplier_array of multiplier is
    type bit_array_N is array (0 to 23) of unsigned (23 downto 0) ;
	 type bit_array_2N is array (0 to 23) of unsigned (47 downto 0);
    
    signal partial_products : bit_array_N := (others => (others => '0'));
	 signal ext_partial_products : bit_array_2N := (others => (others => '0'));
	 signal ext_partial_products_shifted : bit_array_2N := (others => (others => '0'));
    signal b_bits : bit_array_N := (others => (others => '0'));
    signal sum: unsigned (47 downto 0) := (others => '0');
	 --signal flag_arrays_ready : std_logic := '0';

begin

    -- AND Array Multiplies
-- 
create_b_arrays : process (i_b)
	begin
        for i in 0 to 23 loop
            b_bits(i) <= (others => i_b(i));
        end loop;
	end process;

create_partial_products : process(b_bits)
    begin
         --RESIZE(v,n)
            --sum <= sum + partial_products(i);
			for i in 0 to 23 loop
				partial_products(i) <= unsigned(i_a) and b_bits(i);
			end loop;
	end process;
	
extend_partial_products: process(partial_products)
	begin
			for i in 0 to 23 loop
				ext_partial_products(i) <= resize(partial_products(i), 48); --slv_16'length
			end loop;
	end process;
	
shift_partial_products: process(ext_partial_products)
	begin
		for i in 0 to 23 loop
			ext_partial_products_shifted(i) <= shift_left(ext_partial_products(i), i);
		end loop;
	end process;
	
sum_all : process (ext_partial_products_shifted)

	variable accumulator : unsigned(47 downto 0):=(others => '0');
	begin
		for i in 0 to 23 loop --Sin'range
			accumulator := accumulator + ext_partial_products_shifted(i);
		end loop;
		
		sum <= accumulator;
	end process;
    
	 o_p <= std_logic_vector(sum);
	 

end architecture;
