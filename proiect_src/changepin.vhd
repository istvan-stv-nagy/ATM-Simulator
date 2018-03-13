library ieee;
use ieee.std_logic_1164.all;

entity changePIN is
	port(LoadPIN1: in std_logic;
	LoadPIN2: in std_logic;
	RST: in std_logic;
	I:in std_logic_vector(4 downto 1);
	B:in std_logic_vector(4 downto 1);
	CLK: in std_logic;
	Coresp: out std_logic;
	NewPIN: out std_logic_vector(15 downto 0));
end entity changePIN;

architecture A of changePIN is

signal PIN1:std_logic_vector(15 downto 0);
signal PIN2:std_logic_vector(15 downto 0);
signal aux1,aux2:std_logic;

component PIN_Register is
	port(I:in std_logic_vector(4 downto 1);
	B:in std_logic_vector(4 downto 1);
	Load:in std_logic;
	RST:in std_logic;
	CLK:in std_logic;
	Q:out std_logic_vector(15 downto 0));
end component;

component COMP_Nbit is	 
	generic(N:natural:=16);
	port(A,B: in std_logic_vector(N-1 downto 0);
	Gout,Lout,Eout:out std_logic);
end component; 

begin
	LOAD_NEW_PIN_1 : PIN_Register port map(I,B,LoadPIN1,RST,CLK,PIN1);
	LOAD_NEW_PIN_2 : PIN_Register port map(I,B,LoadPIN2,RST,CLK,PIN2);
	COMPARATOR: COMP_Nbit port map(PIN1,PIN2,aux1,aux2,Coresp);
	NewPIN <= PIN1;
end A;
