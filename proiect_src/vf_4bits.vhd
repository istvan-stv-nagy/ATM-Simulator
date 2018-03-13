library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity VF_4bits is
	port (A,B:in std_logic_vector(3 downto 0);
	inCorrect: in std_logic;
	outCorrect: out std_logic;
	inCarry: in std_logic; 
	last_flag : in std_logic;
	outCarry: out std_logic;
	r: out std_logic_vector(3 downto 0); 
	s: out std_logic_vector(3 downto 0));
end entity VF_4bits;

architecture verify of VF_4bits is
begin
	VERIF: process(A,B,inCarry,inCorrect)
	variable x,y:std_logic_vector(3 downto 0); 
	variable error:std_logic;
	begin 
		x:=A; y:=B; error:='0';
		if inCorrect = '0' then outCorrect<='0';
		else
			if inCarry='1' then
				if (y<="0101") then y:=y+"1010";
				else error:='1';
				end if;
			end if;
			
			if (error='1') then outCorrect<='0';
			else
				if (last_flag='1' and y>x) then outCorrect<='0'; s<="0000"; r<="0000"; 
				else
					if (x>=y) then s<=y; r<=x-y; outCorrect<='1'; outCarry<='0';
					elsif (y = x+1 and last_flag='0') then s<=x; r<="0000"; outCorrect<='1'; outCarry<='1';
					else s<="0000"; r<=x; outCorrect<='0'; outCarry<='0';
					end if;	
				end if;
			end if;
			
		end if;
	end process;
end verify;
	