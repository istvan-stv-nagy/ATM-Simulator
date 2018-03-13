library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity plus_one is
	port(
	a:in std_logic_vector(15 downto 0);
	CIN:in std_logic;
	newA:out std_logic_vector(15 downto 0)
	);
end entity plus_one;


architecture A of plus_one is
begin
	process(a, cin)
	begin
		if a(3 downto 0)="1001" then newA(3 downto 0)<="0000";
		else newA<=a+CIN; 
		end if;	
	end process;
end;