LIBRARY IEEE;
USE ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

PACKAGE Lib IS 
  COMPONENT Regn IS
     GENERIC( DATA_WIDTH: integer :=12);
       PORT (
	  RST, CLK: IN STD_LOGIC;
	  En: IN STD_LOGIC;
	  D: IN SIGNED(DATA_WIDTH - 1 downto 0);
	  Q: OUT SIGNED(DATA_WIDTH - 1 downto 0)
        );
     END COMPONENT;

     COMPONENT Mem IS
       GENERIC (
	  DATA_WIDTH        :     integer   := 8;                              
	  ADDR_WIDTH        :     integer   := 4
	  );

       PORT (
	  CLK               : IN  std_logic;                                   
	  Addr              : IN  STD_LOGIC_VECTOR(ADDR_WIDTH - 1 DOWNTO 0);   
	  Wen               : IN  std_logic;                                   
	  Ren               : IN  std_logic;                                  
	  Din               : IN  SIGNED(DATA_WIDTH - 1 DOWNTO 0);   
	  Dout              : OUT SIGNED(DATA_WIDTH - 1 DOWNTO 0)    
	  );
     END COMPONENT;

     COMPONENT Counter_n IS
       GENERIC( DATA_WIDTH: integer :=4);
       PORT (
	  RST, CLK: IN STD_LOGIC;
	  En: IN STD_LOGIC;
	  LD: IN STD_LOGIC;
	  D: IN UNSIGNED(DATA_WIDTH - 1 downto 0);
	  Q: OUT UNSIGNED(DATA_WIDTH - 1 downto 0)
	  );
     END COMPONENT;

     COMPONENT Datapath_SAD IS
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
     END COMPONENT;
	
     COMPONENT Controller_SAD IS
        PORT (
	  RST, CLK, Start: IN STD_LOGIC;
	  Ren_A, Ren_B, En_i, LD_i,  En_j, LD_j, En_S: OUT  STD_LOGIC;
	  Done: OUT  STD_LOGIC;
	  Zi,Zj: IN STD_LOGIC
 	  );
     END COMPONENT;

     COMPONENT SAD IS
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
     END COMPONENT;
END Lib;
