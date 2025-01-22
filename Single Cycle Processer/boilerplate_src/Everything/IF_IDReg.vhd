-- Susanna Shenouda
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- IF_IDReg.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: this file contains a implementation of a register for the 
-- Instruction Fetch/Decode Stage of the Pipeline Register
--
--
-- NOTES:
-- 11/5/24 created
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;



entity IF_IDReg is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(
	iClk		:in std_logic;
	iPCSrc		:in std_logic_vector(n-1 downto 0);
	inInstrNext 	: in std_logic_vector(n-1 downto 0);
	iRst		:in std_logic;
	iEn			:in std_logic;
	oFetchedInstr		: out std_logic_vector(n-1 downto 0);
	outInstrNext	:out std_logic_vector(n-1 downto 0)
	);
end IF_IDReg;

architecture structural of IF_IDReg is
	component dffg is
		port(i_CLK        : in std_logic;     -- Clock input
		 i_RST        : in std_logic;     -- Reset input
		 i_WE         : in std_logic;     -- Write enable input
		 i_D          : in std_logic;     -- Data value input
		 o_Q          : out std_logic);   -- Data value output
  
  end component;

	-- signal PCSource : std_logic_vector(31 downto 0);
	-- signal InstrMem	: std_logic_vector(31 downto 0);
	-- signal CLK

	begin 



dffFetched: for i in 0 to n-1 generate
	dff_fetched_inst: dffg port map(
		i_CLK => iClk,
		i_RST => iRst,
		i_WE  => iEn,
		i_D   => inInstrNext(i),
		o_Q   => oFetchedInstr(i));
		end generate;

dffPC: for i in 0 to n-1 generate		
		dff_pc_inst: dffg port map( 
			i_CLK => iClk,
			i_RST => iRst,
			i_WE  => iEn,
			i_D   => iPCSrc(i),
			o_Q   => outInstrNext(i));
			end generate;

	end structural;
	
