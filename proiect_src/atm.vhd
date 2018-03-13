library ieee;
use ieee.std_logic_1164.all;

entity ATM is
	port(
	button:in std_logic_vector(4 downto 0); 
	switch: in std_logic_vector(7 downto 0); 
	CLK:in std_logic;
	A_to_G : out std_logic_vector(6 downto 0);
	aen: out std_logic_vector(3 downto 0);
	led:out std_logic_vector(7 downto 0));
end entity ATM;

--07.05.2016, ora 6:46 p.m. => sincer, eu nu mai rezist  

architecture projectATM of ATM is
-- component: COMMAND UNIT of the device
component COMMAND_UNIT is
	port(I:in std_logic_vector(4 downto 0); 
	SWITCH: in std_logic_vector(1 downto 0);
	
	CLK:in std_logic; 
	RST:in std_logic;
	CANCEL: in std_logic;
	
	Corect: in std_logic; 
	Verify_Money: in std_logic;
	PIN_2Corect: in std_logic;
	
	Wrong3: in std_logic;
	wrongCount:out std_logic;
	
	LoadPIN: out std_logic;	   
	LoadNewPin1: out std_logic;
	LoadNewPin2: out std_logic;
	LoadMONEY: out std_logic; 
	withdrawSignal:out std_logic;
	deposit:out std_logic;
	load_withdrawmoney: out std_logic;
	load_depositedMONEY: out std_logic;
	deletePIN: out std_logic;
	load_newPIN: out std_logic;	
	loadAccount : out std_logic;
	
	printReceipt:out std_logic;
	finishReceipt: in std_logic;
	receiptState: in std_logic_vector(2 downto 0);
	
	showSum:out std_logic;
	showMoney: out std_logic;
	showError: out std_logic;
	showPin: out std_logic;
	
	y:out std_logic_vector(7 downto 0));
end component COMMAND_UNIT;

--component: debouncer for the 5 buttons
component debouncer is
	port(button: in std_logic;
	clk: in std_logic;
	result: out std_logic);
end component debouncer;  

--component: PIN register used for storing the entered PIN
component PIN_Register is
	port(I:in std_logic_vector(4 downto 1);
	B:in std_logic_vector(4 downto 1);
	Load:in std_logic;
	LoadData: in std_logic;
	DIN: in std_logic_vector(15 downto 0);
	RST:in std_logic;
	CLK:in std_logic;
	Q:out std_logic_vector(15 downto 0));
end component PIN_Register; 


component withdraw is
	port(
		Switch: in std_logic_vector(3 downto 0);  
		Button:in std_logic_vector(4 downto 1); 
		ButtonC: in std_logic;
		rSum: in std_logic_vector(15 downto 0); --sum from RAM Memory
		Bills: in std_logic_vector(15 downto 0); --number of bills of each type	  
		CLK:in std_logic; 
		withdraw: in std_logic;
		RST: in std_logic; 	
		newSum:out std_logic_vector(15 downto 0);
		newBills: out std_logic_vector(15 downto 0);
		extractedBills: out std_logic_vector(15 downto 0);
		verify: out std_logic
		);
end component; 

--wrong Pin
component wrongPIN_counter is
	port(CLK:in std_logic;
	ENABLE: in std_logic;
	RST: in std_logic;
	TC:out std_logic);
end component;

--component: MONEY register used for storing the status of the ATM (number of bills)
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

--component: RAM memory used to store the correct PIN codes and the sum on them
component ramMemory is
	port(Addr:in std_logic_vector(15 downto 0);
	update: in std_logic; 
	NewSUM: in std_logic_vector(15 downto 0); 
	change: in std_logic;
	set: in std_logic;
	CLK: in std_logic;	
	C:out std_logic;
	S: out std_logic_vector(15 downto 0));
end component;

