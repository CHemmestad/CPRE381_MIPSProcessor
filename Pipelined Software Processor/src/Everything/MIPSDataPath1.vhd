-------------------------------------------------------------------------
-- Caleb Hemmestad
-- 
-- Iowa State University
-------------------------------------------------------------------------


-- mux2t1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Adder Structural
--
--
-- NOTES:
-- 9/2/24 created
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;


entity MIPSDataPath1 is
  port(
	i_Clk			:in std_logic;
	i_En			:in std_logic;
	i_Rst			:in std_logic;
	i_Rs			:in std_logic_vector(4 downto 0);
	i_Rt			:in std_logic_vector(4 downto 0);
	i_Rd			:in std_logic_vector(4 downto 0);
	i_Imm			:in std_logic_vector(31 downto 0);
	i_ALUSrc		:in std_logic;
	i_nAdd_Sub		:in std_logic
	);
end MIPSDataPath1;

architecture structure of MIPSDataPath1 is

  component register_file is 
    port (
	i_Clk			:in std_logic;
	i_En			:in std_logic;
	i_Rst			:in std_logic;
	i_Rs			:in std_logic_vector;
	i_Rt			:in std_logic_vector;
	i_Rd			:in std_logic_vector;
	i_RdData		:in std_logic_vector;
	o_ReadA			:out std_logic_vector;
	o_ReadB			:out std_logic_vector
	);
  end component;

  component AdderWithMux is
    port (
  	i_Rs			:in std_logic_vector;
	i_Rt			:in std_logic_vector;
	i_Imm			:in std_logic_vector;
	i_nAdd_Sub		:in std_logic;
	i_ALUSrc		:in std_logic;
	o_Sum			:out std_logic_vector;
	o_Cout			:out std_logic
	);
  end component;
	
  signal s_Result		:std_logic_vector(31 downto 0);
  signal s_ReadA		:std_logic_vector(31 downto 0);
  signal s_ReadB		:std_logic_vector(31 downto 0);
  signal s_Overflow		:std_logic;

begin
  RegisterFile: register_file
    port map(
	i_Clk			=> i_clk,
	i_En			=> i_En,
	i_Rst			=> i_Rst,
	i_Rs			=> i_Rs,
	i_Rt			=> i_Rt,
	i_Rd			=> i_Rd,
	i_RdData		=> s_Result,
	o_ReadA			=> s_ReadA,
	o_ReadB			=> s_ReadB
	);

  AdderWMux: AdderWithMux
    port map(
	i_Rs			=> s_ReadA,
	i_Rt			=> s_ReadB,
	i_Imm			=> i_Imm,
	i_nAdd_Sub		=> i_nAdd_Sub,
	i_ALUSrc		=> i_ALUSrc,
	o_Sum			=> s_Result,
	o_Cout			=> s_Overflow
	);
  
end structure;
