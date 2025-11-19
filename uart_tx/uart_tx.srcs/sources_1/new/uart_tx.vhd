library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity uart_tx is
    port(
        clk            : in  std_logic;
        bd_clk         : in std_logic;
        reset          : in  std_logic;
        tx_start       : in  std_logic;
        tx_data_in     : in  std_logic_vector (7 downto 0);
        tx_data_out    : out std_logic
        );
end uart_tx;

architecture Behavioral of uart_tx is


type tx_states_t is (IDLE, START, DATA, STOP);
signal tx_state  : tx_states_t := IDLE;

signal baud_rate_clk     : std_logic:= '0';

signal data_index        : integer range 0 to 7 := 0;
signal data_index_reset  : std_logic := '1';
signal stored_data       : std_logic_vector(7 downto 0) := (others=>'0');

signal start_detected    : std_logic := '0';
signal start_reset       : std_logic := '0';

begin

 
tx_start_detector: process(clk)
begin
    if rising_edge(clk) then
        if (reset ='1') or (start_reset = '1') then
            start_detected <= '0';
        else
            if (tx_start = '1') and (start_detected = '0') then
                start_detected <= '1';
                stored_data <= tx_data_in;
            end if;
        end if;
    end if;
end process tx_start_detector;

UART_tx_FSM: process(clk)
begin
    if rising_edge(clk) then
        if (reset = '1') then
            tx_state <= IDLE;
            data_index_reset <= '1';   -- keep data_index_counter on hold
            start_reset <= '1';        -- keep tx_start_detector on hold
            tx_data_out <= '1';        -- keep tx line set along the standard
        else
            if (bd_clk = '1') then     -- the FSM works on the baud rate frequency
                case tx_state is
                
                    when IDLE =>

                        data_index_reset <= '1';    -- keep data_index_counter on hold
                        start_reset <= '0';         -- enable tx_start_detector to wait for starting impulses
                        tx_data_out <= '1';         -- keep tx line set along the standard

                        if (start_detected = '1') then
                            tx_state <= START;
                        end if;

                    when START =>

                        data_index_reset <= '0';   -- enable data_index_counter for DATA state
                        tx_data_out <= '0';        -- send '0' as a start bit

                        tx_state <= DATA;

                    when DATA =>

                        tx_data_out <= stored_data(data_index);   -- send one bit per one baud clock cycle 8 times

                        if (data_index = 7) then
                            data_index_reset <= '1';              -- disable data_index_counter when it has reached 8
                            tx_state <= STOP;
                        end if;

                    when STOP =>

                        tx_data_out <= '1';     -- send '1' as a stop bit
                        start_reset <= '1';     -- prepare tx_start_detector to be ready detecting the next impuls in IDLE

                        tx_state <= IDLE;

                    when others =>
                        tx_state <= IDLE;
                end case;
            end if;
        end if;
    end if;
end process UART_tx_FSM;

end Behavioral;