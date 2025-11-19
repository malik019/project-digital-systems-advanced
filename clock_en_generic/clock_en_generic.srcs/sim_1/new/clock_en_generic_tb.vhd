----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.10.2025 20:21:10
-- Design Name: 
-- Module Name: clock_en_generic_tb - Behavioral
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

entity clock_en_generic_tb is
--  Port ( );
end clock_en_generic_tb;


architecture Behavioral of clock_en_generic_tb is
signal clk :std_logic:='0';
signal chip_en :std_logic;
signal y : integer;
constant period : time := 50ns;
begin

DUT: entity work.clock_en_generic 
   generic map(clock_frequency => 5, require_frequency => 0.5)
   port map(clk=>clk, chip_en=>chip_en, y=>y);

clk_process:process

begin
    clk <= '1';
    wait for period/2;
    clk <= '0';
    wait for period/2;
end process;

end Behavioral;
