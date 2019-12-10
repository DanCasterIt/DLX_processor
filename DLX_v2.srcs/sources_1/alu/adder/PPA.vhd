library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity PPA is
	generic (
		Nbit : integer := 5;
		Ncarry : integer := 2
	);
	Port (
		A, B:	In	std_logic_vector((2**Nbit)-1 downto 0);
		C :	In	std_logic;
		S:	Out std_logic_vector((2**Nbit)-1 downto 0)
	);
end PPA;
architecture STRUCTURAL of PPA is
	component CLA is
		generic (
			Nbit : integer := 5;
			Ncarry : integer := 2
		);
		Port (
			A, B:	In	std_logic_vector((2**Nbit)-1 downto 0);
            C :    In    std_logic;
			Co:	Out std_logic_vector((2**Nbit/2**Ncarry)-1 downto 0)
		);
	end component;
	component CSB is 
		generic (N : integer := 4);
		Port (
			A, B:	In	std_logic_vector(N-1 downto 0);
			Ci:	In	std_logic;
			S:		Out	std_logic_vector(N-1 downto 0);
			Co:	Out	std_logic
		);
	end component;
signal Crrs, Cos : std_logic_vector((2**Nbit/2**Ncarry) downto 0) := (others => '0');
begin
	IFA: if (Ncarry+2) < Nbit and Ncarry /= 0 generate
		clac: CLA generic map(Nbit => Nbit, Ncarry => Ncarry) port map(A, B, C, Crrs((2**Nbit/2**Ncarry) downto 1));
		Crrs(0) <= C;
		csbcl: for I in 0 to ((2**Nbit)/(2**Ncarry))-1 generate
			csbc: CSB generic map(N => 2**Ncarry) port map(
				A((I*(2**Ncarry)+(2**Ncarry))-1 downto I*(2**Ncarry)),
				B((I*(2**Ncarry)+(2**Ncarry))-1 downto I*(2**Ncarry)),
				Crrs(I),
				S((I*(2**Ncarry)+(2**Ncarry))-1 downto I*(2**Ncarry)),
				Cos(I)
			);
		end generate csbcl;
	end generate IFA;
	IFB: if (Ncarry+2) >= Nbit or Ncarry = 0 generate
		csbb: CSB generic map(N => 2**Nbit) port map(A, B, C, S, Cos(0));
	end generate IFB;
end STRUCTURAL;