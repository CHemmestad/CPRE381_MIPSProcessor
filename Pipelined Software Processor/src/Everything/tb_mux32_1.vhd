
-------------------------------------------------------------------------
-- Caleb Hemmestad
-- 
-- Iowa State University
-------------------------------------------------------------------------

-------------------------------------------------------------------------
-- DESCRIPTION:
--
--
-- NOTES:
-- Created 9/24/24 by Caleb Hemmestad
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_mux32_1 is
  generic(gCLK_HPER   	: time := 50 ns);
end tb_mux32_1;

architecture mixed of tb_mux32_1 is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;

component mux32t1 is

  port(
	i_D0 		            : in std_logic_vector(31 downto 0);
	i_D1 		            : in std_logic_vector(31 downto 0);
	i_D2 		            : in std_logic_vector(31 downto 0);
	i_D3 		            : in std_logic_vector(31 downto 0);
	i_D4 		            : in std_logic_vector(31 downto 0);
	i_D5 		            : in std_logic_vector(31 downto 0);
	i_D6 		            : in std_logic_vector(31 downto 0);
	i_D7 		            : in std_logic_vector(31 downto 0);
	i_D8 		            : in std_logic_vector(31 downto 0);
	i_D9 		            : in std_logic_vector(31 downto 0);
	i_D10 		            : in std_logic_vector(31 downto 0);
	i_D11 		            : in std_logic_vector(31 downto 0);
	i_D12 		            : in std_logic_vector(31 downto 0);
	i_D13 		            : in std_logic_vector(31 downto 0);
	i_D14 		            : in std_logic_vector(31 downto 0);
	i_D15 		            : in std_logic_vector(31 downto 0);
	i_D16 		            : in std_logic_vector(31 downto 0);
	i_D17 		            : in std_logic_vector(31 downto 0);
	i_D18 		            : in std_logic_vector(31 downto 0);
	i_D19 		            : in std_logic_vector(31 downto 0);
	i_D20 		            : in std_logic_vector(31 downto 0);
	i_D21 		            : in std_logic_vector(31 downto 0);
	i_D22 		            : in std_logic_vector(31 downto 0);
	i_D23 		            : in std_logic_vector(31 downto 0);
	i_D24 		            : in std_logic_vector(31 downto 0);
	i_D25 		            : in std_logic_vector(31 downto 0);
	i_D26 		            : in std_logic_vector(31 downto 0);
	i_D27 		            : in std_logic_vector(31 downto 0);
	i_D28 		            : in std_logic_vector(31 downto 0);
	i_D29 		            : in std_logic_vector(31 downto 0);
	i_D30 		            : in std_logic_vector(31 downto 0);
	i_D31 		            : in std_logic_vector(31 downto 0);
    	i_Code 		            : in std_logic_vector(4 downto 0);
    	o_O		            : out std_logic_vector(31 downto 0)
	);

end component;

  signal s_D0 		            : std_logic_vector(31 downto 0);
  signal s_D1 		            : std_logic_vector(31 downto 0);
  signal s_D2 		            : std_logic_vector(31 downto 0);
  signal s_D3 		            : std_logic_vector(31 downto 0);
  signal s_D4 		            : std_logic_vector(31 downto 0);
  signal s_D5 		            : std_logic_vector(31 downto 0);
  signal s_D6 		            : std_logic_vector(31 downto 0);
  signal s_D7 		            : std_logic_vector(31 downto 0);
  signal s_D8 		            : std_logic_vector(31 downto 0);
  signal s_D9 		            : std_logic_vector(31 downto 0);
  signal s_D10 		            : std_logic_vector(31 downto 0);
  signal s_D11 		            : std_logic_vector(31 downto 0);
  signal s_D12 		            : std_logic_vector(31 downto 0);
  signal s_D13 		            : std_logic_vector(31 downto 0);
  signal s_D14 		            : std_logic_vector(31 downto 0);
  signal s_D15 		            : std_logic_vector(31 downto 0);
  signal s_D16 		            : std_logic_vector(31 downto 0);
  signal s_D17 		            : std_logic_vector(31 downto 0);
  signal s_D18 		            : std_logic_vector(31 downto 0);
  signal s_D19 		            : std_logic_vector(31 downto 0);
  signal s_D20 		            : std_logic_vector(31 downto 0);
  signal s_D21 		            : std_logic_vector(31 downto 0);
  signal s_D22 		            : std_logic_vector(31 downto 0);
  signal s_D23 		            : std_logic_vector(31 downto 0);
  signal s_D24 		            : std_logic_vector(31 downto 0);
  signal s_D25 		            : std_logic_vector(31 downto 0);
  signal s_D26 		            : std_logic_vector(31 downto 0);
  signal s_D27 		            : std_logic_vector(31 downto 0);
  signal s_D28 		            : std_logic_vector(31 downto 0);
  signal s_D29 		            : std_logic_vector(31 downto 0);
  signal s_D30 		            : std_logic_vector(31 downto 0);
  signal s_D31 		            : std_logic_vector(31 downto 0);
  signal s_Code 		    : std_logic_vector(4 downto 0);
  signal s_O		            : std_logic_vector(31 downto 0);

