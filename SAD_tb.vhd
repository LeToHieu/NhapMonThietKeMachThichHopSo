LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE work.Lib.all;
use IEEE.numeric_std.all;

ENTITY SAD_tb IS
 
END SAD_tb;


ARCHITECTURE BEV OF SAD_tb IS
 Constant DATA_WIDTH        :     integer   := 8;
 Constant ADDR_WIDTH        :     integer   := 4;   
 Constant RowNum	    :     integer   := 3;
 Constant ColNum	    :     integer   := 4;   

 TYPE MATRIX_ARRAY IS ARRAY (NATURAL RANGE <>) OF SIGNED(DATA_WIDTH - 1 DOWNTO 0);
 Constant  A      :    MATRIX_ARRAY(0 TO (RowNum*ColNum) - 1) := ( TO_SIGNED(19,8), TO_SIGNED(0,8), TO_SIGNED(11,8), 
									   TO_SIGNED(11,8), TO_SIGNED(98,8), TO_SIGNED(109,8) ,
									   TO_SIGNED(0,8) ,TO_SIGNED(1,8) ,TO_SIGNED(19,8), 
									   TO_SIGNED(23,8), TO_SIGNED(122,8), TO_SIGNED(-56,8));  
 Constant  B      :    MATRIX_ARRAY(0 TO (RowNum*ColNum) - 1) := ( TO_SIGNED(3,8), TO_SIGNED(-127,8), TO_SIGNED(121,8), 
									   TO_SIGNED(-122,8), TO_SIGNED(24,8), TO_SIGNED(89,8) ,
									   TO_SIGNED(112,8) ,TO_SIGNED(21,8) ,TO_SIGNED(94,8), 
									   TO_SIGNED(63,8), TO_SIGNED(52,8), TO_SIGNED(116,8));
      
 SIGNAL RST, CLK, Start: STD_LOGIC;
 SIGNAL Data_A, Data_B: SIGNED(DATA_WIDTH - 1 downto 0);
 SIGNAL Wen_A, Wen_B: STD_LOGIC;

 SIGNAL Addr: STD_LOGIC_VECTOR(ADDR_WIDTH - 1 downto 0);
 SIGNAL Data_out: SIGNED(DATA_WIDTH + 3 downto 0);
 SIGNAL Done, Ren: STD_LOGIC;
	
 BEGIN
  DUT: SAD
  GENERIC MAP( DATA_WIDTH, ADDR_WIDTH, RowNum, ColNum)
  PORT MAP (
	RST => RST, 
	CLK => CLK, 
	Start => Start,
	Data_A => Data_A, 
	Data_B => Data_B,
	Wen_A => Wen_A, 
	Wen_B => Wen_B,
	Addr => Addr,
	
	Done => Done, 
	Ren => Ren,
	Data_out => Data_out
  );

 CLK_signal: PROCESS
 BEGIN
	CLK <= '1'; Wait for 5 ns;
	CLK <= '0'; Wait for 5 ns;
 END PROCESS;

 Stimulus: PROCESS
 BEGIN
	Start <= '0'; 	
	RST <= '1'; Wait for 10 ns;
	RST <= '0'; Wait for 10 ns;
	FOR i IN 0 TO 11 LOOP
	
	Addr <= std_logic_vector(TO_UNSIGNED(i, ADDR_WIDTH));
	Data_A <= A(i);
	Data_B <= B(i);
	Wen_A <= '1';
	Wen_B <= '1';
	wait until(CLK'EVENT and CLK = '1');
	Wait for 5 ns;
	END LOOP;
	
	Wen_A <= '0';
	Wen_B <= '0';
	Wait for 10 ns;
	
	Start <= '1';
	wait until Done = '1';
	Wait for 10 ns;

	wait;
 	END PROCESS;
 END BEV;
