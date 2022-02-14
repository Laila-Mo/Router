library ieee;
use ieee.std_logic_1164.all;
 
entity Reg is
  port(clk, Reset,clk_en : in std_logic;
        D_in : in  std_logic_vector (7 downto 0);
        D_out : out std_logic_vector (7 downto 0));
end entity Reg; 

architecture Reg8 of Reg is
begin
p1: process (clk_en,clk,Reset)
      begin
        if (Reset='1') then
          D_out <= "00000000";
        elsif (rising_edge(clk) AND clk_en= '1')then
            D_out <= D_in;
        end if;
    end process p1;
end Reg8;

