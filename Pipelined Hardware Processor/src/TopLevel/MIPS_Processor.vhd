-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- MIPS_Processor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a skeleton of a MIPS_Processor  
-- implementation.

-- 01/29/2019 by H3::Design created.
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.MIPS_types.all;

entity MIPS_Processor is
  generic(N : integer := DATA_WIDTH);
  port(iCLK            : in std_logic;
       iRST            : in std_logic;
       iInstLd         : in std_logic;
       iInstAddr       : in std_logic_vector(N-1 downto 0);
       iInstExt        : in std_logic_vector(N-1 downto 0);
       oALUOut         : out std_logic_vector(N-1 downto 0)); -- TODO: Hook this up to the output of the ALU. It is important for synthesis that you have this output that can effectively be impacted by all other components so they are not optimized away.

end  MIPS_Processor;


architecture structure of MIPS_Processor is

  -- Required data memory signals
  signal s_DMemWr       : std_logic; -- TODO: use this signal as the final active high data memory write enable signal
  signal s_DMemAddr     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory address input
  signal s_DMemData     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input
  signal s_DMemOut      : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the data memory output
 
  -- Required register file signals 
  signal s_RegWr        : std_logic; -- TODO: use this signal as the final active high write enable input to the register file
  signal s_RegWrAddr    : std_logic_vector(4 downto 0); -- TODO: use this signal as the final destination register address input
  signal s_RegWrData    : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input

  -- Required instruction memory signals
  signal s_IMemAddr     : std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
  signal s_NextInstAddr : std_logic_vector(N-1 downto 0); -- TODO: use this signal as your intended final instruction memory address input.
  signal s_Inst         : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the instruction signal 

  -- Required halt signal -- for simulation
  signal s_Halt         : std_logic;  -- TODO: this signal indicates to the simulation that intended program execution has completed. (Opcode: 01 0100)

  -- Required overflow signal -- for overflow exception detection
  signal s_Ovfl         : std_logic;  -- TODO: this signal indicates an overflow exception would have been initiated

  component mem is
    generic(ADDR_WIDTH : integer;
            DATA_WIDTH : integer);
    port(
          clk          : in std_logic;
          addr         : in std_logic_vector((ADDR_WIDTH-1) downto 0);
          data         : in std_logic_vector((DATA_WIDTH-1) downto 0);
          we           : in std_logic := '1';
          q            : out std_logic_vector((DATA_WIDTH -1) downto 0));
    end component;

  -- TODO: You may add any additional signals or components your implementation 
  --       requires below this comment

component control is
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
  	overflowr   	:out std_logic;
	overflowi  	:out std_logic;
	sign		:out std_logic;
	jumpReg		:out std_logic;
	jumpAndLink	:out std_logic
  


	);
end component;

component mux2t1_N is
  generic(N : integer); -- Generic of type integer for input/output data width. Default value is 32.
  port(
	i_S          : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0)
	);
end component;

component mux3t1_N is
  generic(N : integer); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_S          : in std_logic_vector(1 downto 0);
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       i_D2         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0)
	);
end component;

component ALU is
  port(
  	iA              :in std_logic_vector(31 downto 0);
	iB		:in std_logic_vector(31 downto 0);
	iImmediate	:in std_logic_vector(31 downto 0);
	iALUOp		:in std_logic_vector(3 downto 0);
	iALUsrc		:in std_logic;
 	ioverflowr   	:in std_logic;
	ioverflowi  	:in std_logic;
	iShamt		:in std_logic_vector(4 downto 0);

	outF		:out std_logic_vector(31 downto 0);
	oCarryout	:out std_logic;
	oOverflow	:out std_logic;
	oZero		:out std_logic
	);
end component;

component bitExtender is
  port(
	i_Data			:in std_logic_vector(15 downto 0);
	i_Sign			:in std_logic;
	o_Ext			:out std_logic_vector(31 downto 0)
	);
end component;

