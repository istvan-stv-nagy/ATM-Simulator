library ieee;
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity ramMemory is
	port(Addr:in std_logic_vector(15 downto 0);
	update: in std_logic; 
	NewSUM: in std_logic_vector(15 downto 0); 
	change: in std_logic;
	set: in std_logic;
	CLK: in std_logic;	
	C:out std_logic;
	S: out std_logic_vector(15 downto 0));
end entity ramMemory;

architecture A of ramMemory is

signal account:std_logic_vector(16 downto 0);

type T is array(0 to 9999) of std_logic_vector(16 downto 0);
signal MMap:T:=(1996=>"10011100100100101",
	2016=>"10000100010000100",	
	4687=>"10111100001000000",
	5885=>"10000000001110101",
	6333=>"10000000000000011",
	7982=>"10000000010000000",
	9112=>"10111011100010000",
				others=>"00000000000000000");

begin
	MEMORY: process(CLK)
	variable digit1,digit2,digit3,digit4:INTEGER; 
	variable result:std_logic_vector(16 downto 0);	
	variable index:INTEGER;
	begin
		digit4:=CONV_INTEGER(Addr(15 downto 12));
		digit3:=CONV_INTEGER(Addr(11 downto 8));
		digit2:=CONV_INTEGER(Addr(7 downto 4));
		digit1:=CONV_INTEGER(Addr(3 downto 0));	  
		index := digit4*1000+digit3*100+digit2*10+digit1; 
		if (CLK'EVENT) and (CLK='1') then
			if update='1' then MMap(index)<='1' & NewSUM; result:='1' & NewSUM;	
			elsif change='1' then account<=MMap(index); MMap(index)<=(others=>'0'); result:=(others=>'0');
			elsif set ='1' then MMap(index)<=account; result:=account;
			else result:=MMap(index);
			end if; 
		end if;
		C<=result(16);
		S<=result(15 downto 0);  
	end process MEMORY;
end A;
			
		