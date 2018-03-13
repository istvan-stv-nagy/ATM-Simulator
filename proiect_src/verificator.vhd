library ieee;
use ieee.std_logic_1164.all;

entity VERIFICATOR is
	port(A,B: in std_logic_vector(15 downto 0);
	r: out std_logic_vector(15 downto 0);
	s: out std_logic_vector(15 downto 0);
	ok: out std_logic);
end entity VERIFICATOR;


architecture VERIF of VERIFICATOR is

signal intCarry:std_logic_vector(0 to 2); 
signal intCorrect:std_logic_vector(0 to 2);

component VF_4bits is
	port (A,B:in std_logic_vector(3 downto 0);
	inCorrect: in std_logic;
	outCorrect: out std_logic;
	inCarry: in std_logic; 
	last_flag : in std_logic;
	outCarry: out std_logic;
	r: out std_logic_vector(3 downto 0); 
	s: out std_logic_vector(3 downto 0));
end component;

begin
	L1: VF_4bits port map(A(15 downto 12),B(15 downto 12),'1',intCorrect(0),'0','0',intCarry(0),r(15 downto 12),s(15 downto 12));
	L2: VF_4bits port map(A(11 downto 8),B(11 downto 8),intCorrect(0),intCorrect(1),intCarry(0),'0',intCarry(1),r(11 downto 8),s(11 downto 8));
	L3: VF_4bits port map(A(7 downto 4),B(7 downto 4),intCorrect(1),intCorrect(2),intCarry(1),'0',intCarry(2),r(7 downto 4),s(7 downto 4));	
	L4: VF_4bits port map(A(3 downto 0),B(3 downto 0),intCorrect(2),ok,intCarry(2),'1',open,r(3 downto 0),s(3 downto 0)); 
end VERIF;