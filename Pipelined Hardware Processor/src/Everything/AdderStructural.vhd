-------------------------------------------------------------------------
-- Caleb Hemmestad
-- 
-- Iowa State University
-------------------------------------------------------------------------


-- mux2t1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Adder Structural
--
--
-- NOTES:
-- 9/2/24 created
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;


entity AdderStructural is
  port(i_Ain			:in std_logic;
	i_Bin			:in std_logic;
	i_Cin			:in std_logic;
	o_Sum			:out std_logic;
	o_Cout			:out std_logic);
end AdderStructural;

architecture structure of AdderStructural is
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

  component xorg2
    port(i_A        : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
  end component;

  signal s_AxorB	:std_logic;
  signal s_AxorBandCin	:std_logic;
  signal s_AandB	:std_logic;

begin
  g_xor1: xorg2
    port MAP(i_A	=> i_Ain,
	     	i_B	=> i_Bin,
		o_F	=> s_AxorB);
  
  g_xor2: xorg2
    port MAP(i_A	=> s_AxorB,
		i_B	=> i_Cin,
		o_F	=> o_Sum);

  g_and1: andg2
    port MAP(i_A	=> s_AxorB,
		i_B	=> i_Cin,
		o_F	=> s_AxorBandCin);

  g_and2: andg2
    port MAP(i_A	=> i_Ain,
		i_B	=> i_Bin,
		o_F	=> s_AandB);

  g_or1: org2
    port MAP(i_A	=> s_AxorBandCin,
		i_B	=> s_AandB,
		o_F	=> o_Cout);
end structure;
