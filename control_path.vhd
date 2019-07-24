library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity control_path is

    Generic
    (
    -- Use opcode way for controlling data path
        OP_INPUT_A : STD_LOGIC_VECTOR := "000";
        OP_INPUT_B : STD_LOGIC_VECTOR := "001";
        OP_MULTIPLY : STD_LOGIC_VECTOR := "010";
        OP_SHOW_C : STD_LOGIC_VECTOR := "011";
        OP_RESET_STATE : STD_LOGIC_VECTOR := "111";
        OP_RESET_PART : STD_LOGIC_VECTOR := "111";
        OP_PART_3 : STD_LOGIC_VECTOR := "011";
        OP_PART_2 : STD_LOGIC_VECTOR := "010";
        OP_PART_1 : STD_LOGIC_VECTOR := "001";
        OP_PART_0 : STD_LOGIC_VECTOR := "000";
        A : STD_LOGIC_VECTOR := "1010";
        B : STD_LOGIC_VECTOR := "1011";
        C : STD_LOGIC_VECTOR := "1100";
        F : STD_LOGIC_VECTOR := "1111"
    );

    Port
    (
        I_CLK : in STD_LOGIC;
        I_RESET : in STD_LOGIC;
        I_BUTTON_NEXT: in STD_LOGIC;
        I_BUTTON_PREV: in STD_LOGIC; -- not gonna implement this right now
        I_RESULT_READY: in STD_LOGIC;
        O_OP_STATE : out STD_LOGIC_VECTOR (2 downto 0);
        O_OP_PART : out STD_LOGIC_VECTOR (2 downto 0);
        O_DISP : out STD_LOGIC_VECTOR (7 downto 0) --00 in reset
    );

end control_path;

architecture Behavioral of control_path is

    type STATE_TYPE is 
    (
        INPUT_A,
        INPUT_B,
        MULTIPLY,
        SHOW_C,
        RESET_STATE
    );
    
    type PART_TYPE is
    (
        PART_3, -- Most Significant
        PART_2,
        PART_1,
        PART_0, -- Least Significant
        RESET_PART
    );
-- Comenzar mejor primero por el datapath
    -- Internal Signals
    signal current_state : STATE_TYPE := RESET_STATE;
    signal next_state : STATE_TYPE := RESET_STATE;
    signal current_part : PART_TYPE := RESET_PART;
    signal next_part : PART_TYPE := RESET_PART;
    signal s_op_state : STD_LOGIC_VECTOR (2 downto 0) := OP_INPUT_A;
    signal s_op_part : STD_LOGIC_VECTOR (2 downto 0) := OP_PART_3;
    signal s_disp_state : STD_LOGIC_VECTOR (3 downto 0) := A;
    signal s_disp_part : STD_LOGIC_VECTOR (3 downto 0) := "0001"; --& "0001"; -- A1
    signal s_state_reset : STD_LOGIC := '0';
    signal s_part_reset : STD_LOGIC := '0';
    signal s_input_ready : STD_LOGIC := '0';
    signal s_enable_a : STD_LOGIC := '0';
    signal s_enable_b : STD_LOGIC := '0';
    signal s_enable_parts : STD_LOGIC := '1';

