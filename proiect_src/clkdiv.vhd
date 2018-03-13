library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; 
use ieee.std_logic_arith.all;

entity clkdiv is
	port(CLK:in std_logic; 
	RST: in std_logic;
	blink: out std_logic;
	mclk:out std_logic);
end entity;


architecture A of clkdiv is	   
signal count:std_logic_vector(25 downto 0);
begin
	mclk <= count(17);
	
	blink <= count(25);
	
	process(CLK,RST)
	variable iq:std_logic_vector(25 downto 0);
	begin
		if RST='1' then iq:=(others => '0');
		elsif (CLK'EVENT) and (CLK='1') then 
			iq:=iq+1;
		end if;
		count<=iq;
	end process;
end A;
		