LIBRARY ieee;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_1164.ALL;
use IEEE.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
ENTITY grayCounter IS
port(clk,en,reset:in std_logic;
count_out:out  std_logic_vector(3 downto 0));
end;
architecture behav of grayCounter is
component bin_counter is
port(clk,en,reset:in std_logic;
count_out:out unsigned(3 downto 0));
end component;
FOR ALL: bin_counter USE ENTITY WORK.bin_counter(behav);
SIGNAL b_counter:unsigned(3 DOWNTO 0);
begin
b_count: bin_counter port map(clk=>clk,en=>en,reset=>reset,count_out=>b_counter);
p1: process(b_counter) is 
begin
count_out(3)<=b_counter(3);
for i in 2 downto 0 loop
count_out(i)<=b_counter (i+1) XOR b_counter (i);
end loop;
end process p1;
end architecture;

