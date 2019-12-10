library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity CSB is 
	generic (N : integer := 4);
	Port (
		A, B:	In	std_logic_vector(N-1 downto 0);
		Ci:	In	std_logic;
		S:		Out	std_logic_vector(N-1 downto 0);
		Co:	Out	std_logic
	);
end CSB;
architecture STRUCTURAL of CSB is
component RCAG is 
	generic (N : integer := 4);
	Port (
		A:		In		std_logic_vector(N-1 downto 0);
		B:		In		std_logic_vector(N-1 downto 0);
		Ci:	In		std_logic;
		S:		Out	std_logic_vector(N-1 downto 0);
		Co:	Out	std_logic
	);
end component;
signal Ss1, Ss0 : std_logic_vector(N-1 downto 0);
signal Cos1, Cos0 : std_logic;
begin
	rca1 : rcag generic map(N => N) port map(A, B, '1', Ss1, Cos1);
	rca2 : rcag generic map(N => N) port map(A, B, '0', Ss0, Cos0);
	Co <= Cos1 when Ci = '1' else Cos0;
	S <= Ss1 when Ci = '1' else Ss0;
end STRUCTURAL;