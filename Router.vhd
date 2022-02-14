library IEEE;

use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;


entity Router is
port(datai1,datai2,datai3,datai4: in std_logic_vector(7 downto 0);
wr1, wr2, wr3, wr4: in std_logic; 
datao1,datao2,datao3,datao4: out std_logic_vector(7 downto 0);
wclock, rclock, rst: in std_logic);  
end Router;

architecture behav of Router is 

component REG is 
port(clk, Reset,clk_en : in std_logic;
        D_in : in  std_logic_vector (7 downto 0);
        D_out : out std_logic_vector (7 downto 0));
end component; 
FOR ALL: REG USE ENTITY WORK.REG(Reg8);

component fifo is 
port( reset, rclk, wclk, rreq, wreq: in std_logic;
      dataIn:in std_logic_vector(7 downto 0);
      dataOut:out std_logic_vector(7 downto 0);
      full,empty: out std_logic);   
end component; 
--FOR ALL: fifo USE ENTITY WORK.fifo(struct);

component demux is 
 port(
 din : in STD_LOGIC_VECTOR (7 downto 0);
 Sel: in STD_LOGIC_VECTOR (1 downto 0);
 En: in STD_LOGIC; 
 d_out1, d_out2, d_out3, d_out4 : out STD_LOGIC_VECTOR (7 downto 0)
 );
end component; 
FOR ALL: demux USE ENTITY WORK.demux(demux8);

component round_robin is 
	port(
	din1, din2, din3, din4: in std_logic_vector(7 downto 0);
        clock: in std_logic;
	dout: out std_logic_vector(7 downto 0));
end component; 
FOR ALL: round_robin USE ENTITY WORK.round_robin(behav);

component controller is
port (	     rdclk: in std_logic;
	     Fifo_1_empty,Fifo_2_empty,Fifo_3_empty,Fifo_4_empty: in std_logic;
	     rd_req: out std_logic);
end component;
FOR ALL: controller USE ENTITY WORK.controller(controller);

type arrOfVectors_sig is array(0 to 3) of std_logic_vector (7 downto 0);  
type arrOfVectors_2D_sig is array (0 to 3,0 to 3) of std_logic_vector(7 downto 0);  
type arr_2D_sig is array(0 to 3,0 to 3) of std_logic; 
type arr4x1 is array (0 to 3) of std_logic; 

signal RegOutput: arrOfVectors_sig;
signal OBOutput: arrOfVectors_sig;
signal DeMuxArrOutput: arrOfVectors_2D_sig;
signal FifoOutput: arrOfVectors_2D_sig;
signal FifotoRR: arrOfVectors_2D_sig;
signal Empty: arr_2D_sig;
signal Full: arr_2D_sig;
--signal Full: arr4x1;
signal controllerFlag: arr4x1;
signal Wrreq_arr: arr4x1;
--signal Rdreq: arr_2D_sig;
signal Wrreq:arr_2D_sig;
signal Data_in:arrOfVectors_sig;
signal Data_out:arrOfVectors_sig;
 
Begin 

Wrreq_arr<=(wr1,wr2,wr3,wr4);
Data_in<=(datai1,datai2,datai3,datai4);


p1:process (Data_in,Wrreq_arr,wclock) 
is begin
loop1:for i in 0 to 3 loop
loop2:for j in 0 to 3 loop
 if Wrreq_arr(i)= '1' and RegOutput(i)(1 downto 0)=j then
 Wrreq(i,j) <='1';
 else Wrreq(i,j) <='0';
end if;
end loop loop2;
end loop loop1;
end process p1;

IB1 : REG 
port map(clk=> wclock, D_in=> datai1, reset=>rst, clk_en=>wr1, D_out=>RegOutput(0));
IB2 : REG
port map(clk=> wclock, D_in=> datai2, reset=>rst, clk_en=>wr2, D_out=>RegOutput(1));
IB3 : REG
port map(clk=> wclock, D_in=> datai3, reset=>rst, clk_en=>wr3, D_out=>RegOutput(2));
IB4 : REG
port map(clk=> wclock, D_in=> datai4, reset=>rst, clk_en=>wr4, D_out=>RegOutput(3));


DeMux1: DEMUX
port map(din=> RegOutput(0), Sel=> (RegOutput(0)(1 downto 0)), En=> wr1, d_out1=>DeMuxArrOutput(0,0),
         d_out2=>DeMuxArrOutput(0,1),d_out3=>DeMuxArrOutput(0,2),d_out4=>DeMuxArrOutput(0,3));
