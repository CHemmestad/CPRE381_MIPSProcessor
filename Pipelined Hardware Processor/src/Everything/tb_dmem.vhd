-------------------------------------------------------------------------
-- Caleb Hemmestad
-- 
-- Iowa State University
-------------------------------------------------------------------------

-------------------------------------------------------------------------
-- DESCRIPTION:
--
--
-- NOTES:
-- Created 9/18/24 by Caleb Hemmestad
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_dmem is
  generic(gCLK_HPER   	: time := 50 ns);
end tb_dmem;

architecture mixed of tb_dmem is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


component mem is
	generic 
    (
      DATA_WIDTH : natural := 32;
      ADDR_WIDTH : natural := 10
    );
  
    port 
    (
      clk		: in std_logic;
      addr	        : in std_logic_vector((ADDR_WIDTH-1) downto 0);
      data	        : in std_logic_vector((DATA_WIDTH-1) downto 0);
      we		: in std_logic := '1';
      q		: out std_logic_vector((DATA_WIDTH -1) downto 0)
    );
end component;

  -- Temporary signals to connect to the dff component.
  signal s_CLK  : std_logic;
  signal s_ADDR : std_logic_vector(9 downto 0);
  signal s_DATA : std_logic_vector(31 downto 0);
  signal s_WE : std_logic := '1';
  signal s_Q : std_logic_vector(31 downto 0);
  signal s_TEMP : std_logic_vector(31 downto 0);

begin

  DUT0: mem 
  port map(
          clk => s_CLK, 
           addr => s_ADDR,
           data  => s_DATA,
           we   => s_WE,
           q   => s_Q
           );

  -- This process sets the clock value (low for gCLK_HPER, then high
  -- for gCLK_HPER). Absent a "wait" command, processes restart 
  -- at the beginning once they have reached the final statement.
  P_CLK: process
  begin
    s_CLK <= '0';
    wait for gCLK_HPER;
    s_CLK <= '1';
    wait for gCLK_HPER;
  end process;
  
  -- Testbench process  
  P_TB: process
  begin
    wait for gCLK_HPER/2;

    -- 1
    s_WE <= '0';
    s_ADDR <= "0000000000";
    s_TEMP <= s_Q;
    wait for cCLK_PER;
    s_WE <= '1';
    s_ADDR <= "0100000000";
    wait for cCLK_PER;
    s_DATA <= s_TEMP;
    wait for cCLK_PER;

    -- 2
    s_WE <= '0';
    s_ADDR <= "0000000001";
    wait for cCLK_PER;
    s_TEMP <= s_Q;
    wait for cCLK_PER;
    s_WE <= '1';
    s_ADDR <= "0100000001";
    wait for cCLK_PER;
    s_DATA <= s_TEMP;
    wait for cCLK_PER;

    -- 3
    s_WE <= '0';
    s_ADDR <= "0000000010";
    wait for cCLK_PER;
    s_TEMP <= s_Q;
    wait for cCLK_PER;
    s_WE <= '1';
    s_ADDR <= "0100000010";
    wait for cCLK_PER;
    s_DATA <= s_TEMP;
    wait for cCLK_PER;

    -- 4
    s_WE <= '0';
    s_ADDR <= "0000000011";
    wait for cCLK_PER;
    s_TEMP <= s_Q;
    wait for cCLK_PER;
    s_WE <= '1';
    s_ADDR <= "0100000011";
    wait for cCLK_PER;
    s_DATA <= s_TEMP;
    wait for cCLK_PER;

    -- 5
    s_WE <= '0';
    s_ADDR <= "0000000100";
    wait for cCLK_PER;
    s_TEMP <= s_Q;
    wait for cCLK_PER;
    s_WE <= '1';
    s_ADDR <= "0100000100";
    wait for cCLK_PER;
    s_DATA <= s_TEMP;
    wait for cCLK_PER;

    -- 6
    s_WE <= '0';
    s_ADDR <= "0000000101";
    wait for cCLK_PER;
    s_TEMP <= s_Q;
    wait for cCLK_PER;
    s_WE <= '1';
    s_ADDR <= "0100000101";
    wait for cCLK_PER;
    s_DATA <= s_TEMP;
    wait for cCLK_PER;

    -- 7
    s_WE <= '0';
    s_ADDR <= "0000000110";
    wait for cCLK_PER;
    s_TEMP <= s_Q;
    wait for cCLK_PER;
    s_WE <= '1';
    s_ADDR <= "0100000110";
    wait for cCLK_PER;
    s_DATA <= s_TEMP;
    wait for cCLK_PER;

    -- 8
    s_WE <= '0';
    s_ADDR <= "0000000111";
    wait for cCLK_PER;
    s_TEMP <= s_Q;
    wait for cCLK_PER;
    s_WE <= '1';
    s_ADDR <= "0100000111";
    wait for cCLK_PER;
    s_DATA <= s_TEMP;
    wait for cCLK_PER;

    -- 9
    s_WE <= '0';
    s_ADDR <= "0000001000";
    wait for cCLK_PER;
    s_TEMP <= s_Q;
    wait for cCLK_PER;
    s_WE <= '1';
    s_ADDR <= "0100001000";
    wait for cCLK_PER;
    s_DATA <= s_TEMP;
    wait for cCLK_PER;

    -- 10
    s_WE <= '0';
    s_ADDR <= "0000001001";
    wait for cCLK_PER;
    s_TEMP <= s_Q;
    wait for cCLK_PER;
    s_WE <= '1';
    s_ADDR <= "0100001001";
    wait for cCLK_PER;
    s_DATA <= s_TEMP;
    wait for cCLK_PER;

    -- 1b
    s_WE <= '0';
    s_ADDR <= "0100000000";
    wait for cCLK_PER;

    -- 2b
    s_WE <= '0';
    s_ADDR <= "0100000001";
    wait for cCLK_PER;

    -- 3b
    s_WE <= '0';
    s_ADDR <= "0100000010";
    wait for cCLK_PER;

    -- 4b
    s_WE <= '0';
    s_ADDR <= "0100000011";
    wait for cCLK_PER;

    -- 5b
    s_WE <= '0';
    s_ADDR <= "0100000100";
    wait for cCLK_PER;

    -- 6b
    s_WE <= '0';
    s_ADDR <= "0100000101";
    wait for cCLK_PER;

    -- 7b
    s_WE <= '0';
    s_ADDR <= "0100000110";
    wait for cCLK_PER;

    -- 8b
    s_WE <= '0';
    s_ADDR <= "0100000111";
    wait for cCLK_PER;

    -- 9b
    s_WE <= '0';
    s_ADDR <= "0100001000";
    wait for cCLK_PER;

    -- 10b
    s_WE <= '0';
    s_ADDR <= "0100001001";
    wait for cCLK_PER;

    wait;

  end process;
  
end mixed;
