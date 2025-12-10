----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.12.2025 22:53:26
-- Design Name: 
-- Module Name: uart_tb - Behavioral
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
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;





entity uart_tb is
--  Port ( );
end uart_tb;

architecture Behavioral of uart_tb is


    component uart
        port(
            clk            : in  std_logic;
            reset          : in  std_logic;
            tx_enable      : in  std_logic;

            data_in        : in  std_logic_vector (7 downto 0);
            data_out       : out std_logic_vector (7 downto 0);

            rx             : in  std_logic;
            tx             : out std_logic;
            
            read_data        : in std_logic
            );
    end component uart;



    signal clk            : std_logic := '0';
    signal reset          : std_logic := '0';
    signal tx_enable       : std_logic := '0';
    
    signal data_valid     : std_logic;
    signal read_data        : std_logic :='0';
    
    signal tx_data_in     : std_logic_vector (7 downto 0) := (others => '0');
    signal rx_data_out    : std_logic_vector (7 downto 0) := (others => '0');

    signal tx_serial_out  : std_logic := '1';
    signal rx_serial_in   : std_logic := '1';


    constant clock_cycle  : time := 10 ns;    -- 1/clk (1 / 100 000 000)

begin

    DUT: uart
    port map(
            clk        => clk,
            reset      => reset,
            tx_enable  => tx_enable,

            data_in    => tx_data_in,
            data_out   => rx_data_out,

            tx         => tx_serial_out,
            rx         => rx_serial_in,
            
            read_data    => read_data
          
            );

    rx_serial_in <= tx_serial_out;

    clk_generator: process
    begin
        wait for clock_cycle/2;
            clk <= '1';
        wait for clock_cycle/2;
            clk <= '0';
    end process clk_generator;
    
signals_generator: process
    begin
       --write to buffer
       for i in 0 to 14 loop
           tx_enable <= '0';
           wait for 25 us;
           
           tx_data_in <= tx_data_in + 8;
           wait for 25 us;
           
           tx_enable <= '1';
           wait for 25 us; 
        end loop;
    end process signals_generator;
  
 signals_generator_read: process
    begin
         --read from buffer
        for i in 0 to 7 loop
           wait for 25 us;
           read_data <= '1';
           wait for 25ms;
           read_data <= '0';
        end loop;
        wait;
    end process signals_generator_read; 

end Behavioral;