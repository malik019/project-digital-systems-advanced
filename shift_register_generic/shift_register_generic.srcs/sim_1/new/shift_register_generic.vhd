----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.10.2025 07:16:22
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
    generic (N: integer:=8);
    Port ( clk : in STD_LOGIC;
           d : in STD_LOGIC;
           ld: in std_logic;
           clr : in STD_LOGIC;
           q : out STD_LOGIC_VECTOR (N-1 downto 0));
           
end shift_register_generic;

architecture Behavioral of shift_register_generic is

signal qs : std_logic_vector(N-1 downto 0);
begin
process(clk, clk, ld, d)
begin
    if clr = '1' then
        qs <= (others=>'0');
    elsif rising_edge(clk) then
        if ld = '1' then
            qs <= (others=>d);
        else
        qs(N-1) <=d;
        qs(N-2 downto 0) <= qs(N-1 downto 1);  
        end if;
    end if;
    
end process;
q<=qs;
end Behavioral;