begin

  DUT0: mux32t1
  port map(
        i_D0        => s_D0,
        i_D1        => s_D1,
        i_D2        => s_D2,
        i_D3        => s_D3,
        i_D4        => s_D4,
        i_D5        => s_D5,
        i_D6        => s_D6,
        i_D7        => s_D7,
        i_D8        => s_D8,
        i_D9        => s_D9,
        i_D10       => s_D10,
        i_D11       => s_D11,
        i_D12       => s_D12,
        i_D13       => s_D13,
        i_D14       => s_D14,
        i_D15       => s_D15,
        i_D16       => s_D16,
        i_D17       => s_D17,
        i_D18       => s_D18,
        i_D19       => s_D19,
        i_D20       => s_D20,
        i_D21       => s_D21,
        i_D22       => s_D22,
        i_D23       => s_D23,
        i_D24       => s_D24,
        i_D25       => s_D25,
        i_D26       => s_D26,
        i_D27       => s_D27,
        i_D28       => s_D28,
        i_D29       => s_D29,
        i_D30       => s_D30,
        i_D31       => s_D31,
       	i_Code 	    => s_Code,
       	o_O	    => s_O
	);

  -- This process sets the clock value (low for gCLK_HPER, then high
  -- for gCLK_HPER). Absent a "wait" command, processes restart 
  -- at the beginning once they have reached the final statement.
  
  -- Testbench process  
  P_TB: process
  begin
    s_D0    <= X"00000001";
    s_D1    <= X"00000002";
    s_D2    <= X"00000004";
    s_D3    <= X"00000008";
    s_D4    <= X"00000010";
    s_D5    <= X"00000020";
    s_D6    <= X"00000040";
    s_D7    <= X"00000080";
    s_D8    <= X"00000100";
    s_D9    <= X"00000200";
    s_D10   <= X"00000400";
    s_D11   <= X"00000800";
    s_D12   <= X"00001000";
    s_D13   <= X"00002000";
    s_D14   <= X"00004000";
    s_D15   <= X"00008000";
    s_D16   <= X"00010000";
    s_D17   <= X"00020000";
    s_D18   <= X"00040000";
    s_D19   <= X"00080000";
    s_D20   <= X"00100000";
    s_D21   <= X"00200000";
    s_D22   <= X"00400000";
    s_D23   <= X"00800000";
    s_D24   <= X"01000000";
    s_D25   <= X"02000000";
    s_D26   <= X"04000000";
    s_D27   <= X"08000000";
    s_D28   <= X"10000000";
    s_D29   <= X"20000000";
    s_D30   <= X"40000000";
    s_D31   <= X"80000000";
    -- Reset the FF
    -- s_En  <= '0';
    s_Code   <= B"00001";
    wait for cCLK_PER;

    -- Store '1'
    -- s_En  <= '1';
    s_Code   <= B"00100";
    wait for cCLK_PER;  

    -- Keep '1'
    -- s_En  <= '0';
    s_Code   <= B"01111";
    wait for cCLK_PER;  

    -- Store '0'    
    -- s_En  <= '1';
    s_Code   <= B"11111";
    wait for cCLK_PER;  

    -- Keep '0'
    -- s_En  <= '1';
    s_Code   <= B"01010";
    wait for cCLK_PER;  

    -- s_En  <= '1';
    s_Code   <= B"00000";
    wait for cCLK_PER;

    wait;
  end process;
  
end mixed;
