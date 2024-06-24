LIBRARY IEEE;
USE ieee.std_logic_1164.all;

ENTITY Controller_SAD IS
 PORT (
	RST, CLK, Start: IN STD_LOGIC;
	Ren_A, Ren_B, En_i, LD_i,  En_j, LD_j, En_S: OUT  STD_LOGIC;
	Done: OUT  STD_LOGIC;
	Zi,Zj: IN STD_LOGIC
 );
END Controller_SAD;

ARCHITECTURE RTL OF Controller_SAD IS
 TYPE State_type IS (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12);
 SIGNAL state: State_type;
 BEGIN
  PROCESS(RST, CLK)
  BEGIN
	IF(RST = '1') THEN
		State <=S0;
	ELSIF(CLK'EVENT and CLK = '1') THEN
		CASE State IS
			WHEN S0 =>
			 State <= S1;
			WHEN S1 =>
			 IF(Start = '1') THEN
			  State <= S2;
			 ELSE State <=S1;
			 END IF;
			 WHEN S2 =>
			  State <= S3;
			 WHEN S3 =>
			  IF(Zi = '0') THEN
			  State <= S4;
			  ELSE State <= S10;
			  END IF;
			 WHEN S4 =>
			  State <= S5;
			 WHEN S5 =>
			   IF (Zj = '0') THEN
			   State <= S6;
 			   ELSE State <= S9;
			   END IF;
			 WHEN S6 =>
			  State <= S7;
			 WHEN S7 =>			  
			  State <= S8;
			 WHEN S8 =>
			   State <= S5;
			 WHEN S9 =>
			  State <= S3;
			 WHEN S10 =>
			  State <= S11;
			 WHEN S11 =>
			   IF (Start = '0') THEN
			   State <= S12;
 			   ELSE State <= S11;
			   END IF;
			 WHEN S12 =>
			  State <= S1;
			 WHEN OTHERS => State <= S0;
		END CASE;
	END IF;
  END PROCESS;
  
  LD_i <= '1' WHEN State = S2 ELSE '0';
  LD_j <= '1' WHEN State = S4 ELSE '0';

  Ren_A <= '1' WHEN State = S6 ELSE '0';
  Ren_B <= '1' WHEN State = S6 ELSE '0';

  En_S <= '1' WHEN State = S7 ELSE '0';
  En_j <= '1' WHEN State = S8 ELSE '0';
  En_i <= '1' WHEN State = S9 ELSE '0';
  Done <= '1' WHEN (State = S10 OR State = S11) ELSE '0';
 END RTL;