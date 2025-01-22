/*

Caleb Hemmestad

EX/MEM Register

*/

library IEEE;
use IEEE.std_logic_1164.all;

entity EX_MEMReg is
  port(
	iClk		: in std_logic;
	iRst		: in std_logic;
	iEn		: in std_logic;

	iWBRegWrite	: in std_logic;
	iWBMemtoReg	: in std_logic;
	iMBranch	: in std_logic;
	iMMemRead	: in std_logic;
	iMMemWrite	: in std_logic;
	iZero		: in std_logic;
	iALUResult	: in std_logic_vector(31 downto 0);
	iAddResult	: in std_logic_vector(31 downto 0);
	iRtData		: in std_logic_vector(31 downto 0);
	iRegDst		: in std_logic_vector(4 downto 0);
	iHalt		: in std_logic;

	jump		: in std_logic;
	jumpReg		: in std_logic;
	jumpAndLink	: in std_logic;
	jumpAddr	: in std_logic_vector(31 downto 0);
	jumpRegAddr	: in std_logic_vector(31 downto 0);
	nextPC		: in std_logic_vector(31 downto 0);

	oWBRegWrite	: out std_logic;
	oWBMemtoReg	: out std_logic;
	oMBranch	: out std_logic;
	oMMemRead	: out std_logic;
	oMMemWrite	: out std_logic;
	oZero		: out std_logic;
	oALUResult	: out std_logic_vector(31 downto 0);
	oAddResult	: out std_logic_vector(31 downto 0);
	oRtData		: out std_logic_vector(31 downto 0);
	oRegDst		: out std_logic_vector(4 downto 0);
	oHalt		: out std_logic;

	oJump		: out std_logic;
	oJumpReg	: out std_logic;
	oJumpAndLink	: out std_logic;
	oJumpAddr	: out std_logic_vector(31 downto 0);
	oJumpRegAddr	: out std_logic_vector(31 downto 0);
	oNextPC		: out std_logic_vector(31 downto 0)
	);
end EX_MEMReg;

architecture mixed of EX_MEMReg is

component register_n is
	port (
		i_Clk			:in std_logic;
		i_D			:in std_logic_vector(31 downto 0);
		i_Rst			:in std_logic;
		i_En			:in std_logic;
		o_Q			:out std_logic_vector(31 downto 0));
	end component;

signal sD_WBRegWrite	: std_logic;
signal sD_WBMemtoReg	: std_logic;
signal sD_MBranch	: std_logic;
signal sD_MMemRead	: std_logic;
signal sD_MMemWrite	: std_logic;
signal sD_Zero		: std_logic;
signal sD_ALUResult	: std_logic_vector(31 downto 0);
signal sD_AddResult	: std_logic_vector(31 downto 0);
signal sD_RtData	: std_logic_vector(31 downto 0);
signal sD_RegDst	: std_logic_vector(4 downto 0);
signal sD_Halt		: std_logic;
signal sD_jumpAddr	: std_logic_vector(31 downto 0);
signal sD_jumpRegAddr	: std_logic_vector(31 downto 0);
signal sD_jump		: std_logic;
signal sD_jumpReg	: std_logic;
signal sD_jumpAndLink	: std_logic;
signal sD_nextPC	: std_logic_vector(31 downto 0);

signal sQ_WBRegWrite	: std_logic;
signal sQ_WBMemtoReg	: std_logic;
signal sQ_MBranch	: std_logic;
signal sQ_MMemRead	: std_logic;
signal sQ_MMemWrite	: std_logic;
signal sQ_Zero		: std_logic;
signal sQ_ALUResult	: std_logic_vector(31 downto 0);
signal sQ_AddResult	: std_logic_vector(31 downto 0);
signal sQ_RtData	: std_logic_vector(31 downto 0);
signal sQ_RegDst	: std_logic_vector(4 downto 0);
signal sQ_Halt		: std_logic;
signal sQ_jumpAddr	: std_logic_vector(31 downto 0);
signal sQ_jumpRegAddr	: std_logic_vector(31 downto 0);
signal sQ_jump		: std_logic;
signal sQ_jumpReg	: std_logic;
signal sQ_jumpAndLink	: std_logic;
signal sQ_nextPC	: std_logic_vector(31 downto 0);

begin 