-- las variables no se sintetizan tan bien
begin

    SYNC_STATE_PROC: process (I_CLK,I_RESET,s_state_reset)
    begin
        if (RISING_EDGE(I_CLK)) then
            if (I_RESET = '1' or s_state_reset = '1') then
                current_state <= RESET_STATE;
            else
                current_state <= next_state;
            end if;
        end if;
    end process;

    SYNC_PART_PROC: process (I_CLK,I_RESET,s_part_reset)
    begin
        if (RISING_EDGE(I_CLK)) then
            if (I_RESET = '1' or s_part_reset = '1') then
                current_part <= RESET_PART;
            else
                current_part <= next_part;
            end if;
        end if;
    end process;

    NEXT_STATE_DECODE: process (current_state, s_input_ready,I_BUTTON_NEXT, I_RESULT_READY) --I_BUTTON_PREV
    begin
       --declare default state for next_state to avoid latches
        next_state <= current_state;  --default is to stay in current state
       --insert statements to decode next_state
       --below is a simple example
        case (current_state) is
            when INPUT_A =>
                if (I_BUTTON_NEXT = '1' and s_input_ready = '1') then
                    next_state <= INPUT_B;
                end if;
            when INPUT_B =>
                if (I_BUTTON_NEXT = '1' and s_input_ready = '1') then
                    next_state <= MULTIPLY;
                end if;
                
            when MULTIPLY =>
                if (I_RESULT_READY = '1') then
                    next_state <= SHOW_C;
                end if;
            
            when SHOW_C =>
                next_state <= SHOW_C;
            
            when RESET_STATE =>
                next_state <= INPUT_A;
            
            when others =>
                next_state <= RESET_STATE;
        end case;
    end process;

    STATE_OUTPUT_DECODE: process (current_state,I_CLK,s_op_state)
    begin
        s_op_state <= s_op_state;
        
        case (current_state) is
            when INPUT_A =>
                s_op_state <= OP_INPUT_A;
                s_disp_state <= A;
                s_enable_parts <= '1';
            when INPUT_B =>
                s_op_state <= OP_INPUT_B;
                s_disp_state <= B;
                s_enable_parts <= '1';
            when MULTIPLY =>
                s_op_state <= OP_MULTIPLY;
                s_disp_state <= F;
                s_enable_parts <= '0';
            when SHOW_C =>
                s_op_state <= OP_SHOW_C;
                s_disp_state <= C;
                s_enable_parts <= '1';
            when RESET_STATE =>
                s_op_state <= OP_RESET_STATE;
                s_disp_state <= F;
                s_enable_parts <= '0';
                s_state_reset <= '0';
        end case;
        
    end process;
-- bad idea to be sensible to another's fsm state, best to use signals
-- need debounce, and pulse generator
-- serial para conectar con lenguajes de programacion
    NEXT_PART_DECODE: process (current_part,s_enable_parts, I_BUTTON_NEXT) --I_BUTTON_PREV)
    begin
       --declare default state for next_state to avoid latches
        next_part <= current_part;  --default is to stay in current state
       --insert statements to decode next_state
       --below is a simple example
        if (s_enable_parts = '1') then
            case (current_part) is
                when PART_3 =>
                    if (I_BUTTON_NEXT = '1') then
                        next_part <= PART_2;
                    end if;
                when PART_2 =>
                    if (I_BUTTON_NEXT = '1') then
                        next_part <= PART_1;
                    end if;
                when PART_1 =>
                    if (I_BUTTON_NEXT = '1') then
                        next_part <= PART_0;
                    end if;
                when PART_0 =>
                    if (I_BUTTON_NEXT = '1') then
                        s_input_ready <= '1';
                        next_part <= RESET_PART;
                    end if;
                when RESET_PART =>
                    s_input_ready <= '0';
                    next_part <= PART_3;
                when others =>
                    next_part <= RESET_PART;
            end case;
       end if;
    end process;

    PART_OUTPUT_DECODE: process (current_part)
    begin
        case (current_part) is
            when PART_3 =>
                s_op_part <= OP_PART_3;
                s_disp_part <= "0011";
            when PART_2 =>
                s_op_part <= OP_PART_2;
                s_disp_part <= "0010";
            when PART_1 =>
                s_op_part <= OP_PART_1;
                s_disp_part <= "0001";
            when PART_0 =>
                s_op_state <= OP_PART_0;
                s_disp_part <= "0000";
            when RESET_PART =>
                s_op_state <= OP_RESET_PART;
                s_disp_part <= F;
        end case;
    end process;

O_OP_STATE <= s_op_state;
O_OP_PART <= s_op_part;
O_DISP <= s_disp_state & s_disp_part;
end Behavioral;

