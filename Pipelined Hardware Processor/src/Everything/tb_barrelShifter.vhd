-------------------------------------------------------------------------
-- Nina Gadelha
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- tb_barrelShifter.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains testing cases/examples we will use in order to determine if barrelShifter.vhd
-- is working as expected.

-- 10/06/2024 by H3::Design created.
-------------------------------------------------------------------------

library IEEE;
library std;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;
use IEEE.numeric_std.all;
use std.textio.all;

entity tb_barrelShifter is
    generic(gCLK_HPER : time := 50 ns);
end tb_barrelShifter;

architecture mixed of tb_barrelShifter is
constant cCLK_PER : time := gCLK_HPER * 2;

component barrelShifter
port(
shiftDirection  	  : in std_logic;
shiftType   		  : in std_logic;
dataInput  		  : in std_logic_vector(31 downto 0);
shamt   		  : in std_logic_vector(4 downto 0);
dataOutput   		  : out std_logic_vector(31 downto 0));

end component;

signal s_CLK   				 : std_logic := '0';
signal tb_dataSignal   	 		 : std_logic_vector(31 downto 0) := (others => '0');
signal tb_shamtSignal   		 : std_logic_vector(4 downto 0) := (others => '0');
signal tb_shiftDirectionSignal           : std_logic := '0';
signal tb_shiftTypeSignal    		 : std_logic := '0';
signal tb_dataOutputSignal   		 : std_logic_vector(31 downto 0);


begin

DUT0: barrelShifter
port map(
shiftDirection => tb_shiftDirectionSignal,
shiftType => tb_shiftTypeSignal,
dataInput => tb_dataSignal,
shamt => tb_shamtSignal,
dataOutput => tb_dataOutputSignal);


P_CLK: process
begin

s_CLK <= '0';
wait for gCLK_HPER;
s_CLK <= '1';
wait for gCLK_HPER;

end process;


TestingDesign: process
begin

tb_dataSignal <= X"FFFFFFFF";	
tb_shamtSignal <= "01010";
tb_shiftDirectionSignal <= '0';
tb_shiftTypeSignal <= '0';
wait for cCLK_PER*2;

tb_dataSignal <= X"FFFFFFFE";	
tb_shamtSignal <= "01010";
tb_shiftDirectionSignal <= '0';
tb_shiftTypeSignal <= '0';
wait for cCLK_PER*2;


tb_dataSignal <= X"EEEEEEEF";	
tb_shamtSignal <= "01010";
tb_shiftDirectionSignal <= '0';
tb_shiftTypeSignal <= '1';
wait for cCLK_PER*2;

tb_dataSignal <= X"EEEEEEEE";	
tb_shamtSignal <= "01010";
tb_shiftDirectionSignal <= '0';
tb_shiftTypeSignal <= '1';
wait for cCLK_PER*2;


tb_dataSignal <= X"FDDDDDDD";	
tb_shamtSignal <= "01010";
tb_shiftDirectionSignal <= '1';
tb_shiftTypeSignal <= '0';
wait for cCLK_PER*2;

tb_dataSignal <= X"7DDDDDDD";	
tb_shamtSignal <= "01010";
tb_shiftDirectionSignal <= '1';
tb_shiftTypeSignal <= '0';
wait for cCLK_PER*2;


tb_dataSignal <= X"CCCCCCCC";
tb_shamtSignal <= "01010";
tb_shiftDirectionSignal <= '1';
tb_shiftTypeSignal <= '1';
wait for cCLK_PER*2;

tb_dataSignal <= X"7CCCCCCC";
tb_shamtSignal <= "01010";
tb_shiftDirectionSignal <= '1';
tb_shiftTypeSignal <= '1';
wait for cCLK_PER*2;

wait;
end process;


end mixed;