library IEEE;
use IEEE.STD_LOGIC_1164.all;
 
entity demux is
 port(
 
 din : in STD_LOGIC_VECTOR (7 downto 0);
 Sel: in STD_LOGIC_VECTOR (1 downto 0);
 En: in STD_LOGIC; 
 d_out1, d_out2, d_out3, d_out4 : out STD_LOGIC_VECTOR (7 downto 0)
 );
end demux;
 
architecture demux8 of demux is
begin

p1: process (En,Sel,din) is
begin
if(En = '1') then
case sel is
when "00"=> d_out1<=din;
when "01"=> d_out2<=din;
when "10"=> d_out3<=din;
when"11"=> d_out4<=din;
when others=> null; 
end case;

end if;
end process p1;
end demux8;
