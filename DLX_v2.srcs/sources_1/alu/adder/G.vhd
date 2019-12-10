library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity GB is
		Port (
			pA: in std_logic;
			gA: in std_logic;
			gB: in std_logic;
			gO: out std_logic
		);
end GB;
architecture BEHAVIORAL of GB is
begin
	gO <= gA or (pA and gB);
end BEHAVIORAL;