component register_file is
  port(
	i_Clk			:in std_logic;
	i_En			:in std_logic;
	i_Rst			:in std_logic;
	i_Rs			:in std_logic_vector(4 downto 0);
	i_Rt			:in std_logic_vector(4 downto 0);
	i_Rd			:in std_logic_vector(4 downto 0);
	i_RdData		:in std_logic_vector(31 downto 0);
	o_ReadA			:out std_logic_vector(31 downto 0);
	o_ReadB			:out std_logic_vector(31 downto 0)
	);
end component;

component andg2 is
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end component;

component addSub_N is
  generic(N : integer := 32); 
  port(i_Ain			:in std_logic_vector(N-1 downto 0);
	i_Bin			:in std_logic_vector(N-1 downto 0);
	i_nAdd_Sub		:in std_logic;
	o_Sum			:out std_logic_vector(N-1 downto 0);
	o_Cout			:out std_logic);
end component;

component dffg is
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic;     -- Data value input
       o_Q          : out std_logic);   -- Data value output
end component;


component dffg1 is
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic;     -- Data value input
       o_Q          : out std_logic);   -- Data value output
end component;

component HazardDetection is
  port(
    IDEX_MemRead    : in std_logic;
    IDEX_RegRt : in std_logic_vector(4 downto 0);
    IFID_RegRs : in std_logic_vector(4 downto 0);
    IFID_RegRt : in std_logic_vector(4 downto 0);
    PCWr         : out std_logic;
    IFID_Wr     : out std_logic;
    CtrlMuxSel  : out std_logic);
end component;

component ForwardingUnit is
  port(
	EXRegRs		:in std_logic_vector(4 downto 0);
	EXRegRt		:in std_logic_vector(4 downto 0);
	MEMRegRd	:in std_logic_vector(4 downto 0);
	WBRegRd		:in std_logic_vector(4 downto 0);
	MEMRegWr	:in std_logic;
	WBRegWr		:in std_logic;
	ForwardA	:out std_logic_vector(1 downto 0);
	ForwardB	:out std_logic_vector(1 downto 0)
	);
end component;

component barrelShifter is
  port(
	shiftDirection   	 : in std_logic;    			 -- if shiftDirection is 0: shift left, if shiftDirection is 1: shift right
	shiftType   		 : in std_logic;			 -- if shiftType is 0: type is logical, if shift type is 1: type is arithmetic
	dataInput    		 : in std_logic_vector(31 downto 0);
	shamt   		 : in std_logic_vector(4 downto 0);
	dataOutput   		 : out std_logic_vector(31 downto 0));
end component;

Component IF_IDReg is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(
	iClk		:in std_logic;
	iPCSrc		:in std_logic_vector(n-1 downto 0);
	inInstrNext 	:in std_logic_vector(n-1 downto 0);
	iRst		:in std_logic;
	iEn		:in std_logic;
	oFetchedInstr	:out std_logic_vector(n-1 downto 0);
	outInstrNext	:out std_logic_vector(n-1 downto 0)
	);
end component;

