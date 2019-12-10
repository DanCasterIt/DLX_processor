library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity RCA_MULT is 
	generic (n: integer);
	port (A: in std_logic_vector(n-1 downto 0);
	      B: in std_logic_vector(n-1 downto 0);
	      Ci: in std_logic;
	      S: out std_logic_vector(n-1 downto 0);
	      Co: out std_logic);
end RCA_MULT;

architecture BEHAV of RCA_MULT is
signal sum: std_logic_vector (n downto 0); 
begin 
	sum <= (('0' & A) + ('0' & B)) +Ci;
	S <= sum(n-1 downto 0);
	Co <= sum(n);
end BEHAV; 
