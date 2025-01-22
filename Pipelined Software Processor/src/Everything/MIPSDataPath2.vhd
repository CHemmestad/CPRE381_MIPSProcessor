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


entity MIPSDataPath2 is
  port(
	i_Clk			:in std_logic;
	i_En			:in std_logic;
	i_MemEn			:in std_logic;
	i_MemRd			:in std_logic;
	i_Rst			:in std_logic;
	i_Rs			:in std_logic_vector(4 downto 0);
	i_Rt			:in std_logic_vector(4 downto 0);
	i_Rd			:in std_logic_vector(4 downto 0);
	i_Imm			:in std_logic_vector(15 downto 0);
	i_ALUSrc		:in std_logic;
	i_nAdd_Sub		:in std_logic
	);
end MIPSDataPath2;

architecture structure of MIPSDataPath2 is

  component register_file is 
    port(
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
    port(
  	i_Rs			:in std_logic_vector;
	i_Rt			:in std_logic_vector;
	i_Imm			:in std_logic_vector;
	i_nAdd_Sub		:in std_logic;
	i_ALUSrc		:in std_logic;
	o_Sum			:out std_logic_vector;
	o_Cout			:out std_logic
	);
  end component;

  component bitExtender is
    port(
	i_Data			:in std_logic_vector;
	i_Sign			:in std_logic;
	o_Ext			:out std_logic_vector
	);
  end component;

  component mem is
    port(
	clk			:in std_logic;
	addr	        	:in std_logic_vector;
	data	        	:in std_logic_vector;
	we			:in std_logic;
	q			:out std_logic_vector
	);
  end component;

  component max2t1_N is
    port(
	i_S          		:in std_logic;
       	i_D0         		:in std_logic_vector;
       	i_D1         		:in std_logic_vector;
       	o_O          		:out std_logic_vector
	);
  end component;
	
signal s_ExtOut			:std_logic_vector(31 downto 0);
signal s_Result			:std_logic_vector(31 downto 0);
signal s_ReadA			:std_logic_vector(31 downto 0);
signal s_ReadB			:std_logic_vector(31 downto 0);
signal s_MemOut			:std_logic_vector(31 downto 0);
signal s_MuxOut			:std_logic_vector(31 downto 0);

signal s_Overflow		:std_logic;

begin
  Extender: bitExtender
    port map(
	i_Data			=> i_Imm,
	i_Sign			=> '1',
	o_Ext			=> s_ExtOut
	);
  
  ALU: AdderWithMux
    port map(
	i_Rs			=> s_ReadA,
	i_Rt			=> s_ReadB,
	i_Imm			=> s_ExtOut,
	i_nAdd_Sub		=> i_nAdd_Sub,
	i_ALUSrc		=> i_ALUSrc,
	o_Sum			=> s_Result,
	o_Cout			=> s_Overflow
	);

  RegisterFile: register_file
    port map(
	i_Clk			=> i_clk,
	i_En			=> i_En,
	i_Rst			=> i_Rst,
	i_Rs			=> i_Rs,
	i_Rt			=> i_Rt,
	i_Rd			=> i_Rd,
	i_RdData		=> s_MuxOut,
	o_ReadA			=> s_ReadA,
	o_ReadB			=> s_ReadB
	);

  Memory: mem
    port map(
	clk			=> i_clk,
	addr	        	=> s_Result(9 downto 0),
	data	        	=> s_ReadB,
	we			=> i_MemEn,
	q			=> s_MemOut
	);

  Mux: max2t1_N
    port map(
	i_S          		=> i_MemRd,
       	i_D0         		=> s_MemOut,
       	i_D1         		=> s_Result,
       	o_O          		=> s_MuxOut
	);
 
end structure;