component ID_EXReg is
  generic(N : integer := 32;
	  D : integer := 5); -- Generic of type integer for input/output data width. Default value is 32.
  port(
	iClk		:in std_logic;
	ireset		: in std_logic;
	iEn		: in std_logic;
	RegNumRs	: in std_logic_vector(4 downto 0);
	RegNumRt	: in std_logic_vector(4 downto 0);
	RegNumRd	: in std_logic_vector(4 downto 0);
	RegRs		: in std_logic_vector(n-1 downto 0);
	RegRt		: in std_logic_vector(n-1 downto 0);
	RegRd		: in std_logic_vector(n-1 downto 0);
	RegDst		: in std_logic;
	RegWrite	: in std_logic;
	MemWrite	: in std_logic;
	MemtoReg	: in std_logic;
	ALUCtrl		: in std_logic_vector(3 downto 0);
	ALUSrc		: in std_logic;
	SignExtn	: in std_logic_vector(n-1 downto 0);
	nextPC		: in std_logic_vector(n-1 downto 0);
	branch		: in std_logic;
	iHalt		: in std_logic;

	overflowr	: in std_logic;
	overflowi 	: in std_logic;
	jump		: in std_logic;
	jumpReg		: in std_logic;
	jumpAndLink	: in std_logic;
	jumpAddr	: in std_logic_vector(n-1 downto 0);
	
	
	oRegWrite	: out std_logic;
	oMemWrite	: out std_logic;
	oMemtoReg	: out std_logic;
	oRegDst		: out std_logic;
	oALUCtrl	: out std_logic_vector(3 downto 0);
	oALUSrc		: out std_logic;
	oRegRd		: out std_logic_vector(n-1 downto 0);
	oRegRs		: out std_logic_vector(n-1 downto 0);
	oRegRt		: out std_logic_vector(n-1 downto 0);
	oSignExtn	: out std_logic_vector(n-1 downto 0);
	oRegNumRs	: out std_logic_vector(4 downto 0);
	oRegNumRt	: out std_logic_vector(4 downto 0);
	oRegNumRd	: out std_logic_vector(4 downto 0);
	oNextPC		: out std_logic_vector(n-1 downto 0);
	oBranch		: out std_logic;
	oHalt		: out std_logic;

	oOverflowr	: out std_logic;
	oOverflowi 	: out std_logic;
	oJump		: out std_logic;
	oJumpReg	: out std_logic;
	oJumpAndLink	: out std_logic;
	oJumpAddr	: out std_logic_vector(n-1 downto 0)
	);
end component;

component EX_MEMReg is
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
end component;

component MEM_WBReg is
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
	nextPC		: in std_logic_vector(31 downto 0);
	jumpAndLink	: in std_logic;

	oWBRegWrite	: out std_logic;
	oWBMemtoReg	: out std_logic;
	oALUResult	: out std_logic_vector(31 downto 0);
	oMemData	: out std_logic_vector(31 downto 0);
	oRegDst		: out std_logic_vector(4 downto 0);
	oHalt		: out std_logic;
	oNextPC		: out std_logic_vector(31 downto 0);
	oJumpAndLink	: out std_logic
	);
end component;

signal s_regDst		: std_logic;
signal s_jump		: std_logic;
signal s_branch		: std_logic;
signal s_memToReg	: std_logic;
signal s_ALUSrc		: std_logic;
signal s_ALUOp		: std_logic_vector(3 downto 0);
signal s_ALUOut		: std_logic_vector(31 downto 0);
signal s_overflowr : std_logic;
signal s_overflowi : std_logic;
signal s_zero		: std_logic;
signal s_signExtendOutput:std_logic_vector(31 downto 0);
signal s_regDataA	: std_logic_vector(31 downto 0);
signal s_regDataB	: std_logic_vector(31 downto 0);
signal s_andgOut	: std_logic;
signal s_sign		: std_logic;
signal s_add1Out	: std_logic_vector(31 downto 0);
signal s_add2Out	: std_logic_vector(31 downto 0);
signal s_mux3Out	: std_logic_vector(31 downto 0);
signal s_shiftLeftOut	: std_logic_vector(31 downto 0);
signal s_preShift	: std_logic_vector(31 downto 0) := X"00000000";
signal s_jumpAddr	: std_logic_vector(31 downto 0);
signal s_NextAddr	: std_logic_vector(31 downto 0);
signal s_jumpRegSel	: std_logic;
--signal s_jumpRegAddr	: std_logic_vector(31 downto 0);
signal s_jumpRegOut	: std_logic_vector(31 downto 0);
signal s_memToRegOut	: std_logic_vector(31 downto 0);
signal s_shiftedAddr	: std_logic_vector(31 downto 0);
signal s_jumpAndLink	: std_logic;
signal s_RegDstOut	: std_logic_vector(4 downto 0);

signal s_IDInstru	: std_logic_vector(31 downto 0);
signal s_IDNextInstru	: std_logic_vector(31 downto 0);
signal s_IDRegWr	: std_logic;
signal s_IDDMemWr	: std_logic;
signal s_IDHalt		: std_logic;

