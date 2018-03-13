library ieee;
use ieee.std_logic_1164.all;

entity BCD_Adder_X is
	port(A,B:in std_logic_vector(15 downto 0);
	CIN: in std_logic;
	COUT: out std_logic;
	SUM: out std_logic_vector(15 downto 0)); 
end entity;

architecture adder of BCD_Adder_X is
component BCD_Adder_4bits is
	port(A,B: in std_logic_vector(3 downto 0);
	CIN: in std_logic;
	COUT: out std_logic;
	SUM: out std_logic_vector(3 downto 0));
end	component;
signal iCout:std_logic_vector(2 downto 0);
begin
	L1: BCD_Adder_4bits port map(A(3 downto 0),B(3 downto 0),CIN,iCout(0),SUM(3 downto 0));
	L2: BCD_Adder_4bits port map(A(7 downto 4),B(7 downto 4),iCout(0),iCout(1),SUM(7 downto 4)); 
	L3: BCD_Adder_4bits port map(A(11 downto 8),B(11 downto 8),iCout(1),iCout(2),SUM(11 downto 8));	  
	L4: BCD_Adder_4bits port map(A(15 downto 12),B(15 downto 12),iCout(2),COUT,SUM(15 downto 12));
end adder;
