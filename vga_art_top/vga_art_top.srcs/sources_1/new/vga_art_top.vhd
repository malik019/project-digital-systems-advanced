----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.11.2025 23:08:27
-- Design Name: 
-- Module Name: vga_art_top - Behavioral
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

entity vga_art_top is
    Port ( mclk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (1 downto 0);
           led : out STD_LOGIC_VECTOR (7 downto 0);
           Hsync : out STD_LOGIC;
           Vsync : out STD_LOGIC;
           vgaRed : out STD_LOGIC_VECTOR (3 downto 0);
           vgaGreen : out STD_LOGIC_VECTOR (3 downto 0);
           vgaBlue : out STD_LOGIC_VECTOR (3 downto 0);
           RsRx  :in STD_LOGIC;
           RsTx  :out STD_LOGIC);
           
end vga_art_top;

architecture Behavioral of vga_art_top is

component clock_en_generic is
    generic (
            clock_frequency : integer:=100000000;
            require_frequency: real:=1.0);
    Port ( clk : in STD_LOGIC;
           chip_en : out STD_LOGIC);
     
end component clock_en_generic;

component vga_640x480 is
    Port ( clk, clr : in STD_LOGIC;
           hsync : out STD_LOGIC;
           vsync : out STD_LOGIC;
           hc : out STD_LOGIC_VECTOR (9 downto 0);
           vc : out STD_LOGIC_VECTOR (9 downto 0);
           vidon : out STD_LOGIC);
end component vga_640x480;

component vga_art is
    Port ( vidon : in STD_LOGIC;
           hc : in STD_LOGIC_VECTOR (9 downto 0);
           vc : in STD_LOGIC_VECTOR (9 downto 0);
           M : in STD_LOGIC_VECTOR (0 to 31);
           sw : in STD_LOGIC_VECTOR (7 downto 0);
           rom_addr4 : out STD_LOGIC_VECTOR (3 downto 0);
           red : out STD_LOGIC_VECTOR (3 downto 0);
           green : out STD_LOGIC_VECTOR (3 downto 0);
           blue : out STD_LOGIC_VECTOR (3 downto 0));
end component vga_art;

component prom_DMH is
    Port ( addr : in STD_LOGIC_VECTOR (3 downto 0);
           M : out STD_LOGIC_VECTOR (0 to 31));
end component prom_DMH;

component vga_stripes is
    Port ( vidon : in STD_LOGIC;
           hc : in STD_LOGIC_VECTOR (9 downto 0);
           vc : in STD_LOGIC_VECTOR (9 downto 0);
           red : out STD_LOGIC_VECTOR (3 downto 0);
           green : out STD_LOGIC_VECTOR (3 downto 0);
           blue : out STD_LOGIC_VECTOR (3 downto 0));
end component vga_stripes;


component uart is

    port(
        clk            : in  std_logic;
        reset          : in  std_logic;
        tx_start       : in  std_logic;

        data_in        : in  std_logic_vector (7 downto 0);
        data_out       : out std_logic_vector (7 downto 0);

        rx             : in  std_logic;
        tx             : out std_logic
        );
end component uart;

signal clr, clk25, vidon : std_logic;
signal hc, vc : std_logic_vector(9 downto 0);
signal M : std_logic_vector(0 to 31);
signal rom_addr4 : std_logic_vector(3 downto 0);
signal  data_in, data_out : STD_LOGIC_VECTOR (7 downto 0);

begin
U1: clock_en_generic 
 generic map(clock_frequency=> 100000000,require_frequency=>25000000.0) --
 port map(clk=>mclk, chip_en=>clk25);
U2: vga_640x480 port map(clk=>clk25, clr=>btn(0), hsync=>hsync, vsync=>vsync, hc=>hc, vc=>vc, vidon=>vidon);
U3: vga_art port map(vidon=>vidon, hc=>hc, rom_addr4=>rom_addr4, vc=>vc, M=>M, sw=>data_out, green=>vgaGreen, red=>vgaRed, blue=>vgaBlue);
U4: prom_dmh port map(addr=>rom_addr4, M=>M);
U5: uart port map (clk=>mclk, reset=>btn(0), tx_start=>btn(1), data_in=>data_in, data_out=>data_out, rx=>RsRx, tx=>RsTx);
--U3: vga_stripes port map(vidon=>vidon, hc=>hc, vc=>vc, red=>vgaRed, green=>vgaGreen, blue=>vgaBlue);
led<=data_out;
end Behavioral;