signal s_EXRegWrite		: std_logic;
signal s_EXMemWrite		: std_logic;
signal s_EXMemtoReg		: std_logic;
signal s_EXRegDst		: std_logic;
signal s_EXALUCtrl	: std_logic_vector(3 downto 0);
signal s_EXALUSrc		: std_logic;
signal s_EXRegRd	: std_logic_vector(31 downto 0);
signal s_EXRegRs	: std_logic_vector(31 downto 0);
signal s_EXRegRt	: std_logic_vector(31 downto 0);
signal s_EXSignExtn	: std_logic_vector(31 downto 0);
signal s_EXRegNumRs	: std_logic_vector(4 downto 0);
signal s_EXRegNumRt	: std_logic_vector(4 downto 0);
signal s_EXRegNumRd	: std_logic_vector(4 downto 0);
signal s_EXRegNum	: std_logic_vector(4 downto 0);
signal s_EXNextPC	: std_logic_vector(31 downto 0);
signal s_EXBranch		: std_logic;
signal s_EXHalt		: std_logic;
signal s_EXJump		: std_logic;
signal s_EXOverflowr		: std_logic;
signal s_EXOverflowi		: std_logic;
signal s_EXJumpRegSel		: std_logic;
signal s_EXJumpAndLink		: std_logic;
signal s_EXJumpAddr	: std_logic_vector(31 downto 0);

signal s_MEMRegWrite		: std_logic;
signal s_MEMMemtoReg		: std_logic;
signal s_MEMBranch		: std_logic;
signal s_MEMMemRead		: std_logic;
signal s_MEMZero		: std_logic;
signal s_MEMAddResult		: std_logic_vector(31 downto 0);
signal s_MEMRegDst		: std_logic_vector(4 downto 0);
signal s_MEMHalt		: std_logic;
signal s_MEMJump		: std_logic;
signal s_MEMJumpReg		: std_logic;
signal s_MEMJumpAndLink		: std_logic;
signal s_MEMJumpAddr		: std_logic_vector(31 downto 0);
signal s_MEMJumpRegAddr		: std_logic_vector(31 downto 0);
signal s_MEMNextPC		: std_logic_vector(31 downto 0);

signal s_WBMemtoReg		: std_logic;
signal s_WBJumpAndLink		: std_logic;
signal s_WBALUResult		: std_logic_vector(31 downto 0);
signal s_WBMemData		: std_logic_vector(31 downto 0);
signal s_WBNextPC		: std_logic_vector(31 downto 0);

signal s_IDEX_MemRead		: std_logic;
signal s_PCWr			: std_logic;
signal s_IFID_Wr		: std_logic;
signal s_CtrlMuxSel		: std_logic;

signal s_ControlSig		: std_logic_vector(16 downto 0);
signal s_ControlSigOut		: std_logic_vector(16 downto 0);

signal s_ForwardA		: std_logic_vector(1 downto 0);
signal s_ForwardB		: std_logic_vector(1 downto 0);
signal s_ForwardAOut		: std_logic_vector(31 downto 0);
signal s_ForwardBOut		: std_logic_vector(31 downto 0);



begin

  -- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
      iInstAddr when others;


  IMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_IMemAddr(11 downto 2),
             data => iInstExt,
             we   => iInstLd,
             q    => s_Inst);

 -- s_DMemAddr 	<= s_ALUOut;
 -- s_DMemData	<= s_regDataB;
  
  DMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_DMemAddr(11 downto 2),
             data => s_DMemData,
             we   => s_DMemWr,
             q    => s_DMemOut);

  -- TODO: Ensure that s_Halt is connected to an output control signal produced from decoding the Halt instruction (Opcode: 01 0100)
  -- TODO: Ensure that s_Ovfl is connected to the overflow output of your ALU

  -- TODO: Implement the rest of your processor below this comment!


  dffPC: for i in 0 to 31 generate
  PC: dffg port map(
	i_CLK => iCLK,
	i_RST => iRST,
	i_WE  => s_PCWr,
	i_D   => s_jumpRegOut(i),
	o_Q   => s_NextInstAddr(i)
  	);
  end generate;


 /*
  PC2: dffg1 port map(
	i_CLK => iCLK,
	i_RST => iRST,
	i_WE  => '1',
	i_D   => s_jumpRegOut(22),
	o_Q   => s_NextInstAddr(22)
  	);
 

  dffPC2: for i in 23 to 31 generate
  PC3: dffg port map(
	i_CLK => iCLK,
	i_RST => iRST,
	i_WE  => '1',
	i_D   => s_jumpRegOut(i),
	o_Q   => s_NextInstAddr(i)
  	);
  end generate;
*/

