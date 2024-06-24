
LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Counter_n IS
 GENERIC( DATA_WIDTH: integer :=4);
 PORT (
	RST, CLK: IN STD_LOGIC;
	En: IN STD_LOGIC;
	LD: IN STD_LOGIC;
	D: IN UNSIGNED(DATA_WIDTH - 1 downto 0);
	Q: OUT UNSIGNED(DATA_WIDTH - 1 downto 0)
 );
END Counter_n;

ARCHITECTURE RTL OF Counter_n IS
SIGNAL count: UNSIGNED(DATA_WIDTH - 1 downto 0):=(others => '0');
 BEGIN
	PROCESS (RST, CLK)
	BEGIN
	 IF(RST = '1') THEN
	 	count <= (OTHERS => '0');
	 ELSIF(CLK'EVENT and CLK = '1') THEN
		IF( LD = '1') THEN
			count <= D;
		ELSIF( En = '1') THEN
			count <= count+1;
		END IF;
	 END IF;
	END PROCESS;
	Q <= count;
 END RTL;