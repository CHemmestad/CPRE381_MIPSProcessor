library IEEE;
use IEEE.std_logic_1164.all;

entity tb_control is
  generic(gCLK_HPER   : time := 50 ns);
end tb_control;

architecture behavior of tb_control is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component control
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
	ALUOp		:out std_logic_vector(3 downto 0)
	);
  end component;

  -- Temporary signals to connect to the dff component.
  signal s_clk : std_logic;
  signal s_opCode : std_logic_vector(5 downto 0);
  signal s_funct : std_logic_vector(5 downto 0);
  signal s_ALUOp : std_logic_vector(3 downto 0);
  signal s_regDst : std_logic;
  signal s_regWrite : std_logic;
  signal s_jump : std_logic;
  signal s_branch : std_logic;
  signal s_memRead : std_logic;
  signal s_memWrite : std_logic;
  signal s_memToReg : std_logic;
  signal s_ALUSrc : std_logic;

begin

  DUT: control 
  port map(
	clk		=> s_clk,
	opCode 		=> s_opCode,
	funct		=> s_funct,
	regDst		=> s_regDst,
	regWrite	=> s_regWrite,
	jump		=> s_jump,
	branch		=> s_branch,
	memRead		=> s_memRead,
	memWrite	=> s_memWrite,
	memToReg	=> s_memToReg,
	ALUSrc		=> s_ALUSrc,
	ALUOp		=> s_ALUOp
	);

  -- This process sets the clock value (low for gCLK_HPER, then high
  -- for gCLK_HPER). Absent a "wait" command, processes restart 
  -- at the beginning once they have reached the final statement.
  P_CLK: process
  begin
    s_clk <= '0';
    wait for gCLK_HPER;
    s_clk <= '1';
    wait for gCLK_HPER;
  end process;

  P_TB: process
  begin
    s_opCode <= "000000";
    s_funct <= "100010"; -- sub ALUCode exp = 0110
    wait for cCLK_PER;

    s_opCode <= "000000";
    s_funct <= "000000"; -- sll ALUCode exp = 1110
    wait for cCLK_PER;

    s_opCode <= "000000";
    s_funct <= "100100"; -- and ALUCode exp = 0000
    wait for cCLK_PER;

    s_opCode <= "100000"; -- Doesnt exist ALUCode exp = 0000
    wait for cCLK_PER;

    s_opCode <= "100011"; -- lw ALUCOde exp = 0010
    wait for cCLK_PER;

    s_opCode <= "001000"; -- addi ALUCOde exp = 0010
    wait for cCLK_PER;

    s_opCode <= "000011"; -- jal ALUCode exp = 0110
    wait for cCLK_PER;

    wait;
  end process;
  
end behavior;