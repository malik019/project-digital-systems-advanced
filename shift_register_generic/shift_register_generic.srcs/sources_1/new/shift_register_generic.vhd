----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.10.2025 06:46:27
-- Design Name: 
-- Module Name: shift_register_generic - Behavioral
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

entity shift_register_generic is
    generic (N:integer :=64);
    Port  ( clk : in std_logic;
           d : in STD_LOGIC;
           clr : in STD_LOGIC;
           q : out STD_LOGIC_VECTOR (N-1 downto 0));
end shift_register_generic;

architecture Behavioral of shift_register_generic is
signal qs : std_logic_vector(N-1 downto 0);

begin

process(clk, d)
begin
    if clr = '1' then 
        qs <= (others => '0');
    elsif rising_edge(clk) then
        qs <= d & qs(N-1 downto 1);
    end if;
    q <= qs;
end process;
end Behavioral;
