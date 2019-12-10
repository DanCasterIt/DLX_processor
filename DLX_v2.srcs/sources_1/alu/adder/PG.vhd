library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity PGB is 
		Port (
			pA: in std_logic;
			gA: in std_logic;
			pB: in std_logic;
			gB: in std_logic;
			pO: out std_logic;
			gO: out std_logic
		);
end PGB;
architecture BEHAVIORAL of PGB is
begin
	pO <= pA and pB;
	gO <= gA or (pA and gB);
end BEHAVIORAL;