HAZARD: HazardDetection
  port map(
    	IDEX_MemRead	=> s_EXMemtoReg,
    	IDEX_RegRt 	=> s_EXRegNumRt,
    	IFID_RegRs 	=> s_IDInstru(25 downto 21),
    	IFID_RegRt 	=> s_IDInstru(20 downto 16),
    	PCWr		=> s_PCWr,
    	IFID_Wr    	=> s_IFID_Wr,
    	CtrlMuxSel	=> s_CtrlMuxSel
	);

IFID: IF_IDReg
  port map(
	iClk		=> iCLK,
	iPCSrc		=> s_add1Out,
	inInstrNext 	=> s_Inst,
	iRst		=> iRST or s_andgOut  or s_MEMJump or s_MEMJumpAndLink, --flush
	iEn		=> s_IFID_Wr,	 --stall

	oFetchedInstr	=> s_IDInstru,
	outInstrNext	=> s_IDNextInstru
	);

IDEX: ID_EXReg
  port map(
	iClk		=> iCLK,
	ireset		=> iRST or s_andgOut  or s_MEMJump or s_MEMJumpAndLink,
	iEn		=> '1',
	RegNumRs	=> s_IDInstru(25 downto 21),
	RegNumRt	=> s_IDInstru(20 downto 16),
	RegNumRd	=> s_IDInstru(15 downto 11),
	RegRs		=> s_regDataA,
	RegRt		=> s_regDataB,
	RegRd		=> X"00000000",
	RegDst		=> s_regDst,
	RegWrite	=> s_IDRegWr,
	MemWrite	=> s_IDDMemWr,
	MemtoReg	=> s_memToReg,
	ALUCtrl		=> s_ALUOp,
	ALUSrc		=> s_ALUSrc,
	SignExtn	=> s_signExtendOutput,
	nextPC		=> s_IDNextInstru,
	branch		=> s_branch,
	iHalt		=> s_IDHalt,

	overflowr	=> s_overflowr,
	overflowi 	=> s_overflowi,
	jump		=> s_jump,
	jumpReg		=> s_jumpRegSel,
	jumpAndLink	=> s_jumpAndLink,
	jumpAddr	=> s_jumpAddr,
	
	
	oRegWrite	=> s_EXRegWrite,
	oMemWrite	=> s_EXMemWrite,
	oMemtoReg	=> s_EXMemtoReg,
	oRegDst		=> s_EXRegDst,
	oALUCtrl	=> s_EXALUCtrl,
	oALUSrc		=> s_EXALUSrc,
	oRegRd		=> s_EXRegRd,
	oRegRs		=> s_EXRegRs,
	oRegRt		=> s_EXRegRt,
	oSignExtn	=> s_EXSignExtn,
	oRegNumRs	=> s_EXRegNumRs,
	oRegNumRt	=> s_EXRegNumRt,
	oRegNumRd	=> s_EXRegNumRd,
	oNextPC		=> s_EXNextPC,
	oBranch		=> s_EXBranch,
	oHalt		=> s_EXHalt,

	oOverflowr	=> s_EXOverflowr,
	oOverflowi 	=> s_EXOverflowi,
	oJump		=> s_EXJump,
	oJumpReg	=> s_EXJumpRegSel,
	oJumpAndLink	=> s_EXJumpAndLink,
	oJumpAddr	=> s_EXJumpAddr
	);

