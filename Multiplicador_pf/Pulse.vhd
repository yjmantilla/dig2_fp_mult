library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Pulse is
    Port ( Button_in : in  STD_LOGIC;
           clk : in  STD_LOGIC;
          -- reset : in  STD_LOGIC := '0';
			 don_pulso : out STD_LOGIC := '0');
end Pulse;

architecture Behavioral of Pulse is

signal D1,D2,Q1,Q2 : STD_LOGIC := '0';
signal salida : STD_LOGIC := '0';

begin

	process (clk,button_in,Q1,Q2,D2)
	begin
		D1 <= button_in;
		if (RISING_EDGE(clk)) then 
			Q1 <= D1;
			D2 <= (NOT Q1);
			--Q2 <= D2;--nope
		end if;
		
		Q2 <= D2;

		salida <= Q1 and Q2;
		
	end process;
	
don_pulso <= salida;

end Behavioral;



