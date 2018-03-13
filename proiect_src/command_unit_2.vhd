library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; 
use ieee.std_logic_arith.all;

entity COMMAND_UNIT is
	port(I:in std_logic_vector(4 downto 0); 
	SWITCH: in std_logic_vector(1 downto 0);
	
	CLK:in std_logic;
	RST:in std_logic;
	CANCEL: in std_logic;
	
	Corect: in std_logic; 
	Verify_Money: in std_logic;
	PIN_2Corect: in std_logic;
	
	LoadPIN: out std_logic;	   
	LoadNewPin1: out std_logic;
	LoadNewPin2: out std_logic;
	LoadMONEY: out std_logic; 
	deposit:out std_logic;
	load_depositedMONEY: out std_logic;
	
	showSum:out std_logic;
	showMoney: out std_logic;
	showError: out std_logic;
	
	y:out std_logic_vector(7 downto 0));
end entity COMMAND_UNIT;

architecture A of COMMAND_UNIT is  

type STATE is (	Standby,
				LoadATM,
				Waiting,
				IntroducePIN,countWrongPIN,
				ChooseOperation,
				Withdraw,W1,
				checkBalance,
				changePIN1,changePIN2,verifyPIN,
				DepositMONEY,DepositLoad,
				Receipt,
				moreOperations);

signal current_state,next_state:STATE;
signal count_tries:std_logic_vector(1 downto 0):="00";

begin
CLC: process(I, SWITCH, current_state)
begin 
	 case current_state is
		when Standby => if I(0) = '1' then
							next_state <= loadATM;
						else
							next_state <= Standby;
						end if; 
		when loadATM => if SWITCH(1) = '1' then 
							next_state <= Waiting;
						else
							next_state <= loadATM;
						end if;					 
		when Waiting =>  if I(0) = '1' then
							next_state <= IntroducePIN;	
						else
							next_state <= Waiting;
						end if;
		when IntroducePIN => if I(0)='1' then
								if Corect='1' then next_state<=ChooseOperation; count_tries<="00";
								else count_tries<=count_tries+1; next_state<=countWrongPIN; 
							end if;
						else next_state<=IntroducePIN;
						end if;	
		when countWrongPIN => if I(1)='1' then next_state<=IntroducePIN;
							  else next_state<=countWrongPIN;
							  end if;	
		when ChooseOperation => if I(1)='1' then next_state<=Withdraw;
								elsif I(2)='1' then next_state<=checkBalance;
								elsif I(3)='1' then next_state<=changePIN1;
								elsif I(4)='1' then next_state<=depositMONEY;
								else next_state<=ChooseOperation;
								end if;
		when Withdraw =>if I(0)='1' then next_state<=W1; 
						else next_state<=Withdraw; end if;
		when W1 => if Verify_Money='1' then next_state<=Receipt; 
				   else next_state<=Withdraw; end if;
		when checkBalance => if I(0)='1' then next_state<=Receipt; 
							 else next_state<=checkBalance; end if;
		when changePIN1 => if I(0)='1' then next_state<=changePIN2; 
		                   else next_state<=changePIN1; end if;	
		when changePIN2 => if I(0)='1' then next_state<=verifyPIN; else next_state<=changePIN2; end if;
		when verifyPIN =>  if PIN_2Corect='1' then next_state<=moreOperations; else next_state<=changePIN1; end if;
		when depositMONEY => if I(0)='1' then next_state<=DepositLoad; else next_state<=depositMONEY; end if;	
		when DepositLoad =>next_state<=Receipt;
		when Receipt => if I(0)='1' then next_state<=moreOperations; else next_state<=Receipt; end if; 
		when moreOperations =>  if SWITCH(1)='1' then next_state<=ChooseOperation; elsif SWITCH(0)='1' then next_state<=Waiting; else next_state<=moreOperations; end if;
		when others => next_state<=Standby;
		end case;		
	end process CLC;
	
SLC: process(CLK, RST, CANCEL)
	begin				  
	if RST = '1' then  
		current_state <= Standby;
	elsif CANCEL = '1' then
		current_state <= Waiting;
	else
	if CLK'EVENT and CLK = '1' then	
	LoadMONEY<='0';
	LoadPIN<='0';
	LoadNewPin1<='0';
	LoadNewPin2<='0';  
	deposit<='0'; 
	load_depositedMONEY<='0';
	showSum<='0'; showMoney<='0'; showError<='0';
	 case current_state is
		when Standby => y<="00000000";  
		 
		when loadATM => y<="01000010";  
						showMoney<='1';
					    LoadMONEY<='1';
											 
		when Waiting => y<="00000001";  
						
		when IntroducePIN => y<="00000010";
		                y(7 downto 6)<=count_tries;  
						LoadPIN <= '1';
		
		when ChooseOperation => y<="00000100";
						
		when Withdraw => y<="00001000";
					
		when W1 => y<="00001000";
				  
		when checkBalance => y<="00010000";
							 showSum<='1';
							
		when changePIN1 => y<="00100000"; 
						   LoadNewPin1<='1'; 
						  
		when changePIN2 => y<="00100000";
						   LoadNewPin2<='1';
				
		when verifyPIN =>  y<="00100000";
					
		when depositMONEY => y<="01000000"; 
							 deposit<='1';
							
		when DepositLoad => y<="01000000"; 
							load_depositedMONEY <= '1';
		  
		when Receipt => y<="10000000"; 
						
		when moreOperations => y<="10101010"; 
							  
		when others => y<="00000000";
		end case;
			current_state <= next_state;
		end if;
	end if;
	end process SLC;
end A;
				