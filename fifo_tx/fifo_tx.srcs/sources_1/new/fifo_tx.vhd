----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.12.2025 17:45:38
-- Design Name: 
-- Module Name: fifo_tx - Behavioral
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



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fifo_16x8 is
    Port (
        clk        : in  std_logic;
        rst        : in  std_logic;
        wr_en      : in  std_logic;
        rd_en      : in  std_logic;
        data_in    : in  std_logic_vector(7 downto 0);
        data_out   : out std_logic_vector(7 downto 0);
        fifo_full  : out std_logic;
        fifo_empty : out std_logic
    );
end fifo_16x8;

architecture Behavioral of fifo_16x8 is
constant DEPTH : integer := 16;
type fifo_array is array(0 to DEPTH-1) of std_logic_vector(7 downto 0);
signal fifo_mem : fifo_array := (others => (others => '0'));
signal wr_ptr, rd_ptr : integer range 0 to DEPTH-1 := 0;
signal count : integer range 0 to DEPTH := 0;
signal s_fifo_full, s_fifo_empty : std_logic;
begin
    fifo_full  <= '1' when count = DEPTH else '0';
    fifo_empty <= '1' when count = 0 else '0';
    data_out   <= fifo_mem(rd_ptr);

    process(clk, rst)
    begin
        if rst = '1' then
            wr_ptr <= 0;
            rd_ptr <= 0;
            count  <= 0;
        elsif rising_edge(clk) then
            if wr_en = '1' and s_fifo_full = '0' then
                fifo_mem(wr_ptr) <= data_in;
                wr_ptr <= (wr_ptr + 1) mod DEPTH;
                count  <= count + 1;
            end if;
            if rd_en = '1' and s_fifo_empty = '0' then
                rd_ptr <= (rd_ptr + 1) mod DEPTH;
                count  <= count - 1;
            end if;
        end if;
    end process;
end Behavioral;




