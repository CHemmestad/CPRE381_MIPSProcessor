-------------------------------------------------------------------------
-- Nina Gadelha
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- tb_fetchLogic.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a barrel shifter implementation using mux2t1_N and mux2t1. This barrel shifter will
-- be implemented in way in which the user can 'control' if they want a left or right shift aswell as a choice in
-- being able to shift by logical or arithmetic type.

-- 10/06/2024 by H3::Design created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_fetchLogic is
    generic(gCLK_HPER : time := 50 ns);
end tb_fetchLogic;

architecture mixed of tb_fetchLogic is
component fetchLogic
port(
jumpRegSelector		: in std_logic;		
jumpSelector		: in std_logic;
branchSelector		: in std_logic;	
branchDeterminer	: in std_logic;		
PC			: in std_logic_vector(31 downto 0);
branchAdder		: in std_logic_vector(31 downto 0);
jumpAdder		: in std_logic_vector(31 downto 0);
jumpRegAddy		: in std_logic_vector(31 downto 0);
PCOutput		: out std_logic_vector(31 downto 0);
PCAddFourOutput		: out std_logic_vector(31 downto 0));

end component;


signal s_jumpRegSelector	: std_logic;			
signal s_branchSelector		: std_logic;			
signal s_branchDeterminer	: std_logic;			
signal s_jumpSelector		: std_logic;			

signal s_PC			: std_logic_vector(31 downto 0);	
signal s_branchAdder		: std_logic_vector(31 downto 0);	
signal s_jumpAdder		: std_logic_vector(31 downto 0);	
signal s_jumpRegAdder      	: std_logic_vector(31 downto 0);	
signal s_PCOutput		: std_logic_vector(31 downto 0);	
signal s_PCAddFourOutput	: std_logic_vector(31 downto 0);	


begin

DUT0 : fetchLogic
port map(
jumpRegSelector => s_jumpRegSelector,
jumpSelector => s_jumpSelector,
branchSelector => s_branchSelector,		
branchDeterminer => s_branchDeterminer,		
PC => s_PC,		
branchAdder => s_branchAdder,	
jumpAdder => s_jumpAdder,
jumpRegAddy => s_jumpRegAdder,
PCOutput => s_PCOutput,
PCAddFourOutput => s_PCAddFourOutput);

--PC => s_PC,				
--branchAdder => s_branchAdder,		
--jumpAdder => s_jumpAdder,		
--jumpRegAddy => s_jumpRegAdder,		
--jumpRegSelector => s_jumpRegSelector,	
--branchSelector => s_branchSelector,	
--branchDeterminer => s_branchDeterminer,	
--jumpSelector => s_jumpSelector,		
--PCOutput => s_PCOutput,			
--PCAddFourOutput => s_PCAddFourOutput);


TestingDesign: process
begin


s_PC <= x"10000000";		
s_branchAdder <= x"00000100";	
s_jumpAdder <= x"00000DE0";	
s_jumpRegAdder <= x"40000000";	


s_jumpRegSelector <= '0';	
s_branchSelector <= '0';	
s_branchDeterminer <= '0';	
s_jumpSelector <= '0';		
wait for 50 ns;


s_jumpRegSelector <= '0';
s_branchSelector <= '0';
s_branchDeterminer <= '1';
s_jumpSelector <= '0';
wait for 50 ns;


s_jumpRegSelector <= '0';
s_branchSelector <= '1';
s_branchDeterminer <= '1';
s_jumpSelector <= '0';
wait for 50 ns;


s_jumpRegSelector <= '0';
s_branchSelector <= '0';
s_branchDeterminer <= '0';
s_jumpSelector <= '1';
wait for 50 ns;


s_jumpRegSelector <= '1';
s_branchSelector <= '0';
s_branchDeterminer <= '0';
s_jumpSelector <= '1';
wait for 50 ns;

end process;
end mixed;
