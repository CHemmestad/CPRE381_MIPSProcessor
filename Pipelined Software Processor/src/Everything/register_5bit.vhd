-- Susanna Shenouda
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- register_5bit.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: this file contains a implementation of a 5 bit register which will be used as a component
-- Instruction Decode/Execute Stage of the Pipeline Register
--
--
-- NOTES:
-- 11/14/24 created
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

entity register_5bit is
  generic(N : integer := 5); -- Generic of type integer for input/output data width. Default value is 5.
  port(
	i_Clk			:in std_logic;
	i_D			:in std_logic_vector(N-1 downto 0);
	i_Rst			:in std_logic;
	i_En			:in std_logic;
	o_Q			:out std_logic_vector(N-1 downto 0)
	);
end register_5bit;

architecture structural of register_5bit is

  component dffg is
    port(
	i_CLK        : in std_logic;     -- Clock input
       	i_RST        : in std_logic;     -- Reset input
       	i_WE         : in std_logic;     -- Write enable input
       	i_D          : in std_logic;     -- Data value input
       	o_Q          : out std_logic
	);   -- Data value output
  end component;

begin
  G_Register_N: for i in 0 to N-1 generate
    registern1: dffg port map(
	i_CLK 		=> i_Clk,
	i_RST		=> i_Rst,
	i_WE		=> i_En,
	i_D		=> i_D(i),
	o_Q		=> o_Q(i)
	); 
  end generate G_Register_N;
  
end structural;