----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.10.2025 07:17:26
-- Design Name: 
-- Module Name: shift_register_generic_tb - Behavioral
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

entity shift_register_generic_tb is
--  Port ( );
end shift_register_generic_tb;

architecture Behavioral of shift_register_generic_tb is
constant N : integer:=16;
signal d, clr, ld, clk :std_logic;
signal q : std_logic_vector(N-1 downto 0);
signal x : std_logic_vector(3 downto 0):="0000";
constant PERIOD : time:= 10ns;

begin
DUT: entity work.shift_register_generic 
 generic map (N=>16)
 port map(clk=>clk, clr=>clr, d=>d, ld=>ld, q=>q);
     
clk_process:process
begin 
    CLK <= '0';
    wait for PERIOD/2;
    CLK <= '1';
    wait for PERIOD/2;
end process;

process
begin 
       for i in 0 to 16 loop
            x<=x+1;
            wait for 100ns;
       end loop;
       wait;
end process; 
ld <= x(0);
d <= x(1);
clr <= x(3); 
end Behavioral;