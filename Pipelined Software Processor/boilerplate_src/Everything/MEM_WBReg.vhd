/*

Caleb Hemmestad

MEM/WB Register

*/

library IEEE;
use IEEE.std_logic_1164.all;

entity MEM_WBReg is
  port(
	iClk		: in std_logic;
	iRst		: in std_logic;
	iEn		: in std_logic;


	iWBRegWrite	: in std_logic;
	iWBMemtoReg	: in std_logic;
	iALUResult	: in std_logic_vector(31 downto 0);
	iMemData	: in std_logic_vector(31 downto 0);
	iRegDst		: in std_logic_vector(4 downto 0);
	iHalt		: in std_logic;

	oWBRegWrite	: out std_logic;
	oWBMemtoReg	: out std_logic;
	oALUResult	: out std_logic_vector(31 downto 0);
	oMemData	: out std_logic_vector(31 downto 0);
	oRegDst		: out std_logic_vector(4 downto 0);
	oHalt		: out std_logic
	);
end MEM_WBReg;

architecture mixed of MEM_WBReg is

signal sD_WBRegWrite	: std_logic;
signal sD_WBMemtoReg	: std_logic;
signal sD_Halt		: std_logic;
signal sD_ALUResult	: std_logic_vector(31 downto 0);
signal sD_MemData	: std_logic_vector(31 downto 0);
signal sD_RegDst	: std_logic_vector(4 downto 0);

signal sQ_WBRegWrite	: std_logic;
signal sQ_WBMemtoReg	: std_logic;
signal sQ_Halt		: std_logic;
signal sQ_ALUResult	: std_logic_vector(31 downto 0);
signal sQ_MemData	: std_logic_vector(31 downto 0);
signal sQ_RegDst	: std_logic_vector(4 downto 0);

begin 


  oWBRegWrite	<= sQ_WBRegWrite;
  oWBMemtoReg	<= sQ_WBMemtoReg;
  oHalt		<= sQ_Halt;
  oALUResult	<= sQ_ALUResult;
  oMemData	<= sQ_MemData;
  oRegDst	<= sQ_RegDst;

  with iEn select sD_WBRegWrite <= iWBRegWrite when '1', sQ_WBRegWrite when others;
  with iEn select sD_WBMemtoReg <= iWBMemtoReg when '1', sQ_WBMemtoReg when others;
  with iEn select sD_Halt <= iHalt when '1', sQ_Halt when others;
  with iEn select sD_ALUResult <= iALUResult when '1', sQ_ALUResult when others;
  with iEn select sD_MemData <= iMemData when '1', sQ_MemData when others;
  with iEn select sD_RegDst <= iRegDst when '1', sQ_RegDst when others;

/*
  process (iEn)
  begin
    if(iEn) then
	sD_WBRegWrite	<= iWBRegWrite;
	sD_WBMemtoReg	<= iWBMemtoReg;
	sD_ALUResult	<= iALUResult;
	sD_MemData	<= iMemData;
	sD_RegDst	<= iRegDst;
    else
	sD_WBRegWrite	<= sQ_WBRegWrite;
	sD_WBMemtoReg	<= sQ_WBMemtoReg;
	sD_ALUResult	<= sQ_ALUResult;
	sD_MemData	<= sQ_MemData;
	sD_RegDst	<= sQ_RegDst;
    end if;
  end process;
*/

  process (iClk, iRst)
  begin
    if(iRst = '1') then
	sQ_WBRegWrite	<= '0';
	sQ_WBMemtoReg	<= '0';
	sQ_Halt		<= '0';
	sQ_ALUResult	<= (others => '0');
	sQ_MemData	<= (others => '0');
	sQ_RegDst	<= (others => '0');
    elsif(rising_edge(iClk)) then
	sQ_WBRegWrite	<= sD_WBRegWrite;
	sQ_WBMemtoReg	<= sD_WBMemtoReg;
	sQ_Halt		<= sD_Halt;
	sQ_ALUResult	<= sD_ALUResult;
	sQ_MemData	<= sD_MemData;
	sQ_RegDst	<= sD_RegDst;
    end if;
  end process;
end mixed;
