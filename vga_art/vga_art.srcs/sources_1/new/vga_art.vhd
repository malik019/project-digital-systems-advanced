----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.11.2025 21:36:56
-- Design Name: 
-- Module Name: vga_art - Behavioral
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

entity vga_art is
    Port ( vidon : in STD_LOGIC;
           hc : in STD_LOGIC_VECTOR (9 downto 0);
           vc : in STD_LOGIC_VECTOR (9 downto 0);
           M : in STD_LOGIC_VECTOR (0 to 31);
           sw : in STD_LOGIC_VECTOR (7 downto 0);
           rom_addr4 : out STD_LOGIC_VECTOR (3 downto 0);
           red : out STD_LOGIC_VECTOR (3 downto 0);
           green : out STD_LOGIC_VECTOR (3 downto 0);
           blue : out STD_LOGIC_VECTOR (3 downto 0));
end vga_art;

architecture Behavioral of vga_art is

constant hbp: std_logic_vector(9 downto 0) :="0010010000";
constant vbp: std_logic_vector(9 downto 0) :="0000011111";
constant w : integer := 32;
constant h : integer := 16;
signal C1, R1 : std_logic_vector(10 downto 0);
signal rom_addr, rom_pix : std_logic_vector(10 downto 0);
signal spriteon, R, G, B :std_logic;

begin

--set C1 and R1 using switches
C1 <= "00" & sw(3 downto 0) & "00001";
R1 <= "00" & sw(7 downto 4) & "00001";
rom_addr <= vc - vbp - R1;
rom_pix <= hc - hbp - C1;
rom_addr4 <= rom_addr(3 downto 0);
--Enable sprite video out when within the sprite region
spriteon <= '1' when (((hc >= C1 + hbp) and (hc < C1 + hbp + w ))
        and ((vc >= R1 + vbp) and (vc < R1 + vbp))) else '0'; 
        
process(spriteon, vidon, rom_pix, M)
variable j : integer;
begin
    red <= "0000";
    green <= "0000";
    blue <= "0000";
    if spriteon = '1' and vidon = '1' then 
        j := conv_integer(rom_pix);
        R <= M(j);
        G <= M(j);
        B <= M(j);
        red <= R & R & R & R;
        green <= G & G & G & G;
        blue <= B & B & B & B;
    end if;
end process;


end Behavioral;
