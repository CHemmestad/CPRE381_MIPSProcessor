-------------------------------------------------------------------------
-- Caleb Hemmestad
-- 
-- Iowa State University
-------------------------------------------------------------------------


-- mux2t1dataflow.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: 2:1 MUX Dataflow
--
--
-- NOTES:
-- 9/2/24 created
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;


entity onesComp_N is
  generic(N : integer := 32);
  port(i_I 		            : in std_logic_vector(N-1 downto 0);
       o_O		            : out std_logic_vector(N-1 downto 0));

end onesComp_N;

architecture structure of onesComp_N is

  component invg
    port(i_A	:in std_logic;
	 o_F	:out std_logic);
  end component;

  begin
    OnesComp: for i in 0 to N-1 generate
      COMP: invg port MAP(i_A	=> i_I(i),
			  o_F	=> o_O(i));
    end generate OnesComp;
  end structure;
