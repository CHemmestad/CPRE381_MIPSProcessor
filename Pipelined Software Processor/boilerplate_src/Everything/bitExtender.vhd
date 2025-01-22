-------------------------------------------------------------------------
-- Caleb Hemmestad
-- 
-- Iowa State University
-------------------------------------------------------------------------


-- mux2t1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Adder Nth
--
--
-- NOTES:
-- 9/2/24 created
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity bitExtender is
  port(
	i_Data			:in std_logic_vector(15 downto 0);
	i_Sign			:in std_logic;
	o_Ext			:out std_logic_vector(31 downto 0)
	);
end bitExtender;

architecture dataflow of bitExtender is
	
signal s_Out         :std_logic_vector(31 downto 0);

begin
  
  process(i_Data, i_Sign)
  begin
  	Data: for i in 0 to 15 loop
		s_Out(i) <= i_Data(i);
  	end loop Data;
  	
	if i_Sign = '1' then
  		Extend1: for i in 16 to 31 loop
  			s_Out(i) <= i_Data(15);
  		end loop Extend1;
	else 
		Extend0: for i in 16 to 31 loop
  			s_Out(i) <= '0';
  		end loop Extend0;
	end if;
  end process;
  o_Ext <= s_Out;
  
end dataflow;
