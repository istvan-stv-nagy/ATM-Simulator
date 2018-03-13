library ieee;
use ieee.std_logic_1164.all;

entity MONEY_Register is
	port(I:in std_logic_vector(4 downto 1);
	B:in std_logic_vector(4 downto 1);
	Load:in std_logic;
	Reload:in std_logic;
	RST:in std_logic;
	CLK:in std_logic;
	DIN:in std_logic_vector(15 downto 0);
	Q:out std_logic_vector(15 downto 0);
	L:out std_logic_vector(3 downto 0));
end entity MONEY_Register;

architecture A of MONEY_Register is
begin
	MONEY_REGISTER: process(CLK,RST)
	variable iQ:std_logic_vector(15 downto 0):="0000000000000000";
	begin
		if RST='1' then iQ:="0000000000000000";
		else if (CLK'EVENT) and (CLK='1') then
			if (Load='1') then 
				if B(4)='1' then iQ(15 downto 12):=I; end if;
				if B(3)='1' then iQ(11 downto 8):=I; end if;
				if B(2)='1' then iQ(7 downto 4):=I; end if;
				if B(1)='1' then iQ(3 downto 0):=I; end if;
			else if (Reload='1') and (I /= "0000") then
				iQ:=DIN;
			end if;
			end if;
		end if;
		end if;
		Q<=iQ;									  
		L<="0000";
		if iQ(15 downto 12)="1111" then L(3)<='1'; end if;	
		if iQ(11 downto 8)="1111" then L(2)<='1'; end if;
		if iQ(7 downto 4)="1111" then L(1)<='1'; end if;
		if iQ(3 downto 0)="1111" then L(0)<='1'; end if;
	end process MONEY_REGISTER;
end A;