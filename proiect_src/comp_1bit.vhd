library ieee;
use ieee.std_logic_1164.all;

entity COMP_1bit is
	port(Gin,Lin:in std_logic;
	A,B: in std_logic;
	Gout,Lout:out std_logic);
end entity COMP_1bit;

architecture A of COMP_1bit is
begin
	Gout<=(A and not B) or ((A xnor B) and Gin);
	Lout<=(not A and B) or ((A xnor B) and Lin);
end A;