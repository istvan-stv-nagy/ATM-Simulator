library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity x7seg is
	port(x: in std_logic_vector(15 downto 0);
	CLK: in std_logic;
	CLR: in std_logic;
	a_to_g : out std_logic_vector(6 downto 0);
	an : out std_logic_vector(3 downto 0);	
	aen: in std_logic_vector(3 downto 0);
	dp : out std_logic);
end entity x7seg;

architecture A of x7seg is
signal s: std_logic_vector(1 downto 0);
signal digit: std_logic_vector(3 downto 0);
signal clkdiv: std_logic_vector(18 downto 0);
begin
	s<=clkdiv(18 downto 17);  
	dp<='1';
	
	MUX4_1: process(s,x)
	begin
		case s is
			when "00" => digit<=x(3 downto 0);
			when "01" => digit<=x(7 downto 4);
			when "10" => digit<=x(11 downto 8);
			when others => digit<=x(15 downto 12);
		end case;
	end process;
	
	hex7seg: process(digit)
	begin
	case digit is 
		when "0000" =>a_to_g<="0000001";
		when "0001" =>a_to_g<="1001111";
		when "0010" =>a_to_g<="0010010";
		when "0011" =>a_to_g<="0000110";
		when "0100" =>a_to_g<="1001100";
		when "0101" =>a_to_g<="0100100";
		when "0110" =>a_to_g<="0100000";
		when "0111" =>a_to_g<="0001111";
		when "1000" =>a_to_g<="0000000";
		when "1001" =>a_to_g<="0000100";
		when "1010" =>a_to_g<="0001000";
		when "1011" =>a_to_g<="1100000";
		when "1100" =>a_to_g<="0110001";
		when "1101" =>a_to_g<="1000010";
		when "1110" =>a_to_g<="0110000";
		when others =>a_to_g<="0111000"; 
	end case;
	end process;
	
	digit_select: process(s,aen)
	begin
		an<="1111";
		if (aen(conv_integer(s))='1') then
			an(conv_integer(s))<='0';
		end if;
	end process;
	
	clock_divider: process(clk,clr)
	begin
		if clr='1' then
			clkdiv<= (others => '0');
		else if (CLK'EVENT) and (CLK='1') then
			clkdiv<=clkdiv +1;
		end if;
		end if;
	end process;
end A;