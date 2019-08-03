library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplier is
    Generic	 ( NBITS : integer := 24  );
	
    port (
        i_a:  in  std_logic_vector  (NBITS - 1 downto 0);
        i_b:  in  std_logic_vector  (NBITS - 1 downto 0);
        o_p:  out std_logic_vector (2*NBITS - 1 downto 0)
    );
end entity;

architecture multiplier_array of multiplier is
    type bit_array_N is array (0 to NBITS - 1) of unsigned (NBITS - 1 downto 0) ; -- tipo de dato matriz NBITS*NBITS
	 type bit_array_2N is array (0 to NBITS - 1) of unsigned (2*NBITS - 1 downto 0); --NBITS*2NBITS
    
    signal partial_products : bit_array_N := (others => (others => '0'));	--  en todas las filas lleveme todas las columnas a 0
	 signal ext_partial_products_shifted : bit_array_2N := (others => (others => '0'));
    signal b_bits : bit_array_N := (others => (others => '0'));
    signal sum: unsigned (2*NBITS - 1 downto 0) := (others => '0');
	 
begin

    -- AND Array Multiplies

create_b_arrays : process (i_b)
	begin
        for i in 0 to NBITS - 1 loop
            b_bits(i) <= (others => i_b(i)); -- cada fila es la extension de un bit de b
        end loop;
	end process;


create_partial_products : process(b_bits,i_a)
    begin
			for i in 0 to NBITS - 1 loop
				partial_products(i) <= unsigned(i_a) and b_bits(i);--multiplicacion de a con cada bit de b
			end loop;
	end process;
	
	
shift_extend_partial_products: process(partial_products)
	begin
		for i in 0 to NBITS - 1 loop -- resize : cambia el tamaño de N  a 2N    _  shift_left: LO CORRE i VECES A la izquierda
				-- resize hace la extension con signo , como son unsigned agrega 0s
			ext_partial_products_shifted(i) <= shift_left(resize(partial_products(i), 2*NBITS), i);
		end loop;
	end process;
	
sum_all : process (ext_partial_products_shifted)

	variable accumulator : unsigned(2*NBITS - 1 downto 0):=(others => '0');--sumar
	
	begin
		accumulator := (others => '0'); -- this line is motherfuckingly important
		-- WE NEED TO RESET THE ACCUMULATOR EACH TIME THE PROCESS RUNS
		for i in 0 to NBITS - 1 loop --Sin'range
			accumulator := accumulator + ext_partial_products_shifted(i);
		end loop;
		
		sum <= accumulator;
	end process;

result: process(sum)
	begin
		o_p <= std_logic_vector(sum);-- conversion a vector logico de la suma
	end process;
	 
	 

end architecture;