--component: changePIN
component changePIN is
	port(LoadPIN1: in std_logic;
	LoadPIN2: in std_logic;
	RST: in std_logic;
	I:in std_logic_vector(4 downto 1);
	B:in std_logic_vector(4 downto 1);
	CLK: in std_logic;
	Coresp: out std_logic;
	NewPIN: out std_logic_vector(15 downto 0));
end component;	  

--component: deposit Cash
component depositCash is
	port(CLK: in std_logic;
	RST: in std_logic;
	I: in std_logic_vector(4 downto 1);	
	B: in std_logic_vector(4 downto 1);
	Load: in std_logic;
	iSum: in std_logic_vector(15 downto 0);
	NewSum: out std_logic_vector(15 downto 0);
	Bills: in std_logic_vector(15 downto 0);
	NewBills: out std_logic_vector(15 downto 0));
end component;

--component: x7seg 7 segment BCD
component x7seg is
	port(x: in std_logic_vector(15 downto 0);
	CLK: in std_logic;
	CLR: in std_logic;
	a_to_g : out std_logic_vector(6 downto 0);
	an : out std_logic_vector(3 downto 0);	
	aen: in std_logic_vector(3 downto 0);
	dp : out std_logic);
end component; 

--component: select value to go to x7seg
component x7seg_select is
	port(show:in std_logic_vector(3 downto 0);
	value1: in std_logic_vector(15 downto 0);
	value2: in std_logic_vector(15 downto 0);
	value3: in std_logic_vector(15 downto 0); 
	value4: in std_logic_vector(15 downto 0);
	out_value: out std_logic_vector(15 downto 0);
	enable: out std_logic_vector(3 downto 0));
end component;

component receipt is
	port (CLK:in std_logic;
	RST: in std_logic;
	enable: in std_logic;
	finish:out std_logic;
	state:out std_logic_vector(2 downto 0));
end component;


--debouced buttons
signal nButton: std_logic_vector(4 downto 0); --debounced buttons

--PIN code elements
signal PINcode:std_logic_vector(15 downto 0); --pin code signal(from register to ram)
signal loadPIN_REGISTER:std_logic; --signals to the register to load the PIN
signal CU_Corect:std_logic; --signals to the command unit that a correct PIN has been entered
signal Wrong3:std_logic; -- 3 wrong pins
signal wrongCount:std_logic;-- enable count

--sum
signal iSum:std_logic_vector(15 downto 0); --the SUM on the card(expressed in BCD 16 bits)
signal loadMONEY_REGISTER:std_logic; --signals to the register to load the MONEY(update ATM)
signal atmSUM:std_logic_vector(15 downto 0); --the money in the ATM	
signal atmNewSUM:std_logic_vector(15 downto 0); --the new money in the ATM
signal atmFULL:std_logic_vector(3 downto 0); -- signals if atm is full for each type of bill
signal CU_VerifyMoney:std_logic; --signals to the command unit that the sum entered can be withdrawn 

--change pin
signal loadPIN1: std_logic;
signal loadPIN2: std_logic;
signal NEW_PIN: std_logic_vector(15 downto 0);
signal CU_Pin2Corect:std_logic; --sginals to the command unit that the second PIN is the same as the first(change PIN operation) 
signal deletePIN:std_logic;
signal loadnewPIN:std_logic;
signal loadAccount : std_logic;

--depositCash
signal enableDeposit:std_logic;
signal NewSum:std_logic_vector(15 downto 0); 
signal loadDeposit:std_logic;

signal printReceipt:std_logic;
signal finishReceipt:std_logic;
signal receiptState:std_logic_vector(2 downto 0);

--withdraw money
signal enableWithdraw: std_logic;
signal newSum_fromWithdraw: std_logic_vector(15 downto 0);
signal newBills_fromWithdraw: std_logic_vector(15 downto 0);
signal extractedBils : std_logic_vector(15 downto 0);
signal loadWithdraw:std_logic; 

