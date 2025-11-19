----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.10.2025 19:13:14
-- Design Name: 
-- Module Name: clock_en_generic - Behavioral
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
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clock_en_generic is
    generic (
            clock_frequency : integer:=100000000;
            require_frequency: real:=1.0);
    Port ( clk : in STD_LOGIC;
           chip_en : out STD_LOGIC);
     
end clock_en_generic;

architecture Behavioral of clock_en_generic is

constant  freq :integer := integer(real(clock_frequency) / require_frequency); 
begin
process(clk)
variable teller :integer range 0 to (freq-1):= (freq-1);
begin
    if rising_edge(clk) then
        if (teller = freq) then
            teller :=  (teller + 1);
            chip_en <= '1';
        else
            teller :=  (teller + 1);
            chip_en <= '0';
        end if;
   
    end if;    
end process;
end Behavioral;
