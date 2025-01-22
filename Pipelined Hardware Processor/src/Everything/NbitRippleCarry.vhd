-------------------------------------------------------------------------
-- Susanna Shenouda
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- NbitRippleCarry.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an N bit Ripple Carry Adder using 
-- structural VHDL
--
-- NOTES:
-- 9/23/2024 by SES::Design created.
-- 
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity NbitRippleCarry is
generic(n: integer :=32);
  port(iA             : in std_logic_vector(n-1 downto 0);
       iB             : in std_logic_vector(n-1 downto 0);
       iCin           : in std_logic;
       oS             : out std_logic_vector(n-1 downto 0);
       oCout	      : out std_logic);
  end NbitRippleCarry;

architecture structural of NbitRippleCarry is
	signal carry_bit	: std_logic_vector(n downto 0);
	component OnebitFullAdder is
	port(iA             : in std_logic;
       	     iB             : in std_logic;
       	     iCin           : in std_logic;
       	     oS             : out std_logic;
       	     oCout	    : out std_logic);
	end component;


begin 

carry_bit(0) <= iCin;

g_NbitRippleCarry : for x in 0 to n-1 generate
NbitRippleCarry : OnebitFullAdder port map (
	     iA  => iA(x),
       	     iB  => iB(x),
       	     iCin => carry_bit(x),
       	     oS => oS(x),
       	     oCout => carry_bit(x+1));

end generate g_NbitRippleCarry;
oCout <= carry_bit(n);
end structural;