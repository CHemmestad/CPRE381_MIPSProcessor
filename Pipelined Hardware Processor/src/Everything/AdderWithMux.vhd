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


entity AdderWithMux is
  port(i_Rs			:in std_logic_vector(31 downto 0);
	i_Rt			:in std_logic_vector(31 downto 0);
	i_Imm			:in std_logic_vector(31 downto 0);
	i_nAdd_Sub		:in std_logic;
	o_Sum			:out std_logic_vector(31 downto 0);
	o_Cout			:out std_logic;
	
	i_ALUSrc		:in std_logic
	);
end AdderWithMux;

architecture structure of AdderWithMux is

  component addSub_N
    port(i_Ain			:in std_logic_vector;
	i_Bin			:in std_logic_vector;
	i_nAdd_Sub		:in std_logic;
	o_Sum			:out std_logic_vector;
	o_Cout			:out std_logic
	);
  end component;

  component mux2t1_N is
    port(i_S          : in std_logic;
       	i_D0         : in std_logic_vector;
       	i_D1         : in std_logic_vector;
       	o_O          : out std_logic_vector
	);
  end component;
	
  signal s_Out		:std_logic_vector(31 downto 0);

begin
  g_muxSel: mux2t1_N
    port map(
		o_O	=> s_Out,
		i_D1	=> i_Rt,
		i_D0	=> i_Imm,
		i_S	=> i_ALUSrc
		);

  g_AdderSub: addSub_N
    port map(
		i_Ain		=> i_Rs,
		i_Bin		=> s_Out,
		i_nAdd_Sub	=> i_nAdd_Sub,
		o_Sum		=> o_Sum,
		o_Cout		=> o_Cout
		);
end structure;
