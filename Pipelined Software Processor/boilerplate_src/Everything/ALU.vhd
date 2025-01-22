-- Susanna Shenouda
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- ALU.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of the Arithemtic Logic Unit using Structural VHDL

-- 10/20/2024 by SES::Design created.
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;


entity ALU is
  port(
        iA              :in std_logic_vector(31 downto 0);
	iB		:in std_logic_vector(31 downto 0);
	iImmediate	:in std_logic_vector(31 downto 0);
	iALUOp		:in std_logic_vector(3 downto 0);
	iALUsrc		:in std_logic;
	iShamt		:in std_logic_vector(4 downto 0);
	outF		:out std_logic_vector(31 downto 0);
	oCarryout	:out std_logic;
	oOverflow	:out std_logic;
	oZero		:out std_logic
	);
end ALU;

architecture structural of ALU is

component addSub_N
  port(i_Ain			:in std_logic_vector;
	i_Bin			:in std_logic_vector;
	i_nAdd_Sub		:in std_logic;
	o_Sum			:out std_logic_vector;
	o_Cout			:out std_logic
	);
end component;

component andg2 is
  port(
	i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic
	);
end component;


component org2 is
  port(
	i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic
	);
end component;


component xorg2 is
  port(
	i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic
	);
end component;


component norg2 is
  port(
	i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic
	);
end component;

component barrelShifter is
  port(
	shiftDirection     	: in std_logic;		-- if shiftDirection is 0: shift left, if shiftDirection is 1: shift right
	shiftType		: in std_logic;		-- if shiftType is 0: type is logical, if shift type is 1: type is arithmetic
	dataInput		: in std_logic_vector(31 downto 0);
	shamt			: in std_logic_vector(4 downto 0);
	dataOutput		: out std_logic_vector(31 downto 0)
	);
end component;

component mux2t1_N is
  port(
	i_S         : in std_logic;
	i_D0         : in std_logic_vector;
	i_D1         : in std_logic_vector;
	o_O          : out std_logic_vector
	);
end component;

signal s_ALUOp 		: std_logic_vector(3 downto 0);
signal s_shamt		: std_logic_vector(4 downto 0);
signal s_A 		: std_logic_vector(31 downto 0);
signal s_B 		: std_logic_vector(31 downto 0);
signal s_imm 		: std_logic_vector(31 downto 0);
signal s_muxSel 	: std_logic_vector(31 downto 0);
signal s_out 		: std_logic_vector(31 downto 0);
signal s_addOutput 	: std_logic_vector(31 downto 0);
signal s_subOutput 	: std_logic_vector(31 downto 0);
signal s_andOutput 	: std_logic_vector(31 downto 0);
signal s_orOutput 	: std_logic_vector(31 downto 0);
signal s_shiftOutput 	: std_logic_vector(31 downto 0);
signal s_norOutput 	: std_logic_vector(31 downto 0);
signal s_xorOutput 	: std_logic_vector(31 downto 0);
signal s_shiftLeftOutput: std_logic_vector(31 downto 0);
signal s_shiftRightLOutput:std_logic_vector(31 downto 0);
signal s_shiftRightAOutput:std_logic_vector(31 downto 0);
signal s_loadUpperOutput:std_logic_vector(31 downto 0);
signal s_setLessThan 	: std_logic_vector(31 downto 0);
signal s_carryOut 	: std_logic;
signal s_zero 		: std_logic;
signal s_overflow 	: std_logic;
signal s_ALUsrc		: std_logic;
signal s_dir		: std_logic;
signal s_shiftType	: std_logic;

begin

/*
ALU_g: ALU 
  port map(
	iA		=> s_A,
	iB		=> s_B,
	iImmediate	=> s_imm,
	iALUOp		=> s_ALUOp,
	iALUsrc		=> s_ALUsrc,
	iShamt		=> s_shamt,
	outF		=> s_out,
	oCarryout	=> s_carryOut,
	oOverflow	=> s_overflow,
	oZero		=> s_zero
	);
*/

