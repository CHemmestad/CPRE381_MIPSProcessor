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

entity tb_bitExtender is
  generic(gCLK_HPER   	: time := 50 ns);
end tb_bitExtender;

architecture mixed of tb_bitExtender is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


component bitExtender is
  port(
	i_Data			:in std_logic_vector;
	i_Sign			:in std_logic := '0';
	o_Ext			:out std_logic_vector
	);
  
end component;

  -- Temporary signals to connect to the dff component.
  signal s_CLK  : std_logic;
  signal s_DATA : std_logic_vector(15 downto 0);
  signal s_SIGN : std_logic := '0';
  signal s_Q : std_logic_vector(31 downto 0);

begin

  DUT0: bitExtender 
  port map(
	i_Data			=> s_DATA,
	i_Sign			=> s_SIGN,
	o_Ext			=> s_Q
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

    s_DATA	<= X"1234";
    wait for cCLK_PER;
    
    s_Sign	<= '1';
    s_DATA	<= X"FBCD";
    wait for cCLK_PER;

    s_Sign	<= '1';
    s_DATA	<= X"7BCD";
    wait for cCLK_PER;

    s_Sign	<= '0';
    s_DATA	<= X"FFFF";
    wait for cCLK_PER;

    wait;

  end process;
  
end mixed;
