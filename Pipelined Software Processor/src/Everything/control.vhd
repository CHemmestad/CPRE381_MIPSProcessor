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
	ALUOp		:out std_logic_vector(3 downto 0);

	overflowr	: out std_logic;
	overflowi   :out std_logic;

	sign		:out std_logic;
	jumpReg		:out std_logic;
	jumpAndLink	:out std_logic

	);
end control;

architecture behavioral of control is

signal s_sel	: std_logic_vector(11 downto 0);
signal s_opCode	: std_logic_vector(1 downto 0);
signal s_ALUOp	: std_logic_vector(3 downto 0);
signal s_ALUOp1	: std_logic_vector(3 downto 0);
signal s_ALUOp2	: std_logic_vector(3 downto 0);
signal s_ALUOp3	: std_logic_vector(3 downto 0);
signal s_ALUOp4	: std_logic_vector(3 downto 0);



  begin
	--[10-9] ALUOp, [8-0] Control
	with opCode select s_sel <=
	"100100000010" when "000000", -- R Types
	"001000000110" when "001000", -- addi
	"001000000110" when "001001", -- addiu
	"000000000110" when "001100", -- andi
	"000000000110" when "001111", -- lui
	"000000110110" when "100011", -- lw
	"000000000110" when "001110", -- xori
	"000000000110" when "001101", -- ori
	"000000001100" when "101011", -- sw
	"001001000000" when "000100", -- beq
	"001001000000" when "000101", -- bne
	"001000000110" when "001010", -- slti
	"010010000000" when "000010", -- j
	"010110000010" when "000011", -- jal
	"000000000001" when "010100", -- halt
	"110000000001" when others;
	
	-- sign		<= s_sel(9);
	regDst 		<= s_sel(8);
	jump 		<= s_sel(7);
	branch		<= s_sel(6);
	memRead		<= s_sel(5);
	memToReg	<= s_sel(4);
	memWrite	<= s_sel(3);
	ALUsrc		<= s_sel(2);
	regWrite	<= s_sel(1);
	halt		<= s_sel(0);
	s_opCode	<= s_sel(11 downto 10);
	
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
	"0010" when "001000", -- jr
	-- use far right bit of ALUOp for left, right, and type signal
	"1110" when "000000", -- sll
	"1111" when "000010", -- srl
	"0000" when others;

	with funct select overflowr <=
	'1' when "100000", --add
	'1' when "100010", --sub
	'1' when "101010",  -- slt
	'0' when others;

	process(opCode, funct)
	begin
	if(opCode = "000000") then
		if(funct = "001000") then
			jumpReg <= '1';
		else
			jumpReg <= '0';
		end if;
	else
		jumpReg <= '0';
	end if;
	end process;

/*
	process(opCode, funct)
	begin
	if(opCode = "000000" & funct = "001000") then
		jumpReg <= '1';
	else
		jumpReg <= '0';
	end if;
	end process;

	with opCode select jumpReg <=
	'1' when "000000" and funct = "001000",
	'0' when others;

	with funct select jumpReg <=
	'1' when "001000",
	'0' when others;
*/

	with opCode select jumpAndLink <=
	'1' when "000011",
	'0' when others;

	with opCode select overflowi <=
	'1' when "001000", -- addi
	'1' when "001010", -- slti
	'0' when others;
	
	with opCode select sign <=
	'1' when "001000", --addi 
	'1' when "001001", --addiu
	'0' when "001100", --andi
	'1' when "100011", --lw
	'0' when "001101", --ori
	'1' when "001010", --slti
	'1' when "101011", --sw
	'0' when others;

	
	with opCode select s_ALUOp2 <=
	"0010" when "001000", -- addi
	"0010" when "001001", -- addiu
	"0000" when "001100", -- andi
	"0100" when "001111", -- lui
	"0010" when "100011", -- lw
	"1000" when "001110", -- xori
	"0001" when "001101", -- ori
	"0010" when "101011", -- sw
	"0111" when "001010", -- slti
	"0010" when "000100", -- beq (branch instructions do not write to anything so ALUOp doesnt matter using it for the zero output)
	"0110" when "000101", -- bne
	"0000" when others;

	s_ALUOp3 <= "0010";

	with s_opCode select s_ALUOp <=
	s_ALUOp1 when "10",
	s_ALUOp2 when "00",
	s_ALUOp3 when "01",
	"0000" when others;
	
	ALUOp <= s_ALUOp;

  end behavioral;
