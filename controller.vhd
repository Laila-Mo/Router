LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY controller IS
port (	     rdclk: in std_logic;
	     Fifo_1_empty,Fifo_2_empty,Fifo_3_empty,Fifo_4_empty: in std_logic;
	     rd_req: out std_logic
	
      );
END ENTITY controller;

ARCHITECTURE controller OF controller is
type state is (fifo1,fifo2,fifo3,fifo4);
signal current_fifo: state;
signal next_fifo: state;

begin
p1:process (rdclk) is
begin 
 if rising_edge(rdclk) then
 current_fifo <= next_fifo;
 end if;
end process p1; 

p2:process (current_fifo,Fifo_1_empty,Fifo_2_empty,Fifo_3_empty,Fifo_4_empty) is 
begin
case current_fifo is
when fifo1=>
  next_fifo<= fifo2;
  if Fifo_1_empty='0' then
  rd_req<='1';
  else rd_req<='0';
  end if;
when fifo2=>
  next_fifo<= fifo3;
  if Fifo_2_empty='0' then
  rd_req<='1';
  else rd_req<='0';
  end if;
when fifo3=>
  next_fifo<= fifo4;
  if Fifo_3_empty='0' then
  rd_req<='1';
  else rd_req<='0';
  end if;
when fifo4=>
  next_fifo<= fifo1;
  if Fifo_4_empty='0' then
  rd_req<='1';
  else rd_req<='0';
  end if;
end case;
end process p2;
end architecture controller;
