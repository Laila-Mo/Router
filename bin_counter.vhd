LIBRARY ieee;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_1164.ALL;
use IEEE.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY bin_counter IS
port(clk,en,reset:in std_logic;
count_out:out unsigned(3 downto 0));
end;

architecture behav of bin_counter is 
SIGNAL counter:unsigned (3 DOWNTO 0);
begin
p1:process (clk) is 
begin
IF rising_edge (clk) THEN
if reset='1' then counter<="0000";
elsif en='1'
then counter<=counter+1;
end if;
end if;
end process p1;
count_out<=counter;
end architecture behav;