ALURESULTS_DFFG: register_n port map (
i_Clk	=> iClk,
i_D	=> iALUResult,
i_Rst	=> iRst,
i_En	=> iEn,
o_Q	=> oALUResult
);


  oWBRegWrite	<= sQ_WBRegWrite;
  oWBMemtoReg	<= sQ_WBMemtoReg;
  oMBranch	<= sQ_MBranch;
  oMMemRead	<= sQ_MMemRead;
  oMMemWrite	<= sQ_MMemWrite;
  oZero		<= sQ_Zero;
 -- oALUResult	<= sQ_ALUResult;
  oAddResult	<= sQ_AddResult;
  oRtData	<= sQ_RtData;
  oRegDst	<= sQ_RegDst;
  oHalt		<= sQ_Halt;
  oJumpAddr	<= sQ_jumpAddr;
  oJumpRegAddr	<= sQ_jumpRegAddr;
  oJump		<= sQ_jump;
  oJumpReg	<= sQ_jumpReg;
  oJumpAndLink	<= sQ_jumpAndLink;
  oNextPC	<= sQ_nextPC;

  with iEn select sD_WBRegWrite <= iWBRegWrite when '1', sQ_WBRegWrite when others;
  with iEn select sD_WBMemtoReg <= iWBMemtoReg when '1', sQ_WBMemtoReg when others;
  with iEn select sD_MBranch <= iMBranch when '1', sQ_MBranch when others;
  with iEn select sD_MMemRead <= iMMemRead when '1', sQ_MMemRead when others;
  with iEn select sD_MMemWrite <= iMMemWrite when '1', sQ_MMemWrite when others;
  with iEn select sD_Zero <= iZero when '1', sQ_Zero when others;
--  with iEn select sD_ALUResult <= iALUResult when '1', sQ_ALUResult when others;
  with iEn select sD_AddResult <= iAddResult when '1', sQ_AddResult when others;
  with iEn select sD_RtData <= iRtData when '1', sQ_RtData when others;
  with iEn select sD_RegDst <= iRegDst when '1', sQ_RegDst when others;
  with iEn select sD_Halt <= iHalt when '1', sQ_Halt when others;

  with iEn select sD_jumpAddr <= jumpAddr when '1', sQ_jumpAddr when others;
  with iEn select sD_jumpRegAddr <= jumpRegAddr when '1', sQ_jumpRegAddr when others;
  with iEn select sD_jump <= jump when '1', sQ_jump when others;
  with iEn select sD_jumpReg <= jumpReg when '1', sQ_jumpReg when others;
  with iEn select sD_jumpAndLink <= jumpAndLink when '1', sQ_jumpAndLink when others;
  with iEn select sD_nextPC <= nextPC when '1', sQ_nextPC when others;

/*
  process (iEn, iClk)
  begin
    if(iEn = '0') then
	sD_WBRegWrite	<= sQ_WBRegWrite;
	sD_WBMemtoReg	<= sQ_WBMemtoReg;
	sD_MBranch	<= sQ_MBranch;
	sD_MMemRead	<= sQ_MMemRead;
	sD_MMemWrite	<= sQ_MMemWrite;
	sD_Zero		<= sQ_Zero;
	sD_ALUResult	<= sQ_ALUResult;
	sD_AddResult	<= sQ_AddResult;
	sD_RtData	<= sQ_RtData;
	sD_RegDst	<= sQ_RegDst;
    elsif(rising_edge(iClk)) then
	sD_WBRegWrite	<= iWBRegWrite;
	sD_WBMemtoReg	<= iWBMemtoReg;
	sD_MBranch	<= iMBranch;
	sD_MMemRead	<= iMMemRead;
	sD_MMemWrite	<= iMMemWrite;
	sD_Zero		<= iZero;
	sD_ALUResult	<= iALUResult;
	sD_AddResult	<= iAddResult;
	sD_RtData	<= iRtData;
	sD_RegDst	<= iRegDst;
    end if;
  end process;
*/

  process (iClk, iRst)
  begin
    if(iRst = '1') then
	sQ_WBRegWrite	<= '0';
	sQ_WBMemtoReg	<= '0';
	sQ_MBranch	<= '0';
	sQ_MMemRead	<= '0';
	sQ_MMemWrite	<= '0';
	sQ_Zero		<= '0';
	sQ_Halt		<= '0';
--	sQ_ALUResult	<= (others => '0');
	sQ_AddResult	<= (others => '0');
	sQ_RtData	<= (others => '0');
	sQ_RegDst	<= (others => '0');

	sQ_jump		<= '0';
	sQ_jumpReg	<= '0';
	sQ_jumpAndLink	<= '0';
	sQ_jumpAddr	<= (others => '0');
	sQ_jumpRegAddr	<= (others => '0');
	sQ_nextPC	<= (others => '0');
    elsif(rising_edge(iClk)) then
	sQ_WBRegWrite	<= sD_WBRegWrite;
	sQ_WBMemtoReg	<= sD_WBMemtoReg;
	sQ_MBranch	<= sD_MBranch;
	sQ_MMemRead	<= sD_MMemRead;
	sQ_MMemWrite	<= sD_MMemWrite;
	sQ_Zero		<= sD_Zero;
	sQ_Halt		<= sD_Halt;
	--sQ_ALUResult	<= sD_ALUResult;
	sQ_AddResult	<= sD_AddResult;
	sQ_RtData	<= sD_RtData;
	sQ_RegDst	<= sD_RegDst;

	sQ_jump		<= sD_jump;
	sQ_jumpReg	<= sD_jumpReg;
	sQ_jumpAndLink	<= sD_jumpAndLink;
	sQ_jumpAddr	<= sD_jumpAddr;
	sQ_jumpRegAddr	<= sD_jumpRegAddr;
	sQ_nextPC	<= sD_nextPC;
    end if;
  end process;
end mixed;
