library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity block_ram is
	port 
	(
		d_in	: in std_logic_vector(7 downto 0);
		ADDRA	: in std_logic_vector(2 downto 0);
                ADDRB	: in std_logic_vector(2 downto 0);
		WEA	: in std_logic := '1';
                REA	: in std_logic := '1';
                CLKA	: in std_logic;
		CLKB	: in std_logic;
		d_out	: out std_logic_vector(7 downto 0)
	);
	
end block_ram;

architecture ramdual of block_ram is

	-- Array ram
	subtype wordd is std_logic_vector(7 downto 0);
	type mem is array(7 downto 0) of wordd; 
	
	signal ram : mem;

begin

	process(CLKA)
	begin
		if(rising_edge(CLKA)) then 
			if(WEA = '1') then
				ram(to_integer(unsigned(ADDRA))) <= d_in;
			end if;
		end if;
	end process;
	
	process(CLKB)
	begin
		if(rising_edge(CLKB)) then
                       if(REA ='1') then
			        d_out <= ram(to_integer(unsigned(ADDRB)));
elsif(REA ='0') then
			d_out<="ZZZZZZZZ"; 
                       end if;
		end if;
	end process;

end architecture ramdual;

