library ieee;
use ieee.std_logic_1164.all;

entity PIN_Register is
	port(I:in std_logic_vector(4 downto 1);
	B:in std_logic_vector(4 downto 1);
	Load:in std_logic;
	RST:in std_logic;
	CLK:in std_logic;
	Q:out std_logic_vector(15 downto 0));
end entity PIN_Register;

architecture A of PIN_Register is
begin
	PIN_REGISTER: process(CLK,RST)
	variable iQ:std_logic_vector(15 downto 0):="0000000000000000";
	begin
		if RST='1' then iQ:="0000000000000000";
		else if (CLK'EVENT) and (CLK='1') and (Load='1') then 
			if B(4)='1' then iQ(15 downto 12):=I; end if;
			if B(3)='1' then iQ(11 downto 8):=I; end if;
			if B(2)='1' then iQ(7 downto 4):=I; end if;
			if B(1)='1' then iQ(3 downto 0):=I; end if;
		end if;
		end if;
		Q<=iQ;
	end process PIN_REGISTER;
end A;
			