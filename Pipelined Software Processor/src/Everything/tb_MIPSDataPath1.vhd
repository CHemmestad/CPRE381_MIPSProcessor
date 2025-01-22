-------------------------------------------------------------------------
-- Caleb Hemmestad
-- Iowa State University
-------------------------------------------------------------------------
-- tb_register_file.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for the structural mux2t_N 
-- unit with an N value of 32.
--              
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

-- Create a test entity
entity tb_MIPSDataPath1 is
    generic (gCLK_HPER : time := 10 ns); -- Generic for half of the clock cycle period
end tb_MIPSDataPath1;

architecture mixed of tb_MIPSDataPath1 is 

    constant cCLK_PER : time := gCLK_HPER * 2;

    component MIPSDataPath1 is 
        port (
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
    end component;

    signal CLK		: std_logic := '0';
    signal s_RST 	: std_logic;
    signal s_EN 	: std_logic;
    signal s_ALU 	: std_logic;
    signal s_ADD_SUB 	: std_logic;
    signal s_IMM 	: std_logic_vector(31 downto 0);
    signal s_RS		: std_logic_vector(4 downto 0);
    signal s_RT 	: std_logic_vector(4 downto 0);
    signal s_RD 	: std_logic_vector(4 downto 0);



begin

    DUT0 : MIPSDataPath1
    port map(
        i_Clk 		=> CLK,
        i_Rst 		=> s_RST,
        i_En 		=> s_EN,
        i_Rd 		=> s_RD,
        i_Rs 		=> s_RS,
        i_Rt 		=> s_RT,
	i_Imm		=> s_IMM,
	i_ALUSrc	=> s_ALU,
	i_nAdd_Sub	=> s_ADD_SUB
	);

    P_CLK : process
    begin
        CLK <= '1';
        wait for gCLK_HPER;
        CLK <= '0';
        wait for gCLK_HPER;
    end process;

    P_TEST_CASES : process
    begin
        wait for gCLK_HPER/2;
        -- Reset  the register
        s_RST <= '1'; 
        -- Turn on the write enable
        s_EN <= '1';
        wait for gCLK_HPER;
        s_RST <= '0';
        wait for gCLK_HPER;
	
	s_ADD_SUB	<= '0';
	s_ALU		<= '1';
	s_RD		<= B"00001";
	s_RS		<= B"00000";
	s_IMM		<= X"00000001";
        wait for gCLK_HPER * 2;
	
	s_ADD_SUB	<= '0';
	s_ALU		<= '1';
	s_RD		<= B"00010";
	s_RS		<= B"00000";
	s_IMM		<= X"00000002";
        wait for gCLK_HPER * 2;

	s_ADD_SUB	<= '0';
	s_ALU		<= '1';
	s_RD		<= B"00011";
	s_RS		<= B"00000";
	s_IMM		<= X"00000003";
        wait for gCLK_HPER * 2;

	s_ADD_SUB	<= '0';
	s_ALU		<= '1';
	s_RD		<= B"00100";
	s_RS		<= B"00000";
	s_IMM		<= X"00000004";
        wait for gCLK_HPER * 2;

	s_ADD_SUB	<= '0';
	s_ALU		<= '1';
	s_RD		<= B"00101";
	s_RS		<= B"00000";
	s_IMM		<= X"00000005";
        wait for gCLK_HPER * 2;
	
	s_ADD_SUB	<= '0';
	s_ALU		<= '1';
	s_RD		<= B"00110";
	s_RS		<= B"00000";
	s_IMM		<= X"00000006";
        wait for gCLK_HPER * 2;

	s_ADD_SUB	<= '0';
	s_ALU		<= '1';
	s_RD		<= B"00111";
	s_RS		<= B"00000";
	s_IMM		<= X"00000007";
        wait for gCLK_HPER * 2;

	s_ADD_SUB	<= '0';
	s_ALU		<= '1';
	s_RD		<= B"01000";
	s_RS		<= B"00000";
	s_IMM		<= X"00000008";
        wait for gCLK_HPER * 2;

	s_ADD_SUB	<= '0';
	s_ALU		<= '1';
	s_RD		<= B"01001";
	s_RS		<= B"00000";
	s_IMM		<= X"00000009";
        wait for gCLK_HPER * 2;

	s_ADD_SUB	<= '0';
	s_ALU		<= '1';
	s_RD		<= B"01010";
	s_RS		<= B"00000";
	s_IMM		<= X"0000000A";
        wait for gCLK_HPER * 2;

	s_ADD_SUB	<= '0';
	s_ALU		<= '0';
	s_RD		<= B"01011";
	s_RS		<= B"00001";
	s_RT		<= B"00010";
        wait for gCLK_HPER * 2;

	s_ADD_SUB	<= '1';
	s_ALU		<= '0';
	s_RD		<= B"01100";
	s_RS		<= B"01011";
	s_RT		<= B"00011";
        wait for gCLK_HPER * 2;

	s_ADD_SUB	<= '0';
	s_ALU		<= '0';
	s_RD		<= B"01101";
	s_RS		<= B"01100";
	s_RT		<= B"00100";
        wait for gCLK_HPER * 2;

	s_ADD_SUB	<= '1';
	s_ALU		<= '0';
	s_RD		<= B"01110";
	s_RS		<= B"01101";
	s_RT		<= B"00101";
        wait for gCLK_HPER * 2;

	s_ADD_SUB	<= '0';
	s_ALU		<= '0';
	s_RD		<= B"01111";
	s_RS		<= B"01110";
	s_RT		<= B"00110";
        wait for gCLK_HPER * 2;

	s_ADD_SUB	<= '1';
	s_ALU		<= '0';
	s_RD		<= B"10000";
	s_RS		<= B"01111";
	s_RT		<= B"00111";
        wait for gCLK_HPER * 2;

	s_ADD_SUB	<= '0';
	s_ALU		<= '0';
	s_RD		<= B"10001";
	s_RS		<= B"10000";
	s_RT		<= B"01000";
        wait for gCLK_HPER * 2;

	s_ADD_SUB	<= '1';
	s_ALU		<= '0';
	s_RD		<= B"10010";
	s_RS		<= B"10001";
	s_RT		<= B"01001";
        wait for gCLK_HPER * 2;

	s_ADD_SUB	<= '0';
	s_ALU		<= '0';
	s_RD		<= B"10011";
	s_RS		<= B"10010";
	s_RT		<= B"01010";
        wait for gCLK_HPER * 2;

	s_ADD_SUB	<= '0';
	s_ALU		<= '1';
	s_RD		<= B"10100";
	s_RS		<= B"00000";
	s_IMM		<= X"FFFFFFDD";
        wait for gCLK_HPER * 2;

	s_ADD_SUB	<= '0';
	s_ALU		<= '0';
	s_RD		<= B"10101";
	s_RS		<= B"10011";
	s_RT		<= B"10100";
        wait for gCLK_HPER * 2;

    end process;

end mixed;