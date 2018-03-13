library ieee;
use ieee.std_logic_1164.all;

entity FULL_ADDER is
	generic (N:natural:=4);
	port(A,B:in std_logic_vector(N-1 downto 0);
	CIN:in std_logic;
	S:out std_logic_vector(N-1 downto 0);
	COUT:out std_logic);
end FULL_ADDER;

architecture A of FULL_ADDER is
signal Int:std_logic_vector(N-2 downto 0);
component ADDER_1bit is
	port(A,B,CIN:in std_logic;
	S,COUT:out std_logic);
end component;
begin
	L1: for i in 0 to N-1 generate
	L2: if i=0 generate
	L3: ADDER_1bit port map(A(i),B(0),CIN,S(i),Int(i));
	end generate;
	L4: if (i>0) and (i<N-1) generate
	L5: ADDER_1bit port map(A(i),B(i),Int(i-1),S(i),Int(i));
	end generate;
	L6: if (i=N-1) generate
	L7: ADDER_1bit port map(A(i),B(i),Int(i-1),S(i),COUT);
	end generate;
	end generate;
end A;