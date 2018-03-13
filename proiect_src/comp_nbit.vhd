library ieee;
use ieee.std_logic_1164.all;

entity COMP_Nbit is	 
	generic(N:natural:=16);
	port(A,B: in std_logic_vector(N-1 downto 0);
	Gout,Lout,Eout:out std_logic);
end entity COMP_Nbit;

architecture A of COMP_Nbit is 
component COMP_1bit is
	port(Gin,Lin:in std_logic;
	A,B: in std_logic;
	Gout,Lout:out std_logic);
end component;

signal intG:std_logic_vector(N-1 downto 0);	
signal intL:std_logic_vector(N-1 downto 0);

begin
	L1:for i in 0 to N-1 generate
	L2:	if i=0 generate
	L3:		COMP_1bit port map('0','0',A(i),B(i),intG(i),intL(i));
		end generate;
	L4:	if i>0 generate
	L5:		COMP_1bit port map(intG(i-1),intL(i-1),A(i),B(i),intG(i),intL(i));
		end generate;
	end generate;
	Eout<=intG(N-1) xnor intL(N-1);	
	Gout<=intG(N-1);
	Lout<=intL(N-1);
end A;