library ieee;
use ieee.std_logic_1164.all;

entity BCD_Adder_4bits is
	port(A,B: in std_logic_vector(3 downto 0);
	CIN: in std_logic;
	COUT: out std_logic;
	SUM: out std_logic_vector(3 downto 0));
end entity;

architecture adder of BCD_Adder_4bits is
component FULL_ADDER is
	generic (N:natural:=4);
	port(A,B:in std_logic_vector(N-1 downto 0);
	CIN:in std_logic;
	S:out std_logic_vector(N-1 downto 0);
	COUT:out std_logic);
end component;
signal iSum:std_logic_vector(3 downto 0);
signal iCout:std_logic;
signal plus:std_logic_vector(3 downto 0);
begin
	BINARY_ADDITION: FULL_ADDER port map(A,B,CIN,iSum,iCout);
	
	EVALUATE: process(iCout,iSum)
	begin
		if (iCout='1') then plus<="0110"; COUT<='1';
		else 
			case iSum is
				when "1010" | "1011" | "1100" | "1101" | "1110" | "1111" =>plus<="0110"; COUT<='1';
				when others => plus<="0000"; COUT<='0';
			end case;
		end if;
	end process;
	
	BCD_ADDITION: FULL_ADDER port map(iSum,plus,'0',SUM,open);
end adder;