s_A	<= iA;
s_B	<= iB;
s_imm	<= iImmediate;
s_ALUOp	<= iALUOp;
s_ALUsrc<= iALUsrc;
s_shamt	<= iShamt;

g_muxSel: mux2t1_N
  port map(
	o_O	=> s_muxSel,
	i_D1	=> s_B,
	i_D0	=> s_imm,
	i_S	=> s_ALUsrc
	);

g_add : addSub_N
  port map (
	i_Ain			=> s_A,
	i_Bin			=> s_muxSel,
	i_nAdd_Sub		=> '0',
	o_Sum			=> s_addOutput,
	o_Cout			=> s_carryOut
	);

g_sub : addSub_N
  port map (
	i_Ain			=> s_A,
	i_Bin			=> s_muxSel,
	i_nAdd_Sub		=> '1',
	o_Sum			=> s_subOutput,
	o_Cout			=> s_carryOut
	);

g_and_N : for i in 0 to 31 generate
 g_AND: andg2
  port map (
	i_A     => s_A(i),
       i_B      => s_muxSel(i),
       o_F      => s_andOutput(i)
	);
end generate g_and_N;

g_or_N : for i in 0 to 31 generate
 g_OR :  org2 
  port map(
	i_A     => s_A(i),
       i_B      => s_muxSel(i),
       o_F      => s_orOutput(i)
	);
end generate g_or_N;

g_nor_N : for i in 0 to 31 generate
 g_NOR: norg2
  port map(
	i_A	=> s_A(i),
	i_B    	=> s_muxSel(i),
	o_F     => s_norOutput(i)
	);
end generate g_nor_N;

g_xor_N : for i in 0 to 31 generate
 g_XOR: xorg2
  port map(
	i_A	=> s_A(i),
       i_B      => s_muxSel(i),
       o_F      => s_xorOutput(i)
	);
end generate g_xor_N;
	
g_shiftLeft: barrelShifter
  port map(
	shiftDirection  => '0',
	shiftType	=> '0',
	dataInput	=> s_B,
	shamt		=> s_shamt,
	dataOutput	=> s_shiftLeftOutput
	);

g_loadUpper: barrelShifter
  port map(
	shiftDirection  => '0',
	shiftType	=> '0',
	dataInput	=> s_imm,
	shamt		=> "10000",
	dataOutput	=> s_loadUpperOutput
	);

g_shiftRightL: barrelShifter
  port map(
	shiftDirection  => '1',
	shiftType	=> '0',
	dataInput	=> s_B,
	shamt		=> s_shamt,
	dataOutput	=> s_shiftRightLOutput
	);

g_shiftRightA: barrelShifter
  port map(
	shiftDirection  => '1',
	shiftType	=> '1',
	dataInput	=> s_B,
	shamt		=> s_shamt,
	dataOutput	=> s_shiftRightAOutput
	);


	process(s_subOutput)
	begin
	if(s_subOutput >= X"00000000") then
		s_setLessThan <= X"00000001";
	else
		s_setLessThan <= X"00000000";
	end if;
	end process;
	
	-- "MUX"
	with s_ALUOp select outF <=
	s_addOutput when "0010",
	s_subOutput when "0110",
	s_andOutput when "0000",
	s_orOutput when "0001",
	s_norOutput when "1100",
	s_xorOutput when "1000",
	s_setLessThan when "0111",
	s_shiftLeftOutput when "1110",
	s_shiftRightLOutput when "1111",
	s_shiftRightAOutput when "0011",
	s_loadUpperOutput when "0100",
	X"00000000" when others;

/*
	process(s_ALUOp)
	begin
	if(s_ALUOp(3 downto 1) = "111") then
		s_shiftType 	<= s_ALUOp(0);
		s_dir 		<= s_ALUOp(0);
		outF 		<= s_shiftOutput;
	end if;
	end process;
*/
	
	process(s_subOutput)
	begin
	if(s_subOutput = X"00000000") then
		s_zero <= '1';
	else 
		s_zero <= '0';
	end if;
	end process;
	
	-- outF		<= s_out;
	oCarryout	<= s_carryOut;
	oOverflow	<= s_carryOut;
	oZero		<= s_zero;
	
end structural;
