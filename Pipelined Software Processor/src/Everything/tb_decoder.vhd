
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

entity tb_decoder is
  generic(gCLK_HPER   	: time := 50 ns);
end tb_decoder;

architecture mixed of tb_decoder is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;

component decoder is

  port(
	i_En		: in std_logic;
	i_Code		: in std_logic_vector(4 downto 0);
	o_Decode	: out std_logic_vector(31 downto 0)
	);

end component;

  -- Temporary signals to connect to the dff component.
  signal s_En  	: std_logic;
  signal s_Co	: std_logic_vector(4 downto 0);
  signal s_Deco	: std_logic_vector(31 downto 0);

begin

  DUT0: decoder
  port map(
           i_En  	=> s_En,
           i_Code   	=> s_Co,
           o_Decode   	=> s_Deco
	);

  -- This process sets the clock value (low for gCLK_HPER, then high
  -- for gCLK_HPER). Absent a "wait" command, processes restart 
  -- at the beginning once they have reached the final statement.
  
  -- Testbench process  
  P_TB: process
  begin
    -- Reset the FF
    s_En  <= '0';
    s_Co   <= B"00001";
    wait for cCLK_PER;

    -- Store '1'
    s_En  <= '1';
    s_Co   <= B"00100";
    wait for cCLK_PER;  

    -- Keep '1'
    s_En  <= '0';
    s_Co   <= B"01111";
    wait for cCLK_PER;  

    -- Store '0'    
    s_En  <= '1';
    s_Co   <= B"11111";
    wait for cCLK_PER;  

    -- Keep '0'
    s_En  <= '1';
    s_Co   <= B"01010";
    wait for cCLK_PER;  

    s_En  <= '1';
    s_Co   <= B"00000";
    wait for cCLK_PER;

    wait;
  end process;
  
end mixed;