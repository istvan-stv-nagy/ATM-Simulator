library ieee;
use ieee.std_logic_1164.all;   
use ieee.std_logic_unsigned.all;

entity debouncer is
	port(button: in std_logic;
	clk: in std_logic;
	result: out std_logic);
end debouncer;

architecture a1 of debouncer is
signal ff: std_logic_vector(1 downto 0);
signal counter_set: std_logic;
signal counter_cont: std_logic_vector(21 downto 0);  
begin
	counter_set<=ff(0) xor ff(1);
	process(clk)
	begin
		if clk'event and clk='1' then
			ff(0)<=button;
			ff(1)<=ff(0);
			if counter_set='1' then
				counter_cont<=(others=>'0');
			elsif(counter_cont(21)='0') then
				counter_cont<=counter_cont+1;
			else
				result<=ff(1);
			end if;
		end if;
	end process;
end;