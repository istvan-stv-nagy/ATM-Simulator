library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; 
use ieee.std_logic_arith.all;

entity receipt is
	port (CLK:in std_logic;
	RST: in std_logic;
	enable: in std_logic;
	finish:out std_logic;
	state:out std_logic_vector(2 downto 0));
end entity;

architecture A of receipt is
signal clkdiv:std_logic;
signal count:std_logic_vector(23 downto 0);	
begin
	CLOCKDIV: process(CLK,RST)
	begin
		if RST='1' then count<=(others => '0');
		elsif (CLK'EVENT) and (CLK='1') then 
			count<=count+1;
		end if;
	end process;
	
	clkdiv <= count(23);
	
	COUNTER: process(RST,clkdiv,enable)
	variable iState:std_logic_vector(2 downto 0);
	begin
		if RST='1' then iState:="000";
		elsif (clkdiv'event) and (clkdiv = '1')
		  then if enable='1' then iState:=iState+1;
		  else iState:="000";
		  end if;
		end if;
		state<=iState;
		if (iState="111") then finish<='1'; else finish<='0'; end if; 
	end process;
end A;