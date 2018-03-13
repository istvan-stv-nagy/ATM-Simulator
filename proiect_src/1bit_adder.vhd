library ieee;
use ieee.std_logic_1164.all;

entity ADDER_1bit is
	port(A,B,CIN:in std_logic;
	S,COUT:out std_logic);
end entity ADDER_1bit;

architecture A of ADDER_1bit is
signal INTER:std_logic;
begin
	INTER<=A xor B;
	S<=INTER xor CIN;
	COUT<=(A and B) or (CIN and INTER);
end A;