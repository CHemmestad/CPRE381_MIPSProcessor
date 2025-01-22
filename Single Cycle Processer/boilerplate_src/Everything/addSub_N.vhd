-------------------------------------------------------------------------
-- Caleb Hemmestad
-- 
-- Iowa State University
-------------------------------------------------------------------------


-- addSub.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Add/Subract Nth
--
--
-- NOTES:
-- 9/3/24 created
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity addSub_N is
  generic(N : integer := 32); 
  port(i_Ain			:in std_logic_vector(N-1 downto 0);
	i_Bin			:in std_logic_vector(N-1 downto 0);
	i_nAdd_Sub		:in std_logic;
	o_Sum			:out std_logic_vector(N-1 downto 0);
	o_Cout			:out std_logic);
end addSub_N;

architecture structural of addSub_N is

component mux2t1_N is
  generic(N : integer := 32); 
  port(i_S          		: in std_logic;
       i_D0         		: in std_logic_vector(N-1 downto 0);
       i_D1         		: in std_logic_vector(N-1 downto 0);
       o_O          		: out std_logic_vector(N-1 downto 0));
end component;

component onesComp_N is
  generic(N : integer := 32);
  port(i_I 		        : in std_logic_vector(N-1 downto 0);
       o_O		        : out std_logic_vector(N-1 downto 0));
end component;

component Adder_N is
  generic(N : integer := 32); 
  port(i_Ain			:in std_logic_vector(N-1 downto 0);
	i_Bin			:in std_logic_vector(N-1 downto 0);
	i_Cin			:in std_logic;
	o_Sum			:out std_logic_vector(N-1 downto 0);
	o_Cout			:out std_logic);
end component;

signal s_mux	:std_logic_vector(N-1 downto 0);
signal s_comp	:std_logic_vector(N-1 downto 0);

begin
  g_mux1: mux2t1_N
    port MAP(
		i_S	=> i_nAdd_Sub,
		i_D0	=> s_comp,
		i_D1	=> i_Bin,
		o_O	=> s_mux
		);

  g_comp1: onesComp_N
    port MAP(
		i_I	=> i_Bin,
		o_O	=> s_comp
		);

  g_addSub: Adder_N
    port MAP(
		i_Ain	=> i_Ain,
		i_Bin	=> s_mux,
		i_Cin	=> i_nAdd_Sub,
		o_Sum	=> o_Sum,
		o_Cout	=> o_Cout
		);

end structural;







































































