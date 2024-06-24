LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE work.Lib.all;

ENTITY SAD IS
 GENERIC (
    DATA_WIDTH        :     integer   := 8;    
    ADDR_WIDTH        :     integer   := 4;                              
    RowNum	      :     integer   := 3;
    ColNum	      :     integer   := 4     
    );
 PORT (
	RST, CLK, Start: IN STD_LOGIC;

	Data_A, Data_B: IN SIGNED(DATA_WIDTH - 1 downto 0);
	Wen_A, Wen_B: IN  STD_LOGIC;
	Addr: IN STD_LOGIC_VECTOR(ADDR_WIDTH - 1 downto 0);
	
	Done, Ren: OUT STD_LOGIC;
	Data_out: OUT SIGNED(DATA_WIDTH + 3 downto 0)
 );
END SAD;

ARCHITECTURE RTL OF SAD IS
 SIGNAL Ren_A, Ren_B, En_i, LD_i,  En_j, LD_j, En_S, Zi,Zj: STD_LOGIC;
 BEGIN
 CTRL_UNIT: Controller_SAD
 PORT MAP (
	RST => RST, 
	CLK => CLK, 
	Start => Start,
	Ren_A => Ren_A, 
	Ren_B => Ren_B, 
	En_i => En_i, 
	LD_i => LD_i,  
	En_j => En_j, 
	LD_j => LD_j, 
	En_S => En_S,
	Done => Done,
	Zi => Zi,
	Zj => Zj
 );
 Datapath_unit: Datapath_SAD 
 GENERIC MAP( DATA_WIDTH, ADDR_WIDTH, RowNum, ColNum)
 PORT MAP(
    	RST => RST, 
	CLK => CLK, 
	Start => Start,
	LD_i => LD_i, 
	LD_j => LD_j, 
	En_i => En_i, 
	En_j => En_j, 
	Ren_A => Ren_A, 
	Ren_B => Ren_B, 
	Wen_A => Wen_A, 
	Wen_B => Wen_B, 
	En_S => En_S,

	Addr => Addr,
	Data_A => Data_A,
	Data_B => Data_B,
	Data_out => Data_out,
	Zi => Zi,
	Zj => Zj
 );
 END RTL;