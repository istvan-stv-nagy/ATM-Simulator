library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity complement_9 is
	port(
	A:in std_logic_vector(15 downto 0);
	Q:out std_logic_vector(15 downto 0)
	);
end entity complement_9;


architecture A of complement_9 is
begin
	COMPLEMENT:process(A)
	variable iQ:std_logic_vector(15 downto 0);
	begin 
		iQ(15 downto 12):=A(15 downto 12);
		iQ(15 downto 12):=not(iQ(15 downto 12))+"1010";	
		
		iQ(11 downto 8):=A(11 downto 8);
		iQ(11 downto 8):=not(iQ(11 downto 8))+"1010";
		
		iQ(7 downto 4):=A(7 downto 4);
		iQ(7 downto 4):=not(iQ(7 downto 4))+"1010";	 
		
		iQ(3 downto 0):=A(3 downto 0);
		iQ(3 downto 0):=not(iQ(3 downto 0))+"1010";
		
		Q<=iQ;
	end process;
end architecture A;