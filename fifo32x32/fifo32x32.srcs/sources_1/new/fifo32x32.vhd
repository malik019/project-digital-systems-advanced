----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.11.2025 10:01:15
-- Design Name: 
-- Module Name: fifo32x32 - Behavioral
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

entity fifo32x8 is
    Port (
        clk    : in  std_logic;
        reset    : in  std_logic;
        wr_en  : in  std_logic;
        rd_en  : in  std_logic;
        din    : in  std_logic_vector(7 downto 0);
        dout   : out std_logic_vector(7 downto 0)
        
    );
end fifo32x8;

architecture simple of fifo32x8 is
    type ram_type is array (0 to 31) of std_logic_vector(31 downto 0);
    signal ram      : ram_type := (others => (others => '0'));
    signal wr_ptr   : unsigned(2 downto 0) := (others => '0');
    signal rd_ptr   : unsigned(2 downto 0) := (others => '0');
    signal count    : unsigned(3 downto 0) := (others => '0');
    signal full, empty : std_logic;
begin
    process(clk, reset)
    begin
        if reset = '1' then
            wr_ptr <= (others => '0');
            rd_ptr <= (others => '0');
            count  <= (others => '0');
            dout   <= (others => '0');
        elsif rising_edge(clk) then
            -- Write
            if wr_en = '1' and full = '0' then
                ram(to_integer(wr_ptr)) <= din;
                wr_ptr <= wr_ptr + 1;
                count  <= count + 1;
            end if;

            -- Read
            if rd_en = '1' and empty = '0' then
                dout   <= ram(to_integer(rd_ptr));
                rd_ptr <= rd_ptr + 1;
                count  <= count - 1;
            end if;
        end if;
    end process;

    empty <= '1' when count = 0 else '0';
    full  <= '1' when count = 32 else '0';
end simple;
