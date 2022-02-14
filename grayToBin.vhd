library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity grayToBin is 
port(
gray_in:in std_logic_vector(3 downto 0);
bin_out:out std_logic_vector(3 downto 0));
end;
architecture behav of grayToBin is
begin 
p1:process(gray_in) is
begin
bin_out(3)<=gray_in(3);
bin_out(2)<=gray_in(3) XOR gray_in(2) ;
bin_out(1)<=gray_in(3) XOR gray_in(2) XOR gray_in(1);
bin_out(0)<=gray_in(3) XOR gray_in(2) XOR gray_in(1) XOR gray_in(0);
end process p1;
end architecture behav;

