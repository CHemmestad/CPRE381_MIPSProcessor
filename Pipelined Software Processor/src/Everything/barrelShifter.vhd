-------------------------------------------------------------------------
-- Nina Gadelha
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- barrelShifter.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a barrel shifter implementation using mux2t1_N and mux2t1. This barrel shifter will
-- be implemented in way in which the user can 'control' if they want a left or right shift aswell as a choice in
-- being able to shift by logical or arithmetic type.

-- 10/06/2024 by H3::Design created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity barrelShifter is
port(
shiftDirection   	 : in std_logic;    			 -- if shiftDirection is 0: shift left, if shiftDirection is 1: shift right
shiftType   		 : in std_logic;			 -- if shiftType is 0: type is logical, if shift type is 1: type is arithmetic
dataInput    		 : in std_logic_vector(31 downto 0);
shamt   		 : in std_logic_vector(4 downto 0);
dataOutput   		 : out std_logic_vector(31 downto 0));

end barrelShifter;


architecture mixed of barrelShifter is

component mux2t1_N is
generic(N : integer:= 16);
port(
i_S     : in std_logic;
i_D0    : in std_logic_vector(N-1 downto 0);
i_D1    : in std_logic_vector(N-1 downto 0);
o_O     : out std_logic_vector(N-1 downto 0));

end component;

component mux2t1 is
port(
i_S     : in std_logic;
i_D0    : in std_logic;
i_D1    : in std_logic;
o_O     : out std_logic);

end component;

component invg is 
port(
i_A	: in std_logic;
o_F	: out std_logic);

end component;

signal shiftBit   	 : std_logic;
signal inv_sig		 : std_logic;

signal dataSignal    	 : std_logic_vector(31 downto 0);
signal inLeftShift   	 : std_logic_vector(31 downto 0);
signal outLeftShift   	 : std_logic_vector(31 downto 0);

signal inShamt0   	 : std_logic_vector(31 downto 0);
signal outShamt0   	 : std_logic_vector(31 downto 0);

signal inShamt1   	 : std_logic_vector(31 downto 0);
signal outShamt1   	 : std_logic_vector(31 downto 0);

signal inShamt2   	 : std_logic_vector(31 downto 0);
signal outShamt2   	 : std_logic_vector(31 downto 0);

signal inShamt3   	 : std_logic_vector(31 downto 0);
signal outShamt3    	 : std_logic_vector(31 downto 0);

signal inShamt4   	 : std_logic_vector(31 downto 0);
signal outShamt4   	 : std_logic_vector(31 downto 0);

begin

-- In this code segmant, we are taking the value of 'dataInput' (bits 0 to 31), reversing the order, and storing
-- them in 'inLeftShift'.
inLeftShift(0) <= dataInput(31);
inLeftShift(1) <= dataInput(30);
inLeftShift(2) <= dataInput(29);
inLeftShift(3) <= dataInput(28);
inLeftShift(4) <= dataInput(27);
inLeftShift(5) <= dataInput(26);
inLeftShift(6) <= dataInput(25);
inLeftShift(7) <= dataInput(24);
inLeftShift(8) <= dataInput(23);
inLeftShift(9) <= dataInput(22);
inLeftShift(10) <= dataInput(21);
inLeftShift(11) <= dataInput(20);
inLeftShift(12) <= dataInput(19);
inLeftShift(13) <= dataInput(18);
inLeftShift(14) <= dataInput(17);
inLeftShift(15) <= dataInput(16);
inLeftShift(16) <= dataInput(15);
inLeftShift(17) <= dataInput(14);
inLeftShift(18) <= dataInput(13);
inLeftShift(19) <= dataInput(12);
inLeftShift(20) <= dataInput(11);
inLeftShift(21) <= dataInput(10);
inLeftShift(22) <= dataInput(9);
inLeftShift(23) <= dataInput(8);
inLeftShift(24) <= dataInput(7);
inLeftShift(25) <= dataInput(6);
inLeftShift(26) <= dataInput(5);
inLeftShift(27) <= dataInput(4);
inLeftShift(28) <= dataInput(3);
inLeftShift(29) <= dataInput(2);
inLeftShift(30) <= dataInput(1);
inLeftShift(31) <= dataInput(0);

switchInput: invg
port map(
i_A => shiftDirection,
o_F => inv_sig);


determineShiftDirection: mux2t1_N
generic map (N => 32)
port map(
i_S => inv_sig,
i_D1 => dataInput,
i_D0 => inLeftShift,
o_O => dataSignal);