DeMux2: DEMUX
port map(din=> RegOutput(1), Sel=> (RegOutput(1)(1 downto 0)), En=> wr2, d_out1=>DeMuxArrOutput(1,0),
         d_out2=>DeMuxArrOutput(1,1),d_out3=>DeMuxArrOutput(1,2),d_out4=>DeMuxArrOutput(1,3));
DeMux3: DEMUX
port map(din=> RegOutput(2), Sel=> (RegOutput(2)(1 downto 0)), En=> wr3, d_out1=>DeMuxArrOutput(2,0),
         d_out2=>DeMuxArrOutput(2,1),d_out3=>DeMuxArrOutput(2,2),d_out4=>DeMuxArrOutput(2,3));
DeMux4: DEMUX
port map(din=> RegOutput(3), Sel=> (RegOutput(3)(1 downto 0)), En=> wr4, d_out1=>DeMuxArrOutput(3,0),
         d_out2=>DeMuxArrOutput(3,1),d_out3=>DeMuxArrOutput(3,2),d_out4=>DeMuxArrOutput(3,3));

RR1: round_robin
port map(clock => rclock, din1=> FifotoRR(0,0), din2=> FifotoRR(0,1), din3=> FifotoRR(0,2), din4=> FifotoRR(0,3), dout=> Data_out(0));
RR2: round_robin
port map(clock => rclock, din1=> FifotoRR(1,0), din2=> FifotoRR(1,1), din3=> FifotoRR(1,2), din4=> FifotoRR(1,3), dout=> Data_out(1));
RR3: round_robin
port map(clock => rclock, din1=> FifotoRR(2,0), din2=> FifotoRR(2,1), din3=> FifotoRR(2,2), din4=> FifotoRR(2,3), dout=> Data_out(2));
RR4: round_robin
port map(clock => rclock, din1=> FifotoRR(3,0), din2=> FifotoRR(3,1), din3=> FifotoRR(3,2), din4=> FifotoRR(3,3), dout=> Data_out(3));

CTRL1: controller
port map(rdclk=> rclock, Fifo_1_empty=> Empty(0,0), Fifo_2_empty=> Empty(0,1), Fifo_3_empty=> Empty(0,2), Fifo_4_empty=> Empty(0,3), rd_req=> controllerFlag(0));  
CTRL2: controller
port map(rdclk=> rclock, Fifo_1_empty=> Empty(1,0), Fifo_2_empty=> Empty(1,1), Fifo_3_empty=> Empty(1,2), Fifo_4_empty=> Empty(1,3), rd_req=> controllerFlag(1));  
CTRL3: controller
port map(rdclk=> rclock, Fifo_1_empty=> Empty(2,0), Fifo_2_empty=> Empty(2,1), Fifo_3_empty=> Empty(2,2), Fifo_4_empty=> Empty(2,3), rd_req=> controllerFlag(2));  
CTRL4: controller
port map(rdclk=> rclock, Fifo_1_empty=> Empty(3,0), Fifo_2_empty=> Empty(3,1), Fifo_3_empty=> Empty(3,2), Fifo_4_empty=> Empty(3,3), rd_req=> controllerFlag(3));  

Fifo_outer_loop: FOR i IN 0 TO 3 GENERATE
begin
 Fifo_inner_loop: FOR j IN 0 TO 3 GENERATE
FOR ALL: fifo USE ENTITY WORK.fifo(struct);
begin
routerFIFO: fifo
port map( reset=> rst, rclk=> rclock, wclk=> wclock, rreq=> controllerFlag(i), wreq=> Wrreq(i,j), dataIn=> DeMuxArrOutput(j,i), dataOut=> FifotoRR(i, j), full=> Full(i,j), empty=> Empty(i,j)); 
END GENERATE Fifo_inner_loop;
END GENERATE Fifo_outer_loop;

OB1 : REG 
port map(clk=> rclock, D_in=> Data_out(0), reset=>rst, clk_en=>'1', D_out=>OBOutput(0));
OB2 : REG
port map(clk=> rclock, D_in=> Data_out(1), reset=>rst, clk_en=>'1', D_out=>OBOutput(1));
OB3 : REG
port map(clk=> rclock, D_in=> Data_out(2), reset=>rst, clk_en=>'1', D_out=>OBOutput(2));
OB4 : REG
port map(clk=> rclock, D_in=> Data_out(3), reset=>rst, clk_en=>'1', D_out=>OBOutput(3));

datao1<= OBOutput(0); 
datao2<= OBOutput(1);
datao3<= OBOutput(2);
datao4<= OBOutput(3);

END Architecture behav;

