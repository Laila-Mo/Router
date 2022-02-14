library IEEE;

use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity FIFO is
port( reset, rclk, wclk, rreq, wreq: in std_logic;
      dataIn:in std_logic_vector(7 downto 0);
      dataOut:out std_logic_vector(7 downto 0);
      full,empty: out std_logic);   
end FIFO;

Architecture struct of FIFO is 

component block_ram is 
port(d_in: in std_logic_vector(7 downto 0);
     ADDRA: in std_logic_vector(2 downto 0);
     ADDRB: in std_logic_vector(2 downto 0);
     WEA: in std_logic;
     REA: in std_logic; 
     CLKA: in std_logic;
     CLKB: in std_logic;
     d_out: out std_logic_vector(7 downto 0));
end component; 
FOR ALL: block_ram USE ENTITY WORK.block_ram(ramdual);
component fifo_ctrl is
port(rdclk, wrclk, reset: in std_logic;
     rreq, wreq: in std_logic;
     write_valid, read_valid: out std_logic;
     wr_ptr, rd_ptr: out std_logic_vector(3 downto 0);
     empty, full: out std_logic);
end component;
FOR ALL: fifo_ctrl USE ENTITY WORK.fifo_ctrl(fifo_arch);
signal ADDRA_ptr,ADDRB_ptr: std_logic_vector(3 downto 0);
signal write_valid_signal, read_valid_signal: std_logic;

BEGIN

controller: fifo_ctrl
port map( rdclk=> rclk, wrclk=>wclk, reset=> reset, rreq=>rreq, wreq=>wreq, write_valid=>write_valid_signal, read_valid=>read_valid_signal, wr_ptr=>ADDRA_ptr, rd_ptr=>ADDRB_ptr, empty=>empty, full=>full);

ram: block_ram 
port map( d_in=> dataIn, ADDRA=> ADDRA_ptr(2 downto 0), ADDRB=> ADDRB_ptr(2 downto 0), WEA=> write_valid_signal, REA=> read_valid_signal, CLKA=> wclk, CLKB=> rclk, d_out=> dataOut);

END Architecture struct;

