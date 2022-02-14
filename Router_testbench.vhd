library IEEE;

use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;


entity Router_testbench is  
end Router_testbench;

Architecture behav of Router_testbench IS

component Router is 
port(datai1,datai2,datai3,datai4: in std_logic_vector(7 downto 0);
wr1, wr2, wr3, wr4: in std_logic; 
datao1,datao2,datao3,datao4: out std_logic_vector(7 downto 0);
wclock, rclock, rst: in std_logic);  
end component; 
FOR ALL: Router USE ENTITY WORK.Router(behav);

signal datai1,datai2,datai3,datai4: std_logic_vector( 7 downto 0);
signal wr1, wr2, wr3, wr4: std_logic; 
signal datao1,datao2,datao3,datao4: std_logic_vector( 7 downto 0);
signal wclock, rclock, rst: std_logic;
  CONSTANT clk_period : TIME := 100 ns;

Begin 

DUT : Router
port map( rst=> rst, rclock=> rclock, wclock=> wclock,
          datai1=> datai1, datai2=> datai2, datai3=> datai3, datai4=> datai4,
          wr1=> wr1, wr2=> wr2, wr3=> wr3, wr4=> wr4,
          datao1=> datao1, datao2=> datao2, datao3=> datao3, datao4=> datao4);
    rclk_process : PROCESS
    BEGIN
        rclock <= '0';
        WAIT FOR clk_period/2;
        rclock <= '1';
        WAIT FOR clk_period/2;
    END PROCESS;

    wrclk_process : PROCESS
    BEGIN
        wclock <= '0';
        WAIT FOR clk_period/2;
        wclock <= '1';
        WAIT FOR clk_period/2;

    END PROCESS;

    stim_p : PROCESS
    BEGIN
        rst <= '1';
datai1 <= "00000100";
        datai2 <= "00000011";
        datai3 <= "00000010";
        datai4 <= "00000001";
        wr1 <= '1';
        wr2 <= '1';
        wr3 <= '1';
        wr4 <= '1';

        WAIT FOR clk_period;
        datai1 <= "00000100";
        datai2 <= "00000011";
        datai3 <= "00000010";
        datai4 <= "00000001";
        rst <= '0';
        wr1 <= '1';
        wr2 <= '1';
        wr3 <= '1';
        wr4 <= '1';
        WAIT FOR clk_period;
        datai1 <= "00010000";
        datai2 <= "00100000";
        datai3 <= "00110000";
        datai4 <= "01000000";
        WAIT FOR clk_period;
        datai2 <= "00100000";
     WAIT FOR clk_period;
ASSERT datao2 = "001000000"
            SEVERITY Error;
        WAIT FOR clk_period;
        wr1 <= '0';
        wr2 <= '0';
        wr3 <= '0';
        wr4 <= '0';
        WAIT FOR clk_period;
       datai1 <= "00000000";
        datai2 <= "00000011";
    datai3 <= "00000000";
    datai4 <= "00000000";
WAIT FOR clk_period;
        ASSERT datao2 = "00000001"
            SEVERITY Error;
        WAIT FOR clk_period;
      datai1 <= "00000100";
    datai2 <= "00000000";
  datai3 <= "00000000";
    datai4 <= "00000000";
WAIT FOR clk_period;
        ASSERT datao1 = "00000100"
            SEVERITY Error;
        WAIT FOR clk_period;

           datai1 <= "00000000";
    datai2 <= "00000000";
  datai3 <= "00000000";
    datai4 <= "00000011";
WAIT FOR clk_period;
   ASSERT datao4 = "00000011"
            SEVERITY Error;
     WAIT FOR clk_period;
           datai1 <= "00000000";
    datai2 <= "00000000";
  datai3 <= "00000010";
    datai4 <= "00000000";
WAIT FOR clk_period;
        ASSERT datao3 = "00000010"
            SEVERITY Error;
   WAIT FOR clk_period;
        
        datai1 <= "00010000";
        datai2 <= "00100000";
        datai3 <= "00110000";
        datai4 <= "01000000";
   WAIT FOR clk_period/2;


        WAIT;
    END PROCESS;
End;