library ieee;
use ieee.std_logic_1164.all;

entity x7seg_select is
	port(show:in std_logic_vector(2 downto 0);
	value1: in std_logic_vector(15 downto 0);
	value2: in std_logic_vector(15 downto 0);
	value3: in std_logic_vector(15 downto 0); 
	out_value: out std_logic_vector(15 downto 0);
	enable: out std_logic_vector(3 downto 0));
end entity x7seg_select;

architecture selectValue of x7seg_select is
begin
	SEL: process(show,value1,value2,value3)
	begin
		case show is
			when "100" => out_value<=value1; enable<="1111";
			when "010" => out_value<=value2; enable<="1111";
			when "001" => out_value<=value3; enable<="1111";
			when others => out_value<=value1; enable<="0000";
		end case;
	end process;
end selectValue;