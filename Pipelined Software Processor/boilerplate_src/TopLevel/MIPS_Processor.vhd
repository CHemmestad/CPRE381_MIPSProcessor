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
	ALUOp		:out std_logic_vector(3 downto 0)
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

component ALU is
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

component barrelShifter is
  port(
	shiftDirection   	 : in std_logic;    			 -- if shiftDirection is 0: shift left, if shiftDirection is 1: shift right
	shiftType   		 : in std_logic;			 -- if shiftType is 0: type is logical, if shift type is 1: type is arithmetic
	dataInput    		 : in std_logic_vector(31 downto 0);
	shamt   		 : in std_logic_vector(4 downto 0);
	dataOutput   		 : out std_logic_vector(31 downto 0));
end component;

signal s_regDst		: std_logic;
signal s_jump		: std_logic;
signal s_branch		: std_logic;
signal s_memToReg	: std_logic;
signal s_ALUSrc		: std_logic;
signal s_ALUOp		: std_logic_vector(3 downto 0);
signal s_ALUOut		: std_logic_vector(31 downto 0);
signal s_zero		: std_logic;
signal s_signExtendOutput:std_logic_vector(31 downto 0);
signal s_regDataA	: std_logic_vector(31 downto 0);
signal s_regDataB	: std_logic_vector(31 downto 0);
signal s_andgOut	: std_logic;
signal s_add1Out	: std_logic_vector(31 downto 0);
signal s_add2Out	: std_logic_vector(31 downto 0);
signal s_mux3Out	: std_logic_vector(31 downto 0);
signal s_shiftLeftOut	: std_logic_vector(31 downto 0);
signal s_preShift	: std_logic_vector(31 downto 0) := X"00000000";
signal s_jumpAddr	: std_logic_vector(31 downto 0);

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

  s_DMemAddr 	<= s_ALUOut;
  s_DMemData	<= s_regDataB;
  
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
  CON: control
  port map(
	clk		=> iCLK,
	opCode		=> s_Inst(31 downto 26),
	funct		=> s_Inst(5 downto 0),
	regDst		=> s_regDst,
	regWrite	=> s_RegWr, -- requirement
	jump		=> s_jump,
	branch		=> s_branch,
	memWrite	=> s_DMemWr, -- requirement
	memToReg	=> s_memToReg,
	ALUSrc		=> s_ALUSrc,
	halt		=> s_Halt, -- requirement
	ALUOp		=> s_ALUOp
	);

  RegMux: mux2t1_N -- Dont forget my mux is backwards cause why not so when 1 output is d0 and when 0 output is d1
  generic map(N => 5)
  port map(
	i_S          => s_regDst,
       i_D0          => s_Inst(15 downto 11),
       i_D1          => s_Inst(20 downto 16),
       o_O           => s_RegWrAddr
	);

  MemOutMux: mux2t1_N -- Dont forget my mux is backwards cause why not so when 1 output is d0 and when 0 output is d1
  generic map(N => 32)
  port map(
	i_S          => s_memToReg,
       i_D0          => s_DMemOut,
       i_D1          => s_ALUOut,
       o_O           => s_RegWrData
	);

  ALU1: ALU
  port map(
        iA              => s_regDataA,
	iB		=> s_regDataB,
	iImmediate	=> s_signExtendOutput,
	iALUOp		=> s_ALUOp,
	iALUsrc		=> s_ALUSrc,
	iShamt		=> s_Inst(15 downto 11),
	outF		=> s_ALUOut,
	oOverflow	=> s_Ovfl, -- requirement
	oZero		=> s_zero
	);

  SignExtend: bitExtender
  port map(
	i_Data		=> s_Inst(15 downto 0),
	i_Sign		=> '1', -- maybe needs to be changed I dont really know, 1 for arithmetic
	o_Ext		=> s_signExtendOutput
	);

  RegiserFile: register_file
  port map(
	i_Clk		=> iClk,
	i_En		=> s_RegWr,
	i_Rst		=> '0',
	i_Rs		=> s_Inst(25 downto 21),
	i_Rt		=> s_Inst(20 downto 16),
	i_Rd		=> s_RegWrAddr,
	i_RdData	=> s_RegWrData,
	o_ReadA		=> s_regDataA,
	o_ReadB		=> s_regDataB
	);

  g_AND: andg2
  port map(
	i_A         	=> s_zero,
       i_B          	=> s_branch,
       o_F          	=> s_andgOut
	);

  MUX3: mux2t1_N -- Dont forget my mux is backwards cause why not so when 1 output is d0 and when 0 output is d1
  generic map(N => 32)
  port map(
	i_S          => s_andgOut,
       i_D0          => s_add2Out,
       i_D1          => s_add1Out,
       o_O           => s_mux3Out
	);

  MUX4: mux2t1_N -- Dont forget my mux is backwards cause why not so when 1 output is d0 and when 0 output is d1
  generic map(N => 32)
  port map(
	i_S          => s_jump,
       i_D0          => s_jumpAddr,
       i_D1          => s_mux3Out,
       o_O           => s_NextInstAddr
	);
  
  ADDER1: addSub_N
  port map(
	i_Ain		=> s_IMemAddr(11 downto 2),
	i_Bin		=> X"00000004",
	i_nAdd_Sub	=> '0',
	o_Sum		=> s_add1Out
	);

  ADDER2: addSub_N
  port map(
	i_Ain		=> s_add1Out,
	i_Bin		=> s_shiftLeftOut,
	i_nAdd_Sub	=> '0',
	o_Sum		=> s_mux3Out
	);

  SHIFTLEFT2: barrelShifter
  port map(
	shiftDirection	=> '0',
	shiftType   	=> '0',
	dataInput    	=> s_signExtendOutput,
	shamt   	=> "00100",
	dataOutput   	=> s_shiftLeftOut
	);
  
  s_preShift(25 downto 0) <= s_Inst(25 downto 0);
  SHIFTLEFT1: barrelShifter
  port map(
	shiftDirection	=> '0',
	shiftType   	=> '0',
	dataInput    	=> s_preShift,
	shamt   	=> "00100",
	dataOutput   	=> s_jumpAddr
	);
  s_jumpAddr(31 downto 28) <= s_add1Out(31 downto 28);

  oALUOut 	<= s_ALUOut;

end structure;

