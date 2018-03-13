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
	
	Corect: in std_logic; --checks if the entered PIN is correct
	Verify_Money: in std_logic; --checks if the entered sum can be withdrawn
	PIN_2Corect: in std_logic; --checks if, when changing PIN, the second PIN is equal to the first one
	
	Wrong3: in std_logic; --shows that the maximum number of wrong PINs that can be entered(precisely, 3) was reached
	wrongCount:out std_logic; --counts how many times the user entered a wrong PIN(count enable)
	
	LoadPIN: out std_logic;	 --semnal pentru starea de introducere PIN  
	LoadNewPin1: out std_logic; --semnal pentru starea de change PIN, primul PIN introdus fiind incarcat in registrii
	LoadNewPin2: out std_logic; --semnal pentru starea de change PIN, al doilea PIN introdus fiind incarcat in registrii
	LoadMONEY: out std_logic; --semnal pentru starea de incarcare a casei
	withdrawSignal:out std_logic; --semnal pentru starea de retragere de numerar
	deposit:out std_logic; --semnal pentru starea de depunere de numerar
	load_withdrawmoney: out std_logic; --semnal pentru starea de update a memoriei RAM dupa retragerea de numerar(10)
	load_depositedMONEY: out std_logic; --semnal pentru starea de update a memoriei RAM dupa depunerea de numerar (01)
	deletePIN: out std_logic; --semnal pentru starea de stergere a PIN-ului utilizatorului in cazul in care s-a executat operatia de change PIN
	load_newPIN: out std_logic;	--semnal pentru starea de incarcare a noului PIN in 
	loadAccount : out std_logic;
	
	printReceipt:out std_logic; --semnalul pentru starea de printare a chitantei
	finishReceipt: in std_logic; --primeste 1 cand utilizatorul apasa pe un fel de ok
	receiptState: in std_logic_vector(2 downto 0); --genereaza jocul cu ledurile de la printarea chitantei
	
	showSum:out std_logic; --printeaza pe 7 segmente suma de pe card la interogare sold 
	showMoney: out std_logic; --printeaza pe 7 segmente bancnotele introduse la incarcarea casei, in timp real
	showError: out std_logic; --printeaza pe 7 segmente daca PIN-ul introdus de utilizator e gresit
	showPin: out std_logic; --printeaza pe 7 segmente PIN-ul pe care il introduce utilizator, in timp real
	
	y:out std_logic_vector(7 downto 0));
end entity COMMAND_UNIT;

architecture A of COMMAND_UNIT is  

type STATE is (	Standby,
				LoadATM,
				Waiting,
				IntroducePIN,wrongPIN,errorPIN,
				ChooseOperation,
				WithdrawState,Verification,updateRAM,
				checkBalance,
				changePIN1,changePIN2,verifyPIN,removePIN,setPIN,setAccountInfo,
				DepositMONEY,DepositLoad,
				Receipt,printingReceipt,
				moreOperations);

signal current_state,next_state:STATE; -- de ce am ales sa fie semnale?

begin

