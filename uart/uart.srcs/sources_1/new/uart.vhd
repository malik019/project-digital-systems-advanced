----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.11.2025 19:12:07
-- Design Name: 
-- Module Name: uart - Behavioral
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

entity uart is

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
end uart;

architecture Behavioral of uart is

component clock_en_generic is
    generic (
            clock_frequency : integer:=100000000;
            require_frequency: real:=1.0);
    Port ( clk : in STD_LOGIC;
           chip_en : out STD_LOGIC);
end component clock_en_generic;

component uart_rx is
    port(
        clk                : in  std_logic;
        bd_x16_clk         : in  std_logic;
        reset              : in  std_logic;
        rx_data_in         : in  std_logic;
        rx_data_out        : out std_logic_vector (7 downto 0);
        data_valid         : out std_logic
        );
end component uart_rx;

component rx_fifo is
    Port (
        clk        : in  std_logic;
        rst        : in  std_logic;
        wr_en      : in  std_logic;  -- Write enable (from UART RX when data_valid = '1')
        rd_en      : in  std_logic;  -- Read enable (system wants next byte)
        data_in    : in  std_logic_vector(7 downto 0);
        data_out   : out std_logic_vector(7 downto 0);
        fifo_full  : out std_logic;
        fifo_empty : out std_logic
    );
end component rx_fifo;

component uart_tx is
    port(
        clk            : in  std_logic;
        bd_clk         : in std_logic;
        reset          : in  std_logic;
        tx_start       : in  std_logic;
        tx_data_in     : in  std_logic_vector (7 downto 0);
        tx_data_out    : out std_logic
        );
end component uart_tx;

signal en_rx , en_tx, en_fifo : std_logic;
signal s_data_valid : std_logic;
signal s_data_out : std_logic_vector(7 downto 0);
begin

Baud_clk_tx: clock_en_generic 
 generic map(clock_frequency=> 100000000,require_frequency=>115200.0) --868
 port map(clk=>clk, chip_en=>en_tx);

 Baud_clk_rx: clock_en_generic 
 generic map(clock_frequency=> 100000000,require_frequency=>(115200.0*16.0)) --54
 port map(clk=>clk, chip_en=>en_rx);
 
 clk_fifo: clock_en_generic 
 generic map(clock_frequency=> 100000000,require_frequency=>(115200.0*16.0)) --2
 port map(clk=>clk, chip_en=>en_fifo);
 
transmitter: uart_tx port map(clk=>clk, bd_clk=>en_tx, tx_data_in=>data_in, tx_data_out=>tx, reset=>reset, tx_start=>tx_enable );
receiver: uart_rx port map(clk=>clk, bd_x16_clk=>en_rx, rx_data_in=>rx, rx_data_out=>s_data_out, reset=>reset, data_valid=>s_data_valid);
rx_fifo_buffer: rx_fifo port map(clk=>en_fifo, rst=>reset, wr_en=>s_data_valid, rd_en=>read_data, data_in=>s_data_out, data_out=>data_out, fifo_full=>open, fifo_empty=>open);

end Behavioral;





