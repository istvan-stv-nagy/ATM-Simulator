library ieee; 
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity verifier is
	port(
		rSum: in std_logic_vector(15 downto 0);
		eSum: in std_logic_vector(15 downto 0);
		verify:out std_logic);
end entity verifier;


architecture A of verifier is
begin
	process(check, rSum, eSum)  
	variable iVerify:std_logic;
	begin
		if (rSum>eSum) and (eSum<="0001000000000000") then iVerify:='1';
		else iVerify:='0';
		end if;
		verify<=iVerify;
	end process;
end A;