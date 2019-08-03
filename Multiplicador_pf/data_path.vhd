
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity data_path is
	Port(
		Dato : in  STD_LOGIC_VECTOR (7 downto 0);
		clk : in  STD_LOGIC;
		button : in STD_LOGIC;
		in1 : in STD_LOGIC;--bandera para comenzar a recibir datos
		in2 : in STD_LOGIC; --bandera para comenzar a multiplicar
		in3 : in STD_LOGIC; --bandera para comenzar a mostrar
		data_ready : out STD_LOGIC;
		multi_ready : out STD_LOGIC;
		show_ready : out STD_LOGIC;
		display:   out   STD_LOGIC_VECTOR (3 downto 0);
		display_part : out STD_LOGIC_VECTOR (3 downto 0);
		C_p : out STD_LOGIC_VECTOR(7 downto 0)
	);

end data_path;


architecture Behavioral of data_path is

	signal A :STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
	signal B :STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
	signal C :STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
	signal counter : integer := 0;
	signal counter1 : integer := 0;
	signal s_display: STD_LOGIC_VECTOR (3 downto 0):="1111";
	signal s_display_part : STD_LOGIC_VECTOR (3 downto 0):="1111";
	signal s_show_ready : STD_LOGIC := '0';
	signal s_multi_ready : STD_LOGIC := '0';
	signal s_data_ready : STD_LOGIC := '0';
	signal s_reset_counter : STD_LOGIC := '0';
	signal s_reset_counter1: STD_LOGIC := '0';


	
------Señales para el debounce y el pulso--------
	signal button_intermedio  : std_logic := '0';
	signal s_don_pulso : std_logic := '0';
	signal c_pp : STD_LOGIC_VECTOR(7 downto 0) :=(others => '0');
	
-------------------componentes ------------------------------------------
	component debounce
		Generic(counter_size : integer); --19, los 20us para que el boton se estabilice tamaño de cuenta, perido para establecer el estado del button
		Port(
			button_in : in  STD_LOGIC;
			clk : in  STD_LOGIC;
			-- reset : in  STD_LOGIC;
			button_out : out  STD_LOGIC
		);
	end component;
	
	component Pulse 
		Port(
			Button_in : in  STD_LOGIC; 
			clk : in  STD_LOGIC;
			-- reset : in  STD_LOGIC := '0';
			don_pulso : out  STD_LOGIC:= '0'
		);
	end component;
	
	COMPONENT fp_multiplier
	PORT(
		i_fp_a : IN std_logic_vector(31 downto 0);
		i_fp_b : IN std_logic_vector(31 downto 0);          
		o_fp_p : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;
------------------------------------------------------------------------

begin

-------------------Mapeo-------------------------------------

	Inst_debounce : debounce 
	GENERIC MAP(counter_size => 19) --19 , REMEMBER TO CHANGE THIS FOR SIMULATION , 2 is fine
	
	PORT MAP
	(
		button_in => button,
      clk => clk,
		-- reset => reset,
      button_out => button_intermedio
	);
	
	Inst_pulse : pulse PORT MAP
	(
		Button_in => button_intermedio,
      clk => clk,
      -- reset : in  STD_LOGIC := '0',s
      don_pulso => s_don_pulso
	);
	
	Ins_fp_multiplier: fp_multiplier PORT MAP(
		i_fp_a => A,
		i_fp_b => B,
		o_fp_p => C
	);
	
---------------------------------------------------------------


--proceso para la entrada de datos 
	entrada_datos: process(in1,counter, s_don_pulso, Dato, clk,s_reset_counter,s_reset_counter1)
	begin
		
		if (RISING_EDGE(clk))then
			if (s_reset_counter = '1') then
				counter <=  0;
				s_reset_counter <= '0';
			elsif (s_reset_counter1 = '1') then
				counter1 <= 0;
				s_reset_counter1 <= '0';
			elsif (s_don_pulso='1' and in1='1') then
				counter <= counter+1;
			elsif (s_don_pulso='1' and in3='1') then 
				counter1 <= counter1+1;
			else
				counter <= counter;
				counter1 <= counter1;
			end if;
			c_pp <= "00000000";
			if (in1='1') then
			s_show_ready <= '0';
			case counter is
				when 1 =>
					A(31 downto 24) <= Dato;
					c_pp <= A(31 downto 24);
					s_display <= "1010";
					s_display_part <= "0011";
				when 2 =>
					A(23 downto 16) <= Dato;
					c_pp <= A(23 downto 16);
					s_display <= "1010";
					s_display_part <= "0010";
				when 3 =>
					A(15 downto 8) <= Dato;
					c_pp <= A(15 downto 8);
					s_display <= "1010";
					s_display_part <= "0001";
				when 4 =>
					A(7 downto 0) <= Dato;
					c_pp <= A(7 downto 0);
					s_display <= "1010";
					s_display_part <= "0000";
				when 5 =>
					B(31 downto 24) <= Dato;
					c_pp <= B(31 downto 24);
					s_display <= "1011";
					s_display_part <= "0011";
				when 6 =>
					B(23 downto 16) <= Dato;
					c_pp <= B(23 downto 16);
					s_display <= "1011";
					s_display_part <= "0010";
				when 7 =>					
					B(15 downto 8) <= Dato;
					c_pp <= B(15 downto 8);
					s_display <= "1011";
					s_display_part <= "0001";
				when 8 =>
					B(7 downto 0) <= Dato;
					c_pp <= B(7 downto 0);
					s_display <= "1011";
					s_display_part <= "0000";
					
				when 9 =>
				s_data_ready <= '1';
				s_reset_counter <= '1';
				when others =>
				
			end case;
			end if;
			
			if(in3='1') then
			
			case counter1 is
				when 1 =>
					C_pp <= c(31 downto 24);
					s_display <= "1100";
					s_display_part <= "0011";
				when 2 =>
					C_pp <= c(23 downto 16);
					s_display <= "1100";
					s_display_part <= "0010";
				when 3 =>
					C_pp <= c(15 downto 8);
					s_display <= "1100";
					s_display_part <= "0001";
				when 4 =>
					C_pp <= c(7 downto 0);
					s_display <= "1100";
					s_display_part <= "0000";
					
				when 5 =>
					s_show_ready <= '1';
					s_reset_counter1 <= '1';
				when others =>
				
			end case;
			end if;
	
-------------MULTIPLICACION-----------------
			if (in2='1') then 
				s_multi_ready <= '1';
				--c_pp <= "11101111";
				s_data_ready <= '0';
			elsif (in2='0') then 
				s_multi_ready <= '0';
			end if;
--------------------------------------------
		end if;
	end process;
	
C_p <= c_pp;
display <= s_display;
display_part <= s_display_part;
data_ready <= s_data_ready;
multi_ready <= s_multi_ready;
show_ready <= s_show_ready;



end Behavioral;