--show data
signal showSum: std_logic;
signal showMoney: std_logic;
signal showError: std_logic; 
signal showPin: std_logic;
signal selData: std_logic_vector(3 downto 0);
signal segData: std_logic_vector(15 downto 0);
signal enableSeg: std_logic_vector(3 downto 0); 
     
 
begin
	BOTTON_DEBOUNCER1: debouncer port map(button(0),CLK,nButton(0));
	BOTTON_DEBOUNCER2: debouncer port map(button(1),CLK,nButton(1));
	BOTTON_DEBOUNCER3: debouncer port map(button(2),CLK,nButton(2));
	BOTTON_DEBOUNCER4: debouncer port map(button(3),CLK,nButton(3));
	BOTTON_DEBOUNCER5: debouncer port map(button(4),CLK,nButton(4));
	
	ATM_COMMAND_UNIT: COMMAND_UNIT port map(
	                                I => nButton,
									SWITCH => switch(7 downto 6),
									CLK => CLK,
									RST => switch(5),
			 						CANCEL => switch(4),
									Corect => CU_Corect,
									Verify_Money => CU_VerifyMoney,
									Pin_2Corect => CU_Pin2Corect,
									Wrong3 => Wrong3,
									wrongCount => wrongCount,
									LoadPIN => loadPIN_REGISTER,
									LoadNewPin1 => loadPIN1,
									LoadNewPin2 => loadPIN2,
									LoadMONEY => loadMONEY_REGISTER,
									withdrawSignal=> enableWithdraw,
									deposit => enableDeposit,
									load_withdrawMONEY=> loadWithdraw,
									load_depositedMONEY => loadDeposit,
									deletePIN => deletePIN,
									load_newPIN => loadnewPIN,
									loadAccount => loadAccount,
									printReceipt => printReceipt,
									finishReceipt => finishReceipt,
									receiptState => receiptState,
									showSum => showSum,
									showMoney => showMoney,
									showError => showError,
									showPin => showPin,
									y => led); 
	
	ATM_PIN_REGISTER: PIN_Register port map(switch(3 downto 0),nButton(4 downto 1),loadPIN_REGISTER,loadnewPIN,NEW_PIN,switch(5),CLK,PINcode);	
	
	--COUNT_WRONG_PINS: wrongPIN_counter port map(CLK,wrongCount,switch(5),Wrong3);
	  
	ATM_MONEY_REGISTER: MONEY_Register port map(switch(3 downto 0),nButton(4 downto 1),loadMONEY_REGISTER,loadDeposit,switch(5),CLK,atmNewSUM,atmSUM,atmFULL);	
  
	ATM_RAM_MEMORY: ramMemory port map(PINcode,loadWithdraw,NewSum_fromWithdraw,deletePIN,loadAccount,CLK,CU_Corect,iSum);	
		
	CHANGE_PIN: changePIN port map(loadPIN1,loadPIN2,switch(5),switch(3 downto 0),nButton(4 downto 1),CLK,CU_Pin2Corect,NEW_PIN);
	
	DEPOSIT_CASE: depositCash port map(CLK,switch(5),switch(3 downto 0),nButton(4 downto 1),enableDeposit,iSum,NewSum,atmSUM,atmNewSUM);

    W: withdraw port map(switch(3 downto 0),nButton(4 downto 1),nButton(0),iSum,atmSum,CLK,enableWithdraw, switch(5),newSum_fromWithdraw,newBills_fromWithdraw,extractedBils,CU_VerifyMoney);

	--PRINT_RECEIPT: receipt port map(CLK,switch(5),printReceipt,finishReceipt,receiptState);
	
	selData<=showSum & showMoney & showError & showPin;
	SELECT_VALUE_TO_SHOW: x7seg_select port map(selData,iSum,atmSum,"1110111011101110",PINcode,segData,enableSeg);
	
	SHOW_ON_SEGMENTS: x7seg port map(segData,CLK,switch(5),A_to_G,aen,enableSeg,open);
		
end projectATM;

