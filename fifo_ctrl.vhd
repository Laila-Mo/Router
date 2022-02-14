
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fifo_ctrl is 
port( 
rdclk, wrclk, reset: in std_logic;
rreq, wreq: in std_logic;
write_valid, read_valid : out std_logic;
wr_ptr, rd_ptr : out std_logic_vector(3 downto 0);
empty, full : out std_logic
);
end entity fifo_ctrl;

architecture fifo_arch of fifo_ctrl is
signal s_wr_ptr_gray : std_logic_vector(3 downto 0) ;
signal s_rd_ptr_gray : std_logic_vector(3 downto 0) ;
signal s_wr_ptr : std_logic_vector(3 downto 0) ;
signal s_rd_ptr : std_logic_vector(3 downto 0) ;
shared variable fifo: std_logic_vector(7 downto 0):="00000000" ;
signal s_write_reset : std_logic:='1';
signal s_read_reset : std_logic:='1';

component grayToBin is
port(gray_in:in std_logic_vector(3 downto 0);
bin_out:out std_logic_vector(3 downto 0));
end component;
FOR ALL: grayToBin USE ENTITY WORK.grayToBin(behav);
component grayCounter is
port(clk,en,reset:in std_logic;
count_out:out  std_logic_vector(3 downto 0));
end component;
FOR ALL: grayCounter USE ENTITY WORK.grayCounter(behav);

begin
gray_bin_rd: grayToBin port map(s_rd_ptr_gray, s_rd_ptr);
gray_bin_wr: grayToBin port map(s_wr_ptr_gray, s_wr_ptr);
gray_count_rd: grayCounter port map(rdclk, rreq, s_read_reset, s_rd_ptr_gray);
gray_count_wr: grayCounter port map(wrclk, wreq, s_write_reset, s_wr_ptr_gray);

rd_ptr<=s_rd_ptr;
wr_ptr<=s_wr_ptr;

p_request: process (rreq,wreq,reset,rdclk,wrclk,s_rd_ptr_gray,s_wr_ptr_gray) is
begin
if reset='1' then 
 s_read_reset<='1';
 s_write_reset<='1';
 full<='0';
 empty<='1';
 write_valid<='0';
 read_valid<='0';
 fifo:="00000000";
--end if; 
--if reset='0' then 
else
if s_wr_ptr/="0111" then s_write_reset<='0';
 else s_write_reset<='1';
end if;

if s_rd_ptr/="0111" then s_read_reset<='0';
 else s_read_reset<='1';
end if;

if rising_edge (rdclk) then 
 if rreq='1' then 
  if fifo/="00000000" then 
  read_valid<='1';
  fifo(to_integer (unsigned(s_rd_ptr))):='0';
  else read_valid<='0';
  end if;
 end if;
end if;

if rising_edge (wrclk) then
 if wreq='1' then 
  if fifo/="11111111" then
  write_valid<='1';
  fifo(to_integer (unsigned(s_wr_ptr))):='1';
  else write_valid<='0';
  end if;
 end if;
end if;

if fifo="00000000" then
 empty<='1';
 full<='0';

elsif fifo="11111111" then
 full<='1'; 
 empty<='0';
else
empty<='0';
full<='0';
end if;

end if;
end process p_request;

end architecture fifo_arch;