EXMEM: EX_MEMReg
  port map(
	iClk		=> iCLK,
	iRst		=> iRST or s_andgOut or s_MEMJump or s_MEMJumpAndLink,
	iEn		=> '1',

	iWBRegWrite	=> s_EXRegWrite,
	iWBMemtoReg	=> s_EXMemtoReg,
	iMBranch	=> s_EXBranch,
	iMMemRead	=> '1',
	iMMemWrite	=> s_EXMemWrite,
	iZero		=> s_zero,
	iALUResult	=> s_ALUOut,
	iAddResult	=> s_add2Out,
	iRtData		=> s_ForwardBOut,
	iRegDst		=> s_EXRegNum,
	iHalt		=> s_EXHalt,

	jump		=> s_EXJump,
	jumpReg		=> s_EXJumpRegSel,
	jumpAndLink	=> s_EXJumpAndLink,
	jumpAddr	=> s_EXJumpAddr,
	jumpRegAddr	=> s_EXRegRs,
	nextPC		=> s_EXNextPC,



	oWBRegWrite	=> s_MEMRegWrite,
	oWBMemtoReg	=> s_MEMMemtoReg,
	oMBranch	=> s_MEMBranch,
	oMMemRead	=> s_MEMMemRead,
	oMMemWrite	=> s_DMemWr,
	oZero		=> s_MEMZero,
	oALUResult	=> s_DMemAddr,
	oAddResult	=> s_MEMAddResult,
	oRtData		=> s_DMemData,
	oRegDst		=> s_MEMRegDst,
	oHalt		=> s_MEMHalt,

	oJump		=> s_MEMJump,
	oJumpReg	=> s_MEMJumpReg,
	oJumpAndLink	=> s_MEMJumpAndLink,
	oJumpAddr	=> s_MEMJumpAddr,
	oJumpRegAddr	=> s_MEMJumpRegAddr,
	oNextPC		=> s_MEMNextPC
	);

