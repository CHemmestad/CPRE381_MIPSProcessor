-------------------------------------------------------------------------
-- Nina Gadelha
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- fetchLogic.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a barrel shifter implementation using mux2t1_N and mux2t1. This barrel shifter will
-- be implemented in way in which the user can 'control' if they want a left or right shift aswell as a choice in
-- being able to shift by logical or arithmetic type.

-- 10/06/2024 by H3::Design created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity fetchLogic is
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

end fetchLogic;

architecture mixed of fetchLogic is

component barrelShifter is
port(
shiftDirection   	 : in std_logic;    			 -- if shiftDirection is 0: shift left, if shiftDirection is 1: shift right
shiftType   		 : in std_logic;			 -- if shiftType is 0: type is logical, if shift type is 1: type is arithmetic
dataInput    		 : in std_logic_vector(31 downto 0);
shamt   		 : in std_logic_vector(4 downto 0);
dataOutput   		 : out std_logic_vector(31 downto 0));

end component;


component fullAdder_N is
port(
carryBit	: in std_logic;
o_Cout		: out std_logic;
o_Overflow	: out std_logic;
i_Ain		: in std_logic_vector(31 downto 0);
i_Bin		: in std_logic_vector(31 downto 0);
o_Sum		: out std_logic_vector(31 downto 0));

end component;


component mux2t1_N is
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(31 downto 0);
       i_D1         : in std_logic_vector(31 downto 0);
       o_O          : out std_logic_vector(31 downto 0));

end component;


signal s_branchDeterminer	: std_logic;					-- sig for determining if we branch

signal s_jumpAddy		: std_logic_vector(31 downto 0);		-- sig for jump add after shift 
signal s_branchAddy		: std_logic_vector(31 downto 0);		-- sig for branch addy after left shift (by 2) 

signal s_PCAddFour		: std_logic_vector(31 downto 0);		-- sig for PC+4
signal s_PCBranchAdder		: std_logic_vector(31 downto 0);		
signal s_PCJumpAddy		: std_logic_vector(31 downto 0);		
signal s_PCBranchAddy		: std_logic_vector(31 downto 0);		 
signal s_PCBranchJump		: std_logic_vector(31 downto 0);		-- sig for PC, branch or jump (one at a time)


begin


ShiftBranch : barrelShifter
port map(
shiftDirection => '0',	  	-- shift left	
shiftType => '0', 		-- logical type shift 
dataInput => branchAdder,   		 
shamt => "00010",		-- shift left by 2 		
dataOutput => s_branchAddy);


JumpShiftAddy : barrelShifter
port map(
shiftDirection => '0',	  	-- shift left	
shiftType => '0', 		-- logical type shift 
dataInput => jumpAdder,   		 
shamt => "00010",		-- shift left by 2 		
dataOutput => s_jumpAddy);

s_PCJumpAddy <= s_PCAddFour(31 downto 28) & s_jumpAddy(27 downto 0);
s_branchDeterminer <= branchDeterminer AND branchSelector;



PCAdder : fullAdder_N
port map(
carryBit => '0', -- for no carry bit
i_Ain => PC,
i_Bin => x"00000004",
o_Sum => s_PCAddFour);

PCAddFourOutput <= s_PCAddFour;


PCBranchAdder : fullAdder_N
port map(
carryBit => '0', 
i_Ain => s_PCAddFour,
i_Bin => s_branchAddy,
o_Sum => s_PCBranchAdder);



SelectJump : mux2t1_N
port map(
i_S => jumpSelector,
i_D1 => s_PCBranchAddy,
i_D0 => s_PCJumpAddy,
o_O => s_PCBranchJump);


SelectJumpReg : mux2t1_N
port map(
i_S => jumpRegSelector,
i_D1 => s_PCBranchJump,
i_D0 => jumpRegAddy,
o_O => PCOutput);


SelectBranch : mux2t1_N
port map(
i_S => s_branchDeterminer,
i_D1 => s_PCAddFour,
i_D0 => s_PCBranchAdder,
o_O => s_PCBranchAddy);
                                                                                                                                     
end mixed;
