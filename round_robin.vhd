library ieee;
use ieee.std_logic_1164.all;

entity round_robin is
	port(
	din1, din2, din3, din4: in std_logic_vector(7 downto 0);
        clock: in std_logic;
	dout: out std_logic_vector(7 downto 0));
end entity round_robin;


architecture behav of round_robin is
	type state_type is (s1,s2,s3,s4);
        signal NS: state_type;
	signal CS: state_type := s1;
begin

	p1: process(clock) 
begin
		
  if rising_edge(clock) then
CS<=NS;
else 
CS<=CS;
	end if;
	end process p1;

   p2: process(CS) 
begin
	case CS is
   when s1 =>  
  NS <= s2; dout<= din1;
  when s2 =>
   NS <= s3;  dout <= din2;
 when s3 => 
  NS <= s4; dout<=din3;
 when s4 => 
  NS <= s1;  dout<= din4;
 
  end case;
  end process p2;                          
		                         
	
end architecture behav;