MEMWB: MEM_WBReg
  port map(
	iClk		=> iCLK,
	iRst		=> iRST,
	iEn		=> '1',


	iWBRegWrite	=> s_MEMRegWrite,
	iWBMemtoReg	=> s_MEMMemtoReg,
	iALUResult	=> s_DMemAddr,
	iMemData	=> s_DMemOut,
	iRegDst		=> s_MEMRegDst,
	iHalt		=> s_MEMHalt,
	nextPC		=> s_MEMNextPC,
	jumpAndLink	=> s_MEMJumpAndLink,

	oWBRegWrite	=> s_RegWr,
	oWBMemtoReg	=> s_WBMemtoReg,
	oALUResult	=> s_WBALUResult,
	oMemData	=> s_WBMemData,
	oRegDst		=> s_RegWrAddr,
	oHalt		=> s_Halt,
	oNextPC		=> s_WBNextPC,
	oJumpAndLink	=> s_WBJumpAndLink
	);

  ForwardingUnitControl: ForwardingUnit
  port map(
	EXRegRs		=> s_EXRegNumRs,
	EXRegRt		=> s_EXRegNumRt,
	MEMRegRd	=> s_MEMRegDst,
	WBRegRd		=> s_RegWrAddr,
	MEMRegWr	=> s_MEMRegWrite,
	WBRegWr		=> s_RegWr,
	ForwardA	=> s_ForwardA,
	ForwardB	=> s_ForwardB
	);

  CON: control
  port map(
	clk		=> iCLK,
	opCode		=> s_IDInstru(31 downto 26),
	funct		=> s_IDInstru(5 downto 0),
	regDst		=> s_ControlSig(0),
	regWrite	=> s_ControlSig(1), -- requirement
	jump		=> s_ControlSig(2),
	branch		=> s_ControlSig(3),
	memWrite	=> s_ControlSig(4), -- requirement
	memToReg	=> s_ControlSig(5),
	ALUSrc		=> s_ControlSig(6),
  
	halt		=> s_ControlSig(7), -- requirement
	ALUOp		=> s_ControlSig(11 downto 8),

  	overflowr	=> s_ControlSig(12),
	overflowi 	=> s_ControlSig(13),
	sign		=> s_ControlSig(14),
	jumpReg		=> s_ControlSig(15),
	jumpAndLink	=> s_ControlSig(16)
	);

  RegMux: mux2t1_N -- Dont forget my mux is backwards cause why not so when 1 output is d0 and when 0 output is d1
  generic map(N => 5)
  port map(
	i_S          => s_EXRegDst,
       i_D0          => s_EXRegNumRd,
       i_D1          => s_EXRegNumRt,
       o_O           => s_RegDstOut
	);

  MemOutMux: mux2t1_N -- Dont forget my mux is backwards cause why not so when 1 output is d0 and when 0 output is d1
  generic map(N => 32)
  port map(
	i_S          => s_WBMemtoReg,
       i_D0          => s_WBMemData,
       i_D1          => s_WBALUResult,
       o_O           => s_memToRegOut
	);

  ControlMux: mux2t1_N -- Dont forget my mux is backwards cause why not so when 1 output is d0 and when 0 output is d1
  generic map(N => 17)
  port map(
	i_S          => s_CtrlMuxSel,
       i_D0          => "00000000000000000",
       i_D1          => s_ControlSig,
       o_O           => s_ControlSigOut
	);

	s_regDst	<= s_ControlSigOut(0);
	s_IDRegWr	<= s_ControlSigOut(1); -- requirement
	s_jump		<= s_ControlSigOut(2);
	s_branch	<= s_ControlSigOut(3);
	s_IDDMemWr	<= s_ControlSigOut(4); -- requirement
	s_memToReg	<= s_ControlSigOut(5);
	s_ALUSrc	<= s_ControlSigOut(6);
  
	s_IDHalt	<= s_ControlSigOut(7); -- requirement
	s_ALUOp		<= s_ControlSigOut(11 downto 8);

  	s_overflowr	<= s_ControlSigOut(12);
	s_overflowi 	<= s_ControlSigOut(13);
	s_sign		<= s_ControlSigOut(14);
	s_jumpRegSel	<= s_ControlSigOut(15);
	s_jumpAndLink	<= s_ControlSigOut(16);


  ForwardAMux: mux3t1_N
  generic map(N => 32) -- Generic of type integer for input/output data width. Default value is 32.
  port map(i_S          	=> s_ForwardA,
       i_D0         	=> s_EXRegRs,
       i_D1         	=> s_RegWrData,
       i_D2         	=> s_DMemAddr,
       o_O          	=> s_ForwardAOut
	);

  ForwardBMux: mux3t1_N
  generic map(N => 32) -- Generic of type integer for input/output data width. Default value is 32.
  port map(i_S		=> s_ForwardB,
       i_D0         	=> s_EXRegRt,
       i_D1         	=> s_RegWrData,
       i_D2         	=> s_DMemAddr,
       o_O          	=> s_ForwardBOut
	);

  ALU1: ALU
  port map(
        iA              => s_ForwardAOut,
	iB		=> s_ForwardBOut,
	iImmediate	=> s_EXSignExtn,
	iALUOp		=> s_EXALUCtrl,
	iALUsrc		=> s_EXALUSrc,

 	ioverflowr 	=> s_EXOverflowr,
	ioverflowi 	=> s_EXOverflowi,

	iShamt		=> s_EXSignExtn(10 downto 6),

	outF		=> s_ALUOut,
	oOverflow	=> s_Ovfl, -- requirement
	oZero		=> s_zero
	);

  --s_jumpRegAddr <= s_regDataA;

  SignExtend: bitExtender
  port map(
	i_Data		=> s_IDInstru(15 downto 0),
	i_Sign		=> s_sign, -- maybe needs to be changed I dont really know, 1 for arithmetic
	o_Ext		=> s_signExtendOutput
	);

  RegiserFile: register_file
  port map(
	i_Clk		=> iClk,
	i_En		=> s_RegWr,
	i_Rst		=> iRST,
	i_Rs		=> s_IDInstru(25 downto 21),
	i_Rt		=> s_IDInstru(20 downto 16),
	i_Rd		=> s_RegWrAddr,
	i_RdData	=> s_RegWrData,
	o_ReadA		=> s_regDataA,
	o_ReadB		=> s_regDataB
	);

  g_AND: andg2
  port map(
	i_A         	=> s_MEMZero,
       i_B          	=> s_MEMBranch,
       o_F          	=> s_andgOut
	);

  MUX3: mux2t1_N -- Dont forget my mux is backwards cause why not so when 1 output is d0 and when 0 output is d1
  generic map(N => 32)
  port map(
	i_S          => s_andgOut,
       i_D0          => s_NextAddr,
       i_D1          => s_add1out,
       o_O           => s_mux3Out
	);

  MUX4: mux2t1_N -- Dont forget my mux is backwards cause why not so when 1 output is d0 and when 0 output is d1
  generic map(N => 32)
  port map(
	i_S          => s_MEMJump,
       i_D0          => s_MEMJumpAddr,
       i_D1          => s_MEMAddResult,
       o_O           => s_NextAddr
	);

  JUMPREG: mux2t1_N -- Dont forget my mux is backwards cause why not so when 1 output is d0 and when 0 output is d1
  generic map(N => 32)
  port map(
	i_S          => s_MEMJumpReg,
       i_D0          => s_MEMJumpRegAddr,
       i_D1          => s_mux3Out,
       o_O           => s_jumpRegOut
	);

  JUMPLINK: mux2t1_N -- Dont forget my mux is backwards cause why not so when 1 output is d0 and when 0 output is d1
  generic map(N => 32)
  port map(
	i_S          => s_WBJumpAndLink,
  i_D0 => s_WBNextPC(31 downto 28) & s_WBNextPC(27 downto 2) & "00",
    --i_D0  =>  "0000" & s_add1Out(27 downto 2) & "00",
     --  i_D0          => s_NextAddr,
       i_D1          => s_memToRegOut,
       o_O           => s_RegWrData
	);

  JUMPLINKWR: mux2t1_N -- Dont forget my mux is backwards cause why not so when 1 output is d0 and when 0 output is d1
  generic map(N => 5)
  port map(
	i_S          => s_EXJumpAndLink,
       i_D0          => "11111",
       i_D1          => s_RegDstOut,
       o_O           => s_EXRegNum
	);
  
  ADDER1: addSub_N
  port map(
	i_Ain		=> s_NextInstAddr,
	i_Bin		=> X"00000004",
	i_nAdd_Sub	=> '0',
	o_Sum		=> s_add1Out
	);

  ADDER2: addSub_N
  port map(
	i_Ain		=> s_EXNextPC,
	i_Bin		=> s_shiftLeftOut,
	i_nAdd_Sub	=> '0',
	o_Sum		=> s_add2Out
	);

  SHIFTLEFT2: barrelShifter
  port map(
	shiftDirection	=> '0',
	shiftType   	=> '0',
	dataInput    	=> s_EXSignExtn,
	shamt   	=> "00010",
	dataOutput   	=> s_shiftLeftOut
	);
  
  --s_preShift(25 downto 0) <= s_IDInstru(25 downto 0);
  s_preShift(25 downto 0) <= s_IDInstru(25 downto 0);
  s_preShift(31 downto 26) <= (others => '0');
  SHIFTLEFT1: barrelShifter
  port map(
	shiftDirection	=> '0',
	shiftType   	=> '0',
	dataInput    	=> s_preShift,
	shamt   	=> "00010",
	dataOutput   	=> s_shiftedAddr
	);
  --s_jumpAddr(31 downto 28) <= s_IDNextInstru(31 downto 28);
  s_jumpAddr <= s_IDNextInstru(31 downto 28) & s_shiftedAddr(27 downto 0);

  oALUOut 	<= s_ALUOut;

end structure;

