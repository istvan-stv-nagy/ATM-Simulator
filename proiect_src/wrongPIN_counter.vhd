library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; 
use ieee.std_logic_arith.all;

entity wrongPIN_counter is
	port(CLK:in std_logic;
	ENABLE: in std_logic;
	RST: in std_logic;
	TC:out std_logic);
end entity;

architecture A of wrongPIN_counter is
begin
	COUNT: process(CLK,RST)
	variable iQ:std_logic_vector(1 downto 0);
	begin
		if RST='1' then iQ:="00";
		elsif (CLK'EVENT) and (CLK='1')
			then if ENABLE='1' then iQ:=iQ+1;
			end if;
		end if;
		TC<=iQ(1) and iQ(0);
	end process;
end A;