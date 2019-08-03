library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity fp_multiplier is

    Generic
	 (
		NBITS_FP : integer := 32;
		NBITS_FP_FRAC : integer := 23;
		NBITS_FP_EXP : integer := 8;
		BIAS : integer := 127
		-- sign occupies 1 bit always
    );
	
    port (
        i_fp_a:  in  std_logic_vector  (NBITS_FP - 1 downto 0);
        i_fp_b:  in  std_logic_vector  (NBITS_FP - 1 downto 0);
        o_fp_p:  out std_logic_vector (NBITS_FP - 1 downto 0)
    );
end fp_multiplier;

architecture Behavioral of fp_multiplier is
--- unsigned permite realizar operaciones que otros tipos de datos no, facilitando el manejo de los datos
signal A_FRAC : unsigned (NBITS_FP_FRAC + 1 - 1 downto 0):= (others => '0');-- se extiende con un 1 (una posicion mas)
signal B_FRAC : unsigned (NBITS_FP_FRAC + 1 - 1 downto 0):= (others => '0');-- se extiende con un 1 (una posicion mas)
signal P_FRAC : unsigned (2*(NBITS_FP_FRAC + 1) - 1 downto 0):= (others => '0'); -- multiplicacion es de tamaño 2(nbits +1)
signal P_FRAC_LOGIC :  std_logic_vector (2*(NBITS_FP_FRAC + 1) - 1 downto 0):= (others => '0'); -- recibir el dato del ins_multiplier
signal P_FRAC_NORM : unsigned (2*(NBITS_FP_FRAC + 1) - 1 downto 0):= (others => '0'); -- normalizado
signal P_FRAC_DIM : unsigned (NBITS_FP_FRAC - 1 downto 0):= (others => '0'); -- se quitan los bits menos significativos
signal A_EXP : unsigned (NBITS_FP_EXP - 1 downto 0) := (others => '0');
signal B_EXP : unsigned (NBITS_FP_EXP - 1 downto 0) := (others => '0');
signal P_EXP : unsigned (NBITS_FP_EXP - 1 downto 0) := (others => '0');
signal A_SIGN : unsigned (0 downto 0):= "0"; -- it would be nice to know how to slice to a single bit (parentheses wont work)
signal B_SIGN : unsigned (0 downto 0):= "0";
signal P_SIGN : unsigned (0 downto 0):= "0";
signal PRODUCT_EXPONENT_CORRECTION : std_logic := '0'; -- bandera que dice si hay que corregir el exponente, ya que hubo movimiento del punto decimal 
-- constantes para hacer el codigo mas legible y para que sea generico

-- Si EXP es todo 1 y mantisa es 0 --> +- inf
-- Si exp es todo 1 y mantisa no es 0--> NaN
-- Si todo es 0 , es 0
constant ZERO : unsigned (NBITS_FP - 1 downto 0):= (others => '0');
constant NaN_EXP : unsigned (NBITS_FP_EXP - 1 downto 0):= (others => '1');
constant INF_EXP : unsigned (NBITS_FP_EXP - 1 downto 0):= (others => '1');
constant INF_FRAC : unsigned (NBITS_FP_FRAC - 1 downto 0):= (others => '0');
constant NaN_FRAC : unsigned (NBITS_FP_FRAC - 1 downto 0):= (others => '1'); -- La salida predeterminada cuando deseemos enviar NaN (ya que hay muchas formas de enviarlo) 

COMPONENT multiplier
	
	Generic ( NBITS : integer:= NBITS_FP_FRAC + 1); --extend 1 for integer part
	PORT(
		i_a : IN std_logic_vector(NBITS - 1 downto 0);
		i_b : IN std_logic_vector(NBITS - 1 downto 0);          
		o_p : OUT std_logic_vector(2*NBITS - 1 downto 0)
		);
	END COMPONENT;


