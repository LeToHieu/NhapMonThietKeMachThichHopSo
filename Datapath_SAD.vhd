LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE work.Lib.all;
use IEEE.numeric_std.all;

ENTITY Datapath_SAD IS
 GENERIC (
    DATA_WIDTH        :     integer   := 8;    
    ADDR_WIDTH        :     integer   := 4;
    RowNum	      :     integer   := 3;
    ColNum	      :     integer   := 4       
    );
 PORT (
	RST, CLK, Start: IN STD_LOGIC;
	LD_i, LD_j, En_i, En_j, Ren_A, Ren_B, Wen_A, Wen_B, En_S: IN  STD_LOGIC;

	Addr: IN STD_LOGIC_VECTOR(ADDR_WIDTH - 1 downto 0);
	Data_A, Data_B: IN SIGNED(DATA_WIDTH - 1 downto 0);

	Data_out: OUT SIGNED(DATA_WIDTH + 3 downto 0);
	Zi,Zj: OUT STD_LOGIC
 );
END Datapath_SAD;

ARCHITECTURE RTL OF Datapath_SAD IS
 SIGNAL A, B: SIGNED (DATA_WIDTH - 1 downto 0);

 SIGNAL A1, B1: SIGNED (8 downto 0);

 SIGNAL A_sub_B, ABS_AB: SIGNED (DATA_WIDTH downto 0);

 SIGNAL S_in, S_out: SIGNED (DATA_WIDTH + 3 downto 0);

 SIGNAL i, j: UNSIGNED (ADDR_WIDTH - 1 downto 0);
 SIGNAL Addr_in, Addr_AB: STD_LOGIC_VECTOR(ADDR_WIDTH - 1 downto 0);

 SIGNAL i_mul_N: INTEGER range 0 to 2**ADDR_WIDTH;

 BEGIN
	
        Zi <= '0' WHEN to_integer(i) < RowNum ELSE '1';
        Zj <= '0' WHEN to_integer(j) < ColNum ELSE '1';

	i_mul_N <= to_integer(i) * ColNum;
	Addr_in <= STD_LOGIC_VECTOR(TO_UNSIGNED( i_mul_N + to_integer(j), ADDR_WIDTH));
	Addr_AB <= Addr_in WHEN Start = '1' ELSE  (Addr);
	
	
	A_sub_B <= (A(7) & A) - (B(7) & B);
	

	ABS_AB <= abs(A_sub_B);
	
	S_in <= "000"&ABS_AB + S_out;
	
	Data_out <= S_out;
	----------
	RegS: Regn
        GENERIC MAP (
            DATA_WIDTH => DATA_WIDTH + 4
        )
        PORT MAP (
            RST => RST,
            CLK => CLK,
            En => En_S,
            D => S_in,
            Q => S_out
        );

    	MemA: Mem
	GENERIC MAP (
            DATA_WIDTH => DATA_WIDTH,
	    ADDR_WIDTH => ADDR_WIDTH
        )
        PORT MAP (
            CLK => CLK,                       
   	    Addr => Addr_AB,          
    	    Wen => Wen_A,           
    	    Ren => Ren_A,         
    	    Din => Data_A,          
   	    Dout => A   
        );
	MemB: Mem
	GENERIC MAP (
            DATA_WIDTH => DATA_WIDTH,
	    ADDR_WIDTH => ADDR_WIDTH
        )
        PORT MAP (
            CLK => CLK,                       
   	    Addr => Addr_AB,          
    	    Wen => Wen_B,           
    	    Ren => Ren_B,         
    	    Din => Data_B,          
   	    Dout => B
        );
	
 	Counter_i: Counter_n
	GENERIC MAP (
            DATA_WIDTH => ADDR_WIDTH
        )
        PORT MAP (
            CLK => CLK,               
    	    RST => RST,               
    	    En => En_i,           
    	    LD => LD_i,         
    	    D => (others=>'0'),          
   	    Q => i  
        );
	
	Counter_j: counter_n
	GENERIC MAP (
            DATA_WIDTH => ADDR_WIDTH
        )
        PORT MAP (
            CLK => CLK,               
    	    RST => RST,               
    	    En => En_j,           
    	    LD => LD_j,         
    	    D => (others=>'0'),      
   	    Q => j  
        );
 END RTL;
