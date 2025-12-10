----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.11.2025 20:05:19
-- Design Name: 
-- Module Name: packet_assembler - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity packet_assembler is
    port (
        -- Global Signals
        clk          : in  std_logic;
        reset        : in  std_logic;
        
        -- Inputs from UART Receiver
        uart_data_in : in  std_logic_vector(7 downto 0); -- The byte received
        data_valid   : in  std_logic;                  -- Clock-aligned strobe (1-cycle pulse when a byte is ready)
        
        -- Outputs to Internal Logic
        x_coordinate : out std_logic_vector(15 downto 0); -- Assembled 16-bit X
        y_coordinate : out std_logic_vector(15 downto 0); -- Assembled 16-bit Y
        packet_ready : out std_logic                      -- Asserted for 1 cycle when new data is available
    );
end entity packet_assembler;

architecture behavioral of packet_assembler is

-- Define the FSM States
type state_type is (S_X_HIGH, S_X_LOW, S_Y_HIGH, S_Y_LOW);
signal current_state : state_type := S_X_HIGH; -- Start at the beginning of the expected packet

-- Internal Registers to store the four bytes
signal x_high_reg : std_logic_vector(7 downto 0) := (others => '0');
signal x_low_reg  : std_logic_vector(7 downto 0) := (others => '0');
signal y_high_reg : std_logic_vector(7 downto 0) := (others => '0');
signal y_low_reg  : std_logic_vector(7 downto 0) := (others => '0');

-- Internal signals for output registers
signal s_x_coordinate : std_logic_vector(15 downto 0) := (others => '0');
signal s_y_coordinate : std_logic_vector(15 downto 0) := (others => '0');
    signal s_packet_ready : std_logic := '0';

begin

-- Add ligh&low byte
s_x_coordinate <= x_high_reg & x_low_reg;
s_y_coordinate <= y_high_reg & y_low_reg;

-- Map internal signals to external ports
x_coordinate <= s_x_coordinate;
y_coordinate <= s_y_coordinate;
packet_ready <= s_packet_ready;


-- 2. Sequential Logic (FSM and Register Updates)
process (clk)
begin
    if rising_edge(clk) then
        -- Reset Logic
        if reset = '1' then
            current_state  <= S_X_HIGH;
            s_packet_ready <= '0';
            x_high_reg     <= (others => '0');
            -- ... reset other registers if needed

        else
            -- The packet_ready signal is always reset unless explicitly set high below
            s_packet_ready <= '0'; 

            -- Only proceed if the UART has successfully received a new byte
            if data_valid = '1' then
                
                case current_state is
                    
                    -- State 0: Waiting for X High Byte
                    when S_X_HIGH =>
                        x_high_reg    <= uart_data_in;
                        current_state <= S_X_LOW;

                    -- State 1: Waiting for X Low Byte
                    when S_X_LOW =>
                        x_low_reg     <= uart_data_in;
                        current_state <= S_Y_HIGH;

                    -- State 2: Waiting for Y High Byte
                    when S_Y_HIGH =>
                        y_high_reg    <= uart_data_in;
                        current_state <= S_Y_LOW;

                    -- State 3: Waiting for Y Low Byte (Last Byte)
                    when S_Y_LOW =>
                        y_low_reg     <= uart_data_in;
                        
                        -- A full 4-byte packet has been received!
                        s_packet_ready <= '1'; 
                        current_state  <= S_X_HIGH; -- Loop back to wait for the next packet
                        
                end case;
            end if;
        end if;
    end if;
end process;
    
end architecture behavioral;
