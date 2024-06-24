LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Mem IS
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
END Mem;

ARCHITECTURE RTL OF Mem IS
  TYPE MEM_ARRAY IS ARRAY (natural RANGE <>) OF SIGNED(DATA_WIDTH - 1 DOWNTO 0); 
  SIGNAL   M          :     MEM_ARRAY(0 TO (2**ADDR_WIDTH) - 1) := (OTHERS => (OTHERS => '0'));  

BEGIN 
  PROCESS (CLK)
  BEGIN 
    IF (CLK'EVENT AND CLK = '1') THEN   
      IF Wen = '1' THEN
        M(to_integer( UNSIGNED( Addr))) <= Din; 
      ELSIF Ren = '1' THEN 
       Dout <= M(to_integer( UNSIGNED ( Addr)));
      END IF;
    END IF;
  END PROCESS;
END RTL;
