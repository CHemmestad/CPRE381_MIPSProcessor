-------------------------------------------------------------------------
-- Caleb Hemmestad
-- 
-- Iowa State University
-------------------------------------------------------------------------


-- mux2t1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Adder Nth
--
--
-- NOTES:
-- 9/2/24 created
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity Adder_N is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_Ain			:in std_logic_vector(N-1 downto 0);
	i_Bin			:in std_logic_vector(N-1 downto 0);
	i_Cin			:in std_logic;
	o_Sum			:out std_logic_vector(N-1 downto 0);
	o_Cout			:out std_logic);
end Adder_N;

architecture structural of Adder_N is

  component AdderStructural is
    port(i_Ain			:in std_logic;
	i_Bin			:in std_logic;
	i_Cin			:in std_logic;
	o_Sum			:out std_logic;
	o_Cout			:out std_logic);
  end component;
	
signal s_temp         :std_logic_vector(N downto 0);

begin
  s_temp(0) <= i_Cin;
  -- Instantiate N mux instances.
  G_NBit_ADDER: for i in 0 to N-1 generate
    ADDER: AdderStructural port map(
		i_Ain   => i_Ain(i),  -- ith instance's data 0 input hooked up to ith data 0 input.
              	i_Bin   => i_Bin(i),  -- ith instance's data 1 input hooked up to ith data 1 input.
              	i_Cin	=> s_temp(i),
		o_Sum   => o_Sum(i),  -- ith instance's data output hooked up to ith data output.
		o_Cout	=> s_temp(i+1));  
  end generate G_NBit_ADDER;
  o_Cout <= s_temp(N);
  
end structural;
