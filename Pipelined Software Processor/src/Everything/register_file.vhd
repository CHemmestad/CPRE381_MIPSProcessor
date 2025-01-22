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

entity register_file is
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
end register_file;

architecture structural of register_file is
	
  component register_n is
    generic(N : integer := 32);
    port(
	i_Clk			:in std_logic;
	i_D			:in std_logic_vector;
	i_Rst			:in std_logic;
	i_En			:in std_logic;
	o_Q			:out std_logic_vector
	);
  end component;
  
  component mux32t1 is
  port(
	i_D0 		            : in std_logic_vector;
	i_D1 		            : in std_logic_vector;
	i_D2 		            : in std_logic_vector;
	i_D3 		            : in std_logic_vector;
	i_D4 		            : in std_logic_vector;
	i_D5 		            : in std_logic_vector;
	i_D6 		            : in std_logic_vector;
	i_D7 		            : in std_logic_vector;
	i_D8 		            : in std_logic_vector;
	i_D9 		            : in std_logic_vector;
	i_D10 		            : in std_logic_vector;
	i_D11 		            : in std_logic_vector;
	i_D12 		            : in std_logic_vector;
	i_D13 		            : in std_logic_vector;
	i_D14 		            : in std_logic_vector;
	i_D15 		            : in std_logic_vector;
	i_D16 		            : in std_logic_vector;
	i_D17 		            : in std_logic_vector;
	i_D18 		            : in std_logic_vector;
	i_D19 		            : in std_logic_vector;
	i_D20 		            : in std_logic_vector;
	i_D21 		            : in std_logic_vector;
	i_D22 		            : in std_logic_vector;
	i_D23 		            : in std_logic_vector;
	i_D24 		            : in std_logic_vector;
	i_D25 		            : in std_logic_vector;
	i_D26 		            : in std_logic_vector;
	i_D27 		            : in std_logic_vector;
	i_D28 		            : in std_logic_vector;
	i_D29 		            : in std_logic_vector;
	i_D30 		            : in std_logic_vector;
	i_D31 		            : in std_logic_vector;
       	i_Code 		            : in std_logic_vector;
       	o_O		            : out std_logic_vector
	);
  end component;
  
  component decoder is
  port(
	i_En		: in std_logic;
	i_Code		: in std_logic_vector;
	o_Decode	: out std_logic_vector
	);
  end component;

type reg32 is array (31 downto 0) of std_logic_vector(31 downto 0);
signal registerArray 	: reg32;
signal registerSelect 	: std_logic_vector(31 downto 0);
signal zeroHex 		: std_logic_vector(31 downto 0) := X"00000000";
signal zero 		: std_logic := '0';

begin
  G_0Reg: register_n port map(
	i_Clk		=> i_Clk,
	i_D		=> zeroHex,
	i_Rst		=> zero,
	i_En		=> '1',
	o_Q		=> registerArray(0)
	);

  G_1t31Regs: for i in 1 to 31 generate
    registerN: register_n port map(
	i_Clk 		=> i_Clk,
	i_Rst		=> i_Rst,
	i_En		=> registerSelect(i),
	i_D		=> i_RdData,
	o_Q		=> registerArray(i)
	);
  end generate G_1t31Regs;

  Decoder_g: decoder port map(
    	i_En		=> i_En,
	i_Code		=> i_Rd,
	o_Decode	=> registerSelect
	);
  
  Mux1_g: mux32t1 port map(
	o_O		=> o_ReadA,
	i_Code		=> i_Rs,
	i_D0 		=> registerArray(0),
	i_D1 		=> registerArray(1),
	i_D2 		=> registerArray(2),
	i_D3 		=> registerArray(3),
	i_D4 		=> registerArray(4),
	i_D5 		=> registerArray(5),
	i_D6 		=> registerArray(6),
	i_D7 		=> registerArray(7),
	i_D8 		=> registerArray(8),
	i_D9 		=> registerArray(9),
	i_D10 		=> registerArray(10),
	i_D11 		=> registerArray(11),
	i_D12 		=> registerArray(12),
	i_D13 		=> registerArray(13),
	i_D14 		=> registerArray(14),
	i_D15 		=> registerArray(15),
	i_D16 		=> registerArray(16),
	i_D17 		=> registerArray(17),
	i_D18 		=> registerArray(18),
	i_D19 		=> registerArray(19),
	i_D20 		=> registerArray(20),
	i_D21 		=> registerArray(21),
	i_D22 		=> registerArray(22),
	i_D23 		=> registerArray(23),
	i_D24 		=> registerArray(24),
	i_D25 		=> registerArray(25),
	i_D26 		=> registerArray(26),
	i_D27 		=> registerArray(27),
	i_D28 		=> registerArray(28),
	i_D29 		=> registerArray(29),
	i_D30 		=> registerArray(30),
	i_D31 		=> registerArray(31)
	);

  Mux2_g: mux32t1 port map(
	o_O		=> o_ReadB,
	i_Code 		=> i_Rt,
	i_D0 		=> registerArray(0),
	i_D1 		=> registerArray(1),
	i_D2 		=> registerArray(2),
	i_D3 		=> registerArray(3),
	i_D4 		=> registerArray(4),
	i_D5 		=> registerArray(5),
	i_D6 		=> registerArray(6),
	i_D7 		=> registerArray(7),
	i_D8 		=> registerArray(8),
	i_D9 		=> registerArray(9),
	i_D10 		=> registerArray(10),
	i_D11 		=> registerArray(11),
	i_D12 		=> registerArray(12),
	i_D13 		=> registerArray(13),
	i_D14 		=> registerArray(14),
	i_D15 		=> registerArray(15),
	i_D16 		=> registerArray(16),
	i_D17 		=> registerArray(17),
	i_D18 		=> registerArray(18),
	i_D19 		=> registerArray(19),
	i_D20 		=> registerArray(20),
	i_D21 		=> registerArray(21),
	i_D22 		=> registerArray(22),
	i_D23 		=> registerArray(23),
	i_D24 		=> registerArray(24),
	i_D25 		=> registerArray(25),
	i_D26 		=> registerArray(26),
	i_D27 		=> registerArray(27),
	i_D28 		=> registerArray(28),
	i_D29 		=> registerArray(29),
	i_D30 		=> registerArray(30),
	i_D31 		=> registerArray(31)
	);
  
  
end structural;