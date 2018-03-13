library ieee;
use ieee.std_logic_1164.all;

entity depositCash is
	port(CLK: in std_logic;
	RST: in std_logic; 
	I: in std_logic_vector(4 downto 1);	
	B: in std_logic_vector(4 downto 1);
	Load: in std_logic;
	iSum: in std_logic_vector(15 downto 0);
	NewSum: out std_logic_vector(15 downto 0);
	Bills: in std_logic_vector(15 downto 0);
	rgSum: out std_logic_vector(15 downto 0);
	NewBills: out std_logic_vector(15 downto 0));
end entity depositCash;

architecture deposit of depositCash is

signal RegSum:std_logic_vector(15 downto 0);

component MONEY_Register is
	port(I:in std_logic_vector(4 downto 1);
	B:in std_logic_vector(4 downto 1);
	Load:in std_logic;
	Reload:in std_logic;
	RST:in std_logic;
	CLK:in std_logic;
	DIN:in std_logic_vector(15 downto 0);
	Q:out std_logic_vector(15 downto 0);
	L:out std_logic_vector(3 downto 0));
end component;

component BCD_Adder_X is
	port(A,B:in std_logic_vector(15 downto 0);
	CIN: in std_logic;
	COUT: out std_logic;
	SUM: out std_logic_vector(15 downto 0)); 
end component;

component FULL_ADDER is
	generic (N:natural:=4);
	port(A,B:in std_logic_vector(N-1 downto 0);
	CIN:in std_logic;
	S:out std_logic_vector(N-1 downto 0);
	COUT:out std_logic);
end component;

begin  
	Load_Money_into_the_register: MONEY_Register port map(I,B,Load,'0',RST,CLK,"0000000000000000",RegSum,open);	
	
	Add_with_money_on_card: BCD_Adder_X port map(RegSum,iSum,'0',open,NewSum);
	
	GET_MONEY_TO_ATM_1: FULL_ADDER port map(RegSUM(3 downto 0),bills(3 downto 0),'0',open,NewBills(3 downto 0));
	
	GET_MONEY_TO_ATM_2: FULL_ADDER port map(RegSUM(7 downto 4),bills(7 downto 4),'0',open,NewBills(7 downto 4));
	
	GET_MONEY_TO_ATM_3: FULL_ADDER port map(RegSUM(11 downto 8),bills(11 downto 8),'0',open,NewBills(11 downto 8));
	
	GET_MONEY_TO_ATM_4: FULL_ADDER port map(RegSUM(15 downto 12),bills(15 downto 12),'0',open,NewBills(15 downto 12));
	
	L: rgSum<=RegSum;
	
end deposit;
	
	