begin
	Inst_multiplier: multiplier PORT MAP(
		i_a => std_logic_vector(A_FRAC),
		i_b => std_logic_vector(B_FRAC),
		o_p => P_FRAC_LOGIC
	);


	get_frac: process (P_FRAC_LOGIC) -- Pasar la multiplicacion de las mantisas a una señal unsigned
		begin
			P_FRAC <= unsigned(P_FRAC_LOGIC);
		end process;
	
	slice_data: process(i_fp_a, i_fp_b) -- se parte los vectores de entrada en exp, fraccion y signo
		begin
			A_FRAC(NBITS_FP_FRAC - 1  downto 0) <= unsigned(i_fp_a(NBITS_FP_FRAC - 1  downto 0));
			B_FRAC(NBITS_FP_FRAC - 1  downto 0) <= unsigned(i_fp_b(NBITS_FP_FRAC - 1  downto 0));
			A_EXP <= unsigned(i_fp_a(NBITS_FP_EXP + NBITS_FP_FRAC - 1 downto NBITS_FP_FRAC));
			B_EXP <= unsigned(i_fp_b(NBITS_FP_EXP + NBITS_FP_FRAC - 1 downto NBITS_FP_FRAC));
			A_SIGN <= unsigned(i_fp_a(NBITS_FP - 1 downto NBITS_FP - 1));
			B_SIGN <= unsigned(i_fp_b(NBITS_FP - 1 downto NBITS_FP - 1));
		end process;
		
	concatenate_a_1 : process(A_FRAC(NBITS_FP_FRAC - 1  downto 0),B_FRAC(NBITS_FP_FRAC - 1  downto 0))
		begin
			-- se pone un 1 en el ultimo bit
			A_FRAC(NBITS_FP_FRAC downto NBITS_FP_FRAC) <= "1";
			B_FRAC(NBITS_FP_FRAC downto NBITS_FP_FRAC) <= "1";
		end process;
		
	normalization: process (P_FRAC) -- fractional point always between 2*(NBITS_FP_FRAC) and 2*(NBITS_FP_FRAC) - 1  
		begin
			-- 11.XXXXXX
			if(P_FRAC(2*(NBITS_FP_FRAC + 1) - 1 downto 2*(NBITS_FP_FRAC + 1) - 1) = "1") then
				-- el punto queda fijo, se corre es el vector a la derecha para dividir por 2 
				P_FRAC_NORM <= shift_right(P_FRAC, 1); -- we add (+1) to the exponent
				PRODUCT_EXPONENT_CORRECTION <= '1'; -- FRAC is then 2*(NBITS_FP_FRAC + 1) - 1 - 1 downto 2*(NBITS_FP_FRAC + 1) - 1 - 1 - NBITS_FP_FRAC + 1
			else -- 01.XXXXXXX  ya esta normalizado
				P_FRAC_NORM <= P_FRAC; -- FRAC is then 2*(NBITS_FP_FRAC + 1) - 1 - 2 downto 2*(NBITS_FP_FRAC + 1) - 1 - 2 - NBITS_FP_FRAC + 1
				PRODUCT_EXPONENT_CORRECTION <= '0'; -- We dont add anything to the exponent
			end if;
		end process;
		
	diminish_frac: process(P_FRAC_NORM,PRODUCT_EXPONENT_CORRECTION)
		begin
			-- it is the same for both(with exponent correction or not), remember we shifted so the position of each bit changes
			-- se truncan los bits de menos peso
				P_FRAC_DIM <= P_FRAC_NORM(2*(NBITS_FP_FRAC + 1) - 1 - 2 downto 2*(NBITS_FP_FRAC + 1) - 1 - 2 - NBITS_FP_FRAC + 1);
		end process;
		
	calc_exponent: process (PRODUCT_EXPONENT_CORRECTION,A_EXP,B_EXP)
	-- what did we learn boys ? combinatorial loops are dangerous
	variable exp : unsigned (NBITS_FP_EXP - 1 downto 0) := (others => '0');
	begin
		exp := (others => '0'); -- expA + expB - BIAS
		exp := A_EXP + B_EXP - to_unsigned(BIAS,P_EXP'length);-- para restar el 127 lo paso a binario con tantos bits como los operandos involucrados
		if (PRODUCT_EXPONENT_CORRECTION = '1') then
			exp := exp + 1;-- se suma 1 al exponente
		end if;
		
		P_EXP <= exp;
	end process;
	
	calc_sign: process(A_SIGN,B_SIGN)
	begin
			P_SIGN <= A_SIGN xor B_SIGN; -- calcular signos
	end process;
	
	results: process(P_SIGN,P_EXP,P_FRAC_DIM,A_FRAC,B_FRAC,A_EXP,B_EXP,A_SIGN,B_SIGN,i_fp_a,i_fp_b)
	
	variable inf : unsigned(NBITS_FP - 1 downto 0):= (others => '0');
	variable A : unsigned(NBITS_FP - 1 downto 0):= (others => '0');
	variable B : unsigned(NBITS_FP - 1  downto 0):= (others => '0');
	--variable NaN : unsigned(NBITS_FP - 1 - 1 downto 0):= NaN_EXP & NaN_FRAC;
	begin
		-- test any for zero
		-- cannot use & inside ifs?
			inf := INF_EXP & "1" & INF_FRAC; -- tienen el 1 de 1.FRAC para poder comparar ( 1 de normalizada)
			A :=  A_EXP & A_FRAC;
			B := B_EXP & B_FRAC;
			
			if (A_EXP = NaN_EXP or B_EXP = NaN_EXP) then -- si hay algun NaN
				o_fp_p <= std_logic_vector("0" & NaN_EXP & NaN_FRAC); --NaN			
			elsif ( ((unsigned(i_fp_a) = ZERO) and B = inf) or ( (unsigned(i_fp_b) = ZERO) and A = inf )) then -- revisar si hay +- inf * 0
				o_fp_p <= std_logic_vector("0" & NaN_EXP & NaN_FRAC); --NaN
			elsif ((unsigned(i_fp_a) = ZERO) or (unsigned(i_fp_b) = ZERO)) then 
				o_fp_p <= std_logic_vector(ZERO); -- 0 * X = 0
			elsif ( A = inf or B = inf ) then
				o_fp_p <= std_logic_vector(P_SIGN & INF_EXP & INF_FRAC); -- +- inf
			else
				o_fp_p <= std_logic_vector(P_SIGN & P_EXP & P_FRAC_DIM);
			end if;
	end process;
	

end Behavioral;

