----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.12.2025 17:52:07
-- Design Name: 
-- Module Name: shift_byte_register_generic - Behavioral
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

entity shift_byte_register_generic is
    generic (N:integer :=64);
    Port  ( clk : in std_logic;
           din : in STD_LOGIC_VECTOR(7 downto 0);
           reset : in STD_LOGIC;
           reg : out STD_LOGIC_VECTOR (N-1 downto 0));
end shift_byte_register_generic;

architecture Behavioral of shift_byte_register_generic is
signal s_reg : std_logic_vector(N-1 downto 0);

begin

process(reset, din)
begin
    if reset = '1' then 
        s_reg <= (others => '0');
    elsif rising_edge(clk) then
        s_reg <= din & s_reg(N-9 downto 0);
    end if;
    reg <= s_reg;
end process;
end Behavioral;