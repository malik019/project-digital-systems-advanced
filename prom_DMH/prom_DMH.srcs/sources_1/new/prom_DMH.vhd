----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.08.2024 00:32:20
-- Design Name: 
-- Module Name: prom_DMH - Behavioral
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

entity prom_DMH is
    Port ( addr : in STD_LOGIC_VECTOR (3 downto 0);
           M : out STD_LOGIC_VECTOR (0 to 31));
end prom_DMH;

architecture Behavioral of prom_DMH is
type rom_array is array (natural range <>)
                of std_logic_vector(0 to 31);

constant rom : rom_array := (
"00000000000000000000000000000000",
"01111100000011111000000111100000",
"01000100000110001100001100110000",
"01000100001100000100011000011000",
"01000100011000000010110000001100",
"01000100110000000011100000000110",
"01000101100000000111000000000011",
"01111101000000001100000000000000",
"00000001100000001100000000000000",
"00000000110000001100000000000000",
"00000000011000001100000000000000",
"00000000001100001100000000000000",
"00000000000110001100000000000000",
"00000000000011001100000000000000",
"00000000000001101100000000000000",
"00000000000000111100000000000000");
begin
process(addr)
variable j : integer;
begin
    j := conv_integer(addr);
    M <= rom(j);
end process;

end Behavioral;
