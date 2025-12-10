----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.11.2025 01:01:02
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
    Port (
           clk          : in STD_LOGIC;
           clr          : in STD_LOGIC;
           vidon        : in STD_LOGIC;
           hc           : in STD_LOGIC_VECTOR (9 downto 0);
           vc           : in STD_LOGIC_VECTOR (9 downto 0);
           M            : in STD_LOGIC_VECTOR (0 to 31);
           data         : in STD_LOGIC_VECTOR (7 downto 0);
           rom_addr4    : out STD_LOGIC_VECTOR (3 downto 0);
           read_data    : out std_logic;
           red          : out STD_LOGIC_VECTOR (3 downto 0);
           green        : out STD_LOGIC_VECTOR (3 downto 0);
           blue         : out STD_LOGIC_VECTOR (3 downto 0));
end vga_art;

architecture Behavioral of vga_art is
constant hbp            : std_logic_vector(9 downto 0) :="0010010000";
constant vbp            : std_logic_vector(9 downto 0) :="0000011111";
constant w              : integer := 32;
constant h              : integer := 16;

signal C1, R1           : std_logic_vector(15 downto 0);
signal rom_addr         : std_logic_vector(15 downto 0);
signal rom_pix          : std_logic_vector(15 downto 0);
signal spriteon         : std_logic;
signal R, G, B          : std_logic;
signal s_c1_data        : std_logic_vector(15 downto 0);
signal s_r1_data        : std_logic_vector(15 downto 0);
begin
    process(clr, clk)
    begin
        if clr = '1' then
            read_data <= '0';
            s_c1_data <= (others=>'0');
            s_r1_data <= (others=>'0');
        elsif rising_edge(clk) then
           --read higg&low for C1    
            read_data <= '1';
            s_c1_data(15 downto 8) <= data; 
            read_data <= '0';
            read_data <= '1';
            s_c1_data(7 downto 0) <= data; 
            read_data <= '0';
           
            --read higg&low for R1    
            read_data <= '1';
            s_r1_data(15 downto 8) <= data; 
            read_data <= '0';
            read_data <= '1';
            s_r1_data(7 downto 0) <= data; 
            read_data <= '1';
              
            C1 <= "0000000" & s_c1_data(8 downto 0); 
            R1 <= "0000000" & s_r1_data(8 downto 0); 
            rom_addr <= vc - vbp - R1;
            rom_pix <= hc - hbp - C1;
            rom_addr4 <= rom_addr(3 downto 0); 
       end if;  
    end process; 
     
    --Enable sprite video out when within the sprite region
    spriteon <= '1' when (((hc >= C1 + hbp) and (hc < C1 + hbp + w ))
            and ((vc >= R1 + vbp) and (vc < R1 + vbp + h))) else '0'; 
                  
    process(spriteon, vidon, rom_pix, M)
    variable j : integer;
    begin
        red <= "1111";
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
