-- Susanna Shenouda
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


--HazardDetection.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: this file contains an implementation of the Hazard Detection Unit for the
-- the hwardware scheduled pipeline
--
-- comment
-- NOTES:
-- 11/12/24 created
-------------------------------------------------------------------------



library IEEE;
use IEEE.std_logic_1164.all;



entity HazardDetection is
  port(
    IDEX_MemRead    : in std_logic;
    IDEX_RegRt : in std_logic_vector(4 downto 0);
    IFID_RegRs : in std_logic_vector(4 downto 0);
    IFID_RegRt : in std_logic_vector(4 downto 0);
    PCWr         : out std_logic;
    IFID_Wr     : out std_logic;
    CtrlMuxSel  : out std_logic


);

end HazardDetection;

architecture structural of HazardDetection is

component  org2 is

  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);

end component;


component invg is

  port(i_A          : in std_logic;
       o_F          : out std_logic);

end component;

component andg2 is

  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);

end component;


signal RsEqual, RtEqual, isEqual, isHazard : std_logic;
  signal RegRsComp, RegRtComp : std_logic_vector(4 downto 0);

begin

  -- Compare ID_EX_RegisterRt with IF_ID_RegisterRs
  RegRsComp <= IDEX_RegRt xnor IFID_RegRs;
  RsEqual <= RegRsComp(0) and RegRsComp(1) and RegRsComp(2) and RegRsComp(3) and RegRsComp(4);

  -- Compare ID_EX_RegisterRt with IF_ID_RegisterRt
  RegRtComp <= IDEX_RegRt xnor IFID_RegRt;
  RtEqual <= RegRtComp(0) and RegRtComp(1) and RegRtComp(2) and RegRtComp(3) and RegRtComp(4);

  -- OR the results of the comparisons
  or_comp: org2
    port map (
      i_A => RsEqual,
      i_B => RtEqual,
      o_F => isEqual
    );

  -- AND the OR result with ID_EX_MemRead to detect hazard
  and_hazard: andg2
    port map (
      i_A => IDEX_MemRead,
      i_B => isEqual,
      o_F => isHazard
    );

  -- Invert hazard_detected for PCWrite and IF_ID_Write
  inv_pcwrite: invg
    port map (
      i_A => isHazard,
      o_F => PCWr
    );

  inv_IFIDWr: invg
    port map (
      i_A => isHazard,
      o_F => IFID_Wr
    );

  -- Control_Mux_Sel is directly connected to hazard_detected
  CtrlMuxSel <= isHazard;


end structural;



