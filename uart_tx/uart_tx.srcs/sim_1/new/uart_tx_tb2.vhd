library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_tx_tb is
end entity;

architecture sim of uart_tx_tb is

  -- Component declaration
  component uart_tx
    port (
      clk       : in  std_logic;
      bd_clk    : in  std_logic;
      n_rst     : in  std_logic;
      stop_b    : in  std_logic_vector(1 downto 0);
      tx_start  : in  std_logic;
      tx_d      : in  std_logic_vector(7 downto 0);
      tx_pin    : out std_logic;
      tx_end    : out std_logic
    );
  end component;

  -- Signals
  signal clk       : std_logic := '0';
  signal bd_clk    : std_logic := '0';
  signal n_rst     : std_logic := '0';
  signal stop_b    : std_logic_vector(1 downto 0) := "10"; -- 1 stop bit
  signal tx_start  : std_logic := '0';
  signal tx_d      : std_logic_vector(7 downto 0) := "10101010";
  signal tx_pin    : std_logic;
  signal tx_end    : std_logic;

  -- Clock generation
  constant clk_period : time := 100 ns;
  constant bd_period  : time := 1600 ns; -- Simulated baud clock

begin

  -- Instantiate DUT
  DUT: uart_tx
    port map (
      clk       => clk,
      bd_clk    => bd_clk,
      n_rst     => n_rst,
      stop_b    => stop_b,
      tx_start  => tx_start,
      tx_d      => tx_d,
      tx_pin    => tx_pin,
      tx_end    => tx_end
    );

  -- Main clock
  clk_process : process
  begin
    while true loop
      clk <= '0';
      wait for clk_period / 2;
      clk <= '1';
      wait for clk_period / 2;
    end loop;
  end process;

  -- Baud clock
  bd_clk_process : process
  begin
    while true loop
      bd_clk <= '0';
      wait for bd_period / 2;
      bd_clk <= '1';
      wait for bd_period / 2;
    end loop;
  end process;

  -- Stimulus
  stim_proc : process
  begin
    -- Initial reset
    n_rst <= '0';
    wait for 200 ns;
    n_rst <= '1';

    -- Wait for a few cycles
    wait for 1000 ns;

    -- Start transmission
    tx_start <= '1';
    wait for clk_period;
    tx_start <= '0';

    -- Wait for transmission to complete
    wait for 20000 ns;

    -- End simulation
    wait;
  end process;

end architecture;