determineShiftType: mux2t1
port map(
i_S => shiftType,
i_D1 => '0',				
i_D0 => dataSignal(31),
o_O => shiftBit);

inShamt0 (30 downto 0) <= dataSignal(31 downto 1);
inShamt0(31) <= shiftBit;


shamt0: mux2t1_N
generic map (N => 32)
port map(
i_S => shamt(0),
i_D1 => dataSignal,
i_D0 => inShamt0,
o_O => outShamt0);

inShamt1(29 downto 0) <= outShamt0(31 downto 2);
inShamt1(31) <= shiftBit;   			 
inShamt1(30) <= shiftBit;


shamt1: mux2t1_N
generic map (N => 32)
port map(
i_S => shamt(1),
i_D1 => outShamt0,
i_D0 => inShamt1,
o_O => outShamt1);

inShamt2(27 downto 0) <= outShamt1(31 downto 4);
inShamt2(31) <= shiftBit;
inShamt2(30) <= shiftBit;
inShamt2(29) <= shiftBit;
inShamt2(28) <= shiftBit;


shamt2: mux2t1_N
generic map (N => 32)
port map(
i_S => shamt(2),
i_D1 => outShamt1,
i_D0 => inShamt2,
o_O => outShamt2);

inShamt3(23 downto 0) <= outShamt2(31 downto 8);
inShamt3(31) <= shiftBit;
inShamt3(30) <= shiftBit;
inShamt3(29) <= shiftBit;
inShamt3(28) <= shiftBit;
inShamt3(27) <= shiftBit;
inShamt3(26) <= shiftBit;
inShamt3(25) <= shiftBit;
inShamt3(24) <= shiftBit;


shamt3: mux2t1_N
generic map (N => 32)
port map(
i_S => shamt(3),
i_D1 => outShamt2,
i_D0 => inShamt3,
o_O => outShamt3);

inShamt4(15 downto 0) <= outShamt3(31 downto 16);
inShamt4(31) <= shiftBit;
inShamt4(30) <= shiftBit;
inShamt4(29) <= shiftBit;
inShamt4(28) <= shiftBit;
inShamt4(27) <= shiftBit;
inShamt4(26) <= shiftBit;
inShamt4(25) <= shiftBit;
inShamt4(24) <= shiftBit;
inShamt4(23) <= shiftBit;
inShamt4(22) <= shiftBit;
inShamt4(21) <= shiftBit;
inShamt4(20) <= shiftBit;
inShamt4(19) <= shiftBit;
inShamt4(18) <= shiftBit;
inShamt4(17) <= shiftBit;
inShamt4(16) <= shiftBit;


shamt4: mux2t1_N
generic map (N => 32)
port map(
i_S => shamt(4),
i_D1 => outShamt3,
i_D0 => inShamt4,
o_O => outShamt4);

outLeftShift(0) <= outShamt4(31);
outLeftShift(1) <= outShamt4(30);
outLeftShift(2) <= outShamt4(29);
outLeftShift(3) <= outShamt4(28);
outLeftShift(4) <= outShamt4(27);
outLeftShift(5) <= outShamt4(26);
outLeftShift(6) <= outShamt4(25);
outLeftShift(7) <= outShamt4(24);
outLeftShift(8) <= outShamt4(23);
outLeftShift(9) <= outShamt4(22);
outLeftShift(10) <= outShamt4(21);
outLeftShift(11) <= outShamt4(20);
outLeftShift(12) <= outShamt4(19);
outLeftShift(13) <= outShamt4(18);
outLeftShift(14) <= outShamt4(17);
outLeftShift(15) <= outShamt4(16);
outLeftShift(16) <= outShamt4(15);
outLeftShift(17) <= outShamt4(14);
outLeftShift(18) <= outShamt4(13);
outLeftShift(19) <= outShamt4(12);
outLeftShift(20) <= outShamt4(11);
outLeftShift(21) <= outShamt4(10);
outLeftShift(22) <= outShamt4(9);
outLeftShift(23) <= outShamt4(8);
outLeftShift(24) <= outShamt4(7);
outLeftShift(25) <= outShamt4(6);
outLeftShift(26) <= outShamt4(5);
outLeftShift(27) <= outShamt4(4);
outLeftShift(28) <= outShamt4(3);
outLeftShift(29) <= outShamt4(2);
outLeftShift(30) <= outShamt4(1);
outLeftShift(31) <= outShamt4(0);


directionShiftOut: mux2t1_N
generic map (N => 32)
port map(
i_S => inv_sig,
i_D1 => outShamt4,
i_D0 => outLeftShift,
o_O => dataOutput);

end mixed;

