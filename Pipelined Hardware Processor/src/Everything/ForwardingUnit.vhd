/*

Caleb Hemmestad

*/


library IEEE;
use IEEE.std_logic_1164.all;



entity ForwardingUnit is
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
end ForwardingUnit;

architecture structural of ForwardingUnit is

begin
    
    process(EXRegRs, EXRegRt, MEMRegRd, WBRegRd, MEMRegWr, WBRegWr)
    begin
    ForwardA <= "00";
    ForwardB <= "00";
    
    if (MEMRegWr = '1') and (MEMRegRd /= "00000") then
      if (MEMRegRd = EXRegRs) then
        ForwardA <= "10";
      end if;
      if (MEMRegRd = EXRegRt) then
        ForwardB <= "10";
      end if;
    end if;
    
    if (WBRegWr = '1') and (WBRegRd /= "00000") then
      if (WBRegRd = EXRegRs) and not (MEMRegWr = '1' and MEMRegRd /= "00000" and MEMRegRd = EXRegRs) then
        ForwardA <= "01";
      end if;
      if (WBRegRd = EXRegRt) and not (MEMRegWr = '1' and MEMRegRd /= "00000" and MEMRegRd = EXRegRt) then
        ForwardB <= "01";
      end if;
    end if;
  end process;

end structural;



