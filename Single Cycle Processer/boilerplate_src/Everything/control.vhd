-------------------------------------------------------------------------
-- Caleb Hemmestad
-- 
-- Iowa State University
-------------------------------------------------------------------------


-------------------------------------------------------------------------
-- DESCRIPTION: Reg file Nth
--
--
-- NOTES:
-- 9/18/24 created
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity control is
  port(
	clk		:in std_logic;
	opCode		:in std_logic_vector(5 downto 0);
	funct		:in std_logic_vector(5 downto 0);
	regDst		:out std_logic;
	regWrite	:out std_logic;
	jump		:out std_logic;
	branch		:out std_logic;
	memRead		:out std_logic;
	memWrite	:out std_logic;
	memToReg	:out std_logic;
	ALUSrc		:out std_logic;
	halt		:out std_logic;
	ALUOp		:out std_logic_vector(3 downto 0)
	);
end control;

architecture behavioral of control is

signal s_sel	: std_logic_vector(10 downto 0);
signal s_opCode	: std_logic_vector(1 downto 0);
signal s_ALUOp	: std_logic_vector(3 downto 0);
signal s_ALUOp1	: std_logic_vector(3 downto 0);
signal s_ALUOp2	: std_logic_vector(3 downto 0);
signal s_ALUOp3	: std_logic_vector(3 downto 0);
signal s_ALUOp4	: std_logic_vector(3 downto 0);

  begin
	--[10-9] ALUOp, [8-0] Control
	with opCode select s_sel <=
	"10100010010" when "000000", -- R Types
	"00000010110" when "001000", -- addi
	"00000010110" when "001001", -- addiu
	"00000010110" when "001100", -- andi
	"00000010110" when "001111", -- lui
	"00000110110" when "100011", -- lw
	"00000010110" when "001110", -- xori
	"00000010110" when "001101", -- ori
	"00000001100" when "101011", -- sw
	"01001000000" when "000100", -- beq
	"01001000000" when "000101", -- bne
	"01000010010" when "001010", -- slti
	"01010000000" when "000010", -- j
	"01110000010" when "000011", -- jal
	"00000000001" when "010100", -- halt
	"11000000001" when others;
	
	halt		<= s_sel(8);
	regDst 		<= s_sel(7);
	jump 		<= s_sel(6);
	branch		<= s_sel(5);
	memRead		<= s_sel(4);
	memToReg	<= s_sel(3);
	memWrite	<= s_sel(2);
	ALUsrc		<= s_sel(1);
	regWrite	<= s_sel(0);
	s_opCode	<= s_sel(10 downto 9);
	
	-- ALU Control
	with funct select s_ALUOp1 <=
	"0010" when "100000", -- add
	"0010" when "100001", -- addu
	"0000" when "100100", -- and
	"1100" when "100111", -- nor
	"1000" when "100110", -- xor
	"0001" when "100101", -- or
	"0111" when "101010", -- slt
	"0110" when "100010", -- sub
	"0110" when "100011", -- subu
	"0011" when "000011", -- sra
	"0110" when "001000", -- jr
	-- use far right bit of ALUOp for left, right, and type signal
	"1110" when "000000", -- sll
	"1111" when "000010", -- srl
	"0000" when others;
	
	with opCode select s_ALUOp2 <=
	"0010" when "001000", -- addi
	"0010" when "001001", -- addiu
	"0000" when "001100", -- andi
	"0100" when "001111", -- lui
	"0010" when "100011", -- lw
	"1000" when "001110", -- xori
	"0001" when "001101", -- ori
	"0010" when "101011", -- sw
	"0000" when others;

	s_ALUOp3 <= "0110";
	
	with s_opCode select s_ALUOp <=
	s_ALUOp1 when "10",
	s_ALUOp2 when "00",
	s_ALUOp3 when "01",
	"0000" when others;
	
	ALUOp <= s_ALUOp;

  end behavioral;
