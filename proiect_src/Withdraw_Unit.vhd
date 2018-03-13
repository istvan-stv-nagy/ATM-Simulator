library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity withdraw is
	port(
		Switch: in std_logic_vector(3 downto 0); --folosite pentru introducerea sumei cerute 
		Button:in std_logic_vector(4 downto 1);
		ButtonC: in std_logic;
		rSum: in std_logic_vector(15 downto 0); --suma care ramane pe card dupa extragere
		Bills: in std_logic_vector(15 downto 0); --numarul de bancnote de diferite valori	  
		CLK:in std_logic; 
		withdraw: in std_logic; --load pentru registrul care contine suma extrasa
		RST: in std_logic; 	
		newSum:out std_logic_vector(15 downto 0); -- suma pe card dupa extragere
		newBills: out std_logic_vector(15 downto 0); -- bancnotele dupa extragere
		extractedBills: out std_logic_vector(15 downto 0); --bancnotele emise 
		outSum: out std_logic_vector(15 downto 0); -- continutul registrului care contine suma extrasa    
		check: out std_logic -- verifica daca suma ceruta poate fi extrasa
		verify: out std_logic
		);
end entity withdraw;


architecture A of withdraw is

component  register_bcd is
	port(I:in std_logic_vector(4 downto 1);
	B:in std_logic_vector(4 downto 1);
	Load:in std_logic;
	Reload:in std_logic;
	RST:in std_logic;
	CLK:in std_logic;
	DIN:in std_logic_vector(15 downto 0);
	Q:out std_logic_vector(15 downto 0));
end component;

--------------------------------------------------------

component VERIFICATOR is
	port(A,B: in std_logic_vector(15 downto 0);
	r: out std_logic_vector(15 downto 0);
	s: out std_logic_vector(15 downto 0);
	ok: out std_logic);
end component; 

---------------------------------------------------------

component verifier is
	port(
		rSum: in std_logic_vector(15 downto 0);
		eSum: in std_logic_vector(15 downto 0);
		verify:out std_logic);
end component;

---------------------------------------------------------

component SUBTRACTION is
	port(					
	B, A:in std_logic_vector(15 downto 0);
	result:out std_logic_vector(15 downto 0)
	);
end component; 

--------------------------------------------------------

signal eSum: std_logic_vector(15 downto 0);					   			

begin
	L1: register_bcd port map (Switch, Button, withdraw, '0', RST, CLK, "0000000000000000", eSum);
	L2: verificator port map(Bills, eSum, newBills, extractedBills, check);
	L3: Verifier port map( rSum, eSum, verify);
	L4: SUBTRACTION port map (rSum, eSum, newSum);
	L5: outSum<=eSum;
end;
