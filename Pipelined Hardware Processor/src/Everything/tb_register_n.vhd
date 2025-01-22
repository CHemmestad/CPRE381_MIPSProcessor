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

entity tb_register_n is
  generic(gCLK_HPER   	: time := 50 ns;
		N	: integer := 32);
end tb_register_n;

architecture mixed of tb_register_n is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


component register_n is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(
	i_Clk			:in std_logic;
	i_D			:in std_logic_vector(N-1 downto 0);
	i_Rst			:in std_logic;
	i_En			:in std_logic;
	o_Q			:out std_logic_vector(N-1 downto 0)
	);
end component;

  -- Temporary signals to connect to the dff component.
  signal s_CLK, s_RST, s_WE  : std_logic;
  signal s_D, s_Q : std_logic_vector(N-1 downto 0);

begin

  DUT0: register_n 
  port map(i_Clk => s_CLK, 
           i_Rst => s_RST,
           i_En  => s_WE,
           i_D   => s_D,
           o_Q   => s_Q);

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
    -- Reset the FF
    s_RST <= '1';
    s_WE  <= '0';
    s_D   <= X"AAAAAAAA";
    wait for cCLK_PER;

    -- Store '1'
    s_RST <= '0';
    s_WE  <= '1';
    s_D   <= X"0123ABCD";
    wait for cCLK_PER;  

    -- Keep '1'
    s_RST <= '0';
    s_WE  <= '0';
    s_D   <= X"FFFF0000";
    wait for cCLK_PER;  

    -- Store '0'    
    s_RST <= '0';
    s_WE  <= '1';
    s_D   <= X"10101010";
    wait for cCLK_PER;  

    -- Keep '0'
    s_RST <= '0';
    s_WE  <= '0';
    s_D   <= X"0FF0A00A";
    wait for cCLK_PER;  

    wait;
  end process;
  
end mixed;