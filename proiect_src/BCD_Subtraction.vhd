library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;


entity SUBTRACTION is
	port(					
	B, A:in std_logic_vector(15 downto 0);
	result:out std_logic_vector(15 downto 0)
	);
end entity SUBTRACTION;


architecture A of SUBTRACTION is  

component complement_9 is
	port(
	A:in std_logic_vector(15 downto 0);
	Q:out std_logic_vector(15 downto 0)
	);
end component;

component BCD_Adder_X is
	port(A,B:in std_logic_vector(15 downto 0);
	CIN: in std_logic;
	COUT: out std_logic;
	SUM: out std_logic_vector(15 downto 0)); 
end component; 

signal iiResult, iResult:std_logic_vector(15 downto 0);
signal iCout:std_logic;	

begin	  
	
	L1: complement_9 port map (a, iResult); 
	L5: bcd_adder_x port map (b(15 downto 0), iResult(15 downto 0), '0', iCOUT, iiResult(15 downto 0));	  
	L6: bcd_adder_x port map(iiResult,X"0000",'1',open,Result);
end;