CLC: process(I, current_state,SWITCH)
begin
    --initializam toate semnalele de tip out cu '0'  
    withdrawSignal<='0'; 
    load_withdrawMONEY<='0';
	LoadMONEY<='0';
	LoadPIN<='0';
	LoadNewPin1<='0';
	LoadNewPin2<='0'; 
	deposit<='0'; 
	load_depositedMONEY<='0';
	deletePIN<='0';
	load_newPIN<='0';
	loadAccount <= '0';
	wrongCount<='0';
	printReceipt<='0';
	showSum<='0'; showMoney<='0'; showError<='0'; showPin<='0';
	case current_state is
		when Standby => y<="00000000";  
						if I(0) = '1' then
							next_state <= loadATM;
						else
							next_state <= Standby;
						end if; 
		when loadATM => y<="01000010";  
						showMoney<='1';
					    LoadMONEY<='1';
						if SWITCH(1) = '1' then 
							next_state <= Waiting;
						else
							next_state <= loadATM;
						end if;					 
		when Waiting => y<="00000001";  
						if I(0) = '1' then
							next_state <= IntroducePIN;	
						else
							next_state <= Waiting;
						end if;
		when IntroducePIN => y<="00000010";
		                showPin<='1';
						LoadPIN <= '1'; 
						if SWITCH(1)='1' then
							if Corect='1' then next_state<=ChooseOperation;
							              else next_state<=wrongPIN;
							end if;
						else next_state<=IntroducePIN;
						end if; 
		when wrongPIN => wrongCount<='1';
						 next_state<=errorPIN;
		when errorPIN => showError<='1';
						 if Wrong3='1' then next_state<=Waiting;
		                 elsif I(1)='1' then next_state<=IntroducePIN;
		                 elsif I(3)='1' then next_state<=Waiting;
		                 else next_state<=errorPIN;
		                 end if;		
		when ChooseOperation => y<="00000100";
								if I(1)='1' then next_state<=WithdrawState;
								elsif I(2)='1' then next_state<=checkBalance;
								elsif I(3)='1' then next_state<=changePIN1;
								elsif I(4)='1' then next_state<=depositMONEY;
								else next_state<=ChooseOperation;
								end if;
		--when WithdrawState => y<="00001000";
		                      --withdrawSignal<='1';
						     -- if I(0)='1' then next_state<=W1; 
						                 -- else next_state<=WithdrawState; end if;
		--when W1 => y<="00001111";
		           --withdrawSignal<='1';
				   --if Verify_Money='1' then next_state<=updateRAM; 
				  -- else next_state<=WithdrawState; end if;
		when WithdrawState => y<= "00001000";
		                      withdrawSignal<='1';
		                      if I(0)='1' then next_state<=Verification;
		                      else next_state<= WithdrawState;
		                      end if;
		when Verification => y<= "00001000";
		                     if Verify_money='1' then next_state<=updateRam;
		                     else next_state<= moreOperations;
		                     end if;
		--when WithdrawState => y<= "00001000";
		                    --  withdrawSignal<='1';
		                    -- if Verify_Money='1' then next_state<=updateRAM;
		                     --else next_state <= WithdrawState;
		                     -- end if;
		when updateRAM => y<="00001000";
		                  load_withdrawMONEY <= '1';
		                  next_state<=Receipt;
		when checkBalance => y<="00010000";
							 showSum<='1';
							 if I(0)='1' then next_state<=Receipt; 
							 else next_state<=checkBalance; end if;
		when changePIN1 => y<="00100000"; 
						   LoadNewPin1<='1';
						   y(2 downto 0)<=Pin_2Corect&"01"; 
						   if I(0)='1' then next_state<=changePIN2; 
		                   else next_state<=changePIN1; end if;	
		when changePIN2 => y<="00100000";
		                   LoadNewPin2<='1';
		                   y(2 downto 0)<=Pin_2Corect&"10";
						   if I(0)='1' then next_state<=verifyPIN; else next_state<=changePIN2; end if;
		when verifyPIN =>  y<="00100000";
						   if PIN_2Corect='1' then next_state<=removePIN; else next_state<=changePIN1; end if;	 
		when removePIN => y<="00100000";
						   deletePIN <='1';
						   next_state<=setPIN;
	    when setPIN => y<="00100000";
	                   load_newPIN<='1';
	                   next_state<=setAccountInfo;
	    when setAccountInfo => y<="00100000";
	                           loadAccount <= '1';
	                           next_state <= chooseOperation;
		when depositMONEY => y<="01000000"; 
							 deposit<='1';
						   	 if I(0)='1' then next_state<=DepositLoad; else next_state<=depositMONEY; end if;	
		when DepositLoad => y<="01000000"; 
							load_depositedMONEY <= '1';
		                    next_state<=Receipt;
		when Receipt => y<="10000000";
						if I(1)='1' then next_state<=printingReceipt;
						elsif I(3)='1' then next_state<=moreOperations;
						else next_state<=Receipt;
						end if;
		when printingReceipt => y<="00000000";
                                y(conv_integer(receiptState))<='1';
                                printReceipt<='1';
                                if finishReceipt='1' then next_state<=moreOperations; else next_state<=printingReceipt; end if;
		when moreOperations => y<="10101010"; 
							   if SWITCH(1)='1' then next_state<=ChooseOperation; elsif SWITCH(0)='1' then next_state<=Waiting; else next_state<=moreOperations; end if;
		when others => next_state<=Standby;
		end case;		
	end process CLC;
	
	
SLC: process(CLK, RST, CANCEL)
	begin				  
	if RST = '1' then  
		current_state <= Standby;
	elsif CANCEL = '1' then
		current_state <= loadATM; --nu trebuia in waiting?
	else
		if CLK'EVENT and CLK = '1' then
			current_state <= next_state;
		end if;
	end if;
	end process SLC;
end A;
				