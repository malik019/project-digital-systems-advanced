library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_uart_tx is
end tb_uart_tx;

architecture sim of tb_uart_tx is

    component uart_tx
        Port (
            clk      : in  STD_LOGIC;
            bd_clk   : in  STD_LOGIC;
            n_rst    : in  STD_LOGIC;
            stop_b   : in  STD_LOGIC_VECTOR(1 downto 0);
            tx_start : in  STD_LOGIC;
            tx_d     : in  STD_LOGIC_VECTOR(7 downto 0);
            tx_pin   : out STD_LOGIC;
            tx_end   : out STD_LOGIC
        );
    end component;

    signal clk      : STD_LOGIC := '0';
    signal bd_clk   : STD_LOGIC := '0';
    signal n_rst    : STD_LOGIC := '0';
    signal stop_b   : STD_LOGIC_VECTOR(1 downto 0) := "10"; -- 1 stop bit
    signal tx_start : STD_LOGIC := '0';
    signal tx_d     : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal tx_pin   : STD_LOGIC;
    signal tx_end   : STD_LOGIC;

    constant clk_period : time := 100 ns;      -- 10 MHz system clock
    constant bd_period  : time := 8680 ns;     -- ~115200 baud

    type msg_array is array(0 to 4) of STD_LOGIC_VECTOR(7 downto 0);
    constant message : msg_array := (
        x"48", -- 'H'
        x"65", -- 'e'
        x"6C", -- 'l'
        x"6C", -- 'l'
        x"6F"  -- 'o'
    );

begin

    -- DUT instantiation
    uut: uart_tx
        port map (
            clk      => clk,
            bd_clk   => bd_clk,
            n_rst    => n_rst,
            stop_b   => stop_b,
            tx_start => tx_start,
            tx_d     => tx_d,
            tx_pin   => tx_pin,
            tx_end   => tx_end
        );

    -- Clock generation
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Baud clock generation
    bd_clk_process : process
    begin
        while true loop
            bd_clk <= '1';
            wait for bd_period / 2;
            bd_clk <= '0';
            wait for bd_period / 2;
        end loop;
    end process;

    -- Stimulus process
    stim_proc : process
    begin
        -- Reset
        n_rst <= '0';
        wait for 200 ns;
        n_rst <= '1';

        -- Send each character in "Hello"
        for i in 0 to 4 loop
            tx_d <= message(i);
            tx_start <= '1';
            wait until bd_clk = '1';  -- ensure FSM sees tx_start during bd_clk
            tx_start <= '0';

            -- Wait for tx_end to signal completion
            wait until tx_end = '1';
            wait for bd_period * 2;
        end loop;

        -- Finish simulation
        wait for 1 ms;
        assert false report "Simulation complete" severity failure;
    end process;

end sim;