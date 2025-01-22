-------------------------------------------------------------------------
-- Caleb Hemmestad
-- 
-- Iowa State University
-------------------------------------------------------------------------


-- mux2t1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: 2:1 MUX
--
--
-- NOTES:
-- 9/1/24 created
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;


entity mux2t1 is

  port(i_D1 		            : in std_logic;
       i_D0 		            : in std_logic;
       i_S 		            : in std_logic;
       o_O		            : out std_logic);

end mux2t1;

architecture structure of mux2t1 is

  component invg
    port(i_A        : in std_logic;
       o_F          : out std_logic);
  end component;

  component andg2
    port(i_A        : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
  end component;

  component org2
    port(i_A        : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
  end component;

  signal s_S	:std_logic;
  signal s_SxI1	:std_logic;
  signal s_SxI0	:std_logic;

begin

  g_Not: invg
    port MAP(i_A	=> i_S,
	     o_F	=> s_S);

  g_And1: andg2
    port MAP(i_A	=> i_D1,
	     i_B	=> s_S,
	     o_F	=> s_SxI1);

  g_And2: andg2
    port MAP(i_A	=> i_S,
	     i_B	=> i_D0,
	     o_F	=> s_SxI0);

  g_Or1: org2
    port MAP(i_A	=> s_SxI1,
	     i_B	=> s_SxI0,
	     o_F	=> o_O);

end structure;
