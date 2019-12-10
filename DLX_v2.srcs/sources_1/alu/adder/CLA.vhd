library ieee;
use ieee.std_logic_1164.all;

entity CLA is
	generic (
		Nbit : integer := 5;
		Ncarry : integer := 2
	);
	Port (
		A, B:	In	std_logic_vector((2**Nbit)-1 downto 0);
        C :    In    std_logic;
		Co:	Out std_logic_vector((2**Nbit/2**Ncarry)-1 downto 0)
	);
end CLA;
architecture STRUCTURAL of CLA is
	component NETB is 
		generic (
			N : integer := 32
		);
		Port (
			A: in std_logic_vector(N-1 downto 0);
			B: in std_logic_vector(N-1 downto 0);
            C : in std_logic;
			pO: out std_logic_vector(N-1 downto 0);
			gO: out std_logic_vector(N-1 downto 0)
		);
	end component NETB;
	component PGB is 
		Port (
			pA: in std_logic;
			gA: in std_logic;
			pB: in std_logic;
			gB: in std_logic;
			pO: out std_logic;
			gO: out std_logic
		);
	end component PGB;
	component GB is 
		Port (
			pA: in std_logic;
			gA: in std_logic;
			gB: in std_logic;
			gO: out std_logic
		);
	end component GB;
constant exp : integer := 2**Nbit;
constant expc : integer := 2**Ncarry;
type SignalVector is array (1 to Nbit+1) of std_logic_vector(exp-1 downto 0);
signal tmpP: SignalVector := ((others=> (others=>'0')));
signal tmpG: SignalVector := ((others=> (others=>'0')));
begin
	NET: NETB generic map(N => exp) port map(A, B, C, tmpP(1), tmpG(1));--blocchi N
	AL: for I in 1 to Nbit generate
		IFA: if I < (Ncarry+2) or (Ncarry+2) = Nbit generate
			BL: for J in 0 to ((2**(Nbit-I))-1) generate
				IFE: if J < ((2**(Nbit-I))-1) generate							--blocchi PG
					pg0: PGB port map(
											tmpP(I)(exp-1-(J*(2**I))),
											tmpG(I)(exp-1-(J*(2**I))),
											tmpP(I)(exp-1-((J*(2**I))+2**(I-1))),
											tmpG(I)(exp-1-((J*(2**I))+2**(I-1))),
											tmpP(I+1)(exp-1-(J*(2**I))),
											tmpG(I+1)(exp-1-(J*(2**I)))
										);
				end generate IFE;
				IFF: if J = ((2**(Nbit-I))-1) generate							--blocchi P
					IFG: if I < Ncarry generate
						g0: GB port map(
												tmpP(I)(exp-1-(J*(2**I))),
												tmpG(I)(exp-1-(J*(2**I))),
												tmpG(I)(exp-1-((J*(2**I))+2**(I-1))),
												tmpG(I+1)(exp-1-(J*(2**I)))
											);
					end generate IFG;
					IFH: if I >= Ncarry generate
						g0: GB port map(
												tmpP(I)(exp-1-(J*(2**I))),
												tmpG(I)(exp-1-(J*(2**I))),
												tmpG(I)(exp-1-((J*(2**I))+2**(I-1))),
												Co(I-Ncarry)
											);
					end generate IFH;
				end generate IFF;
			end generate BL;
		end generate IFA;
		IFB: if I >= (Ncarry+2) and (Ncarry+2) /= Nbit generate
			CL: for K in 1 to (2**(Nbit-I)) generate --				...	1_2_3_4, 1_2,	1
				IFC: if K < (2**(Nbit-I)) generate --																							blocchi PG
					DL: for M in 1 to (I-(Ncarry+2)+1) generate -- 					1,			1_2,	1_2_3, ...
						EL: for J in (2**(M-1)-1) downto 0 generate -- ...	3_2_1_0,	1_0,	0				for interconnections
							pg1: PGB port map(
													tmpP(I-(I-(Ncarry+2)+1)+M)(exp-1-(((K-1)*2**(I-(Ncarry+2)+2)*expc)+(((2**(I-(Ncarry+2)+1)-(2**M))+J)*expc))),
													tmpG(I-(I-(Ncarry+2)+1)+M)(exp-1-(((K-1)*2**(I-(Ncarry+2)+2)*expc)+(((2**(I-(Ncarry+2)+1)-(2**M))+J)*expc))),
													tmpP(I)(exp-1-(((K-1)*2**(I-(Ncarry+2)+2)*expc)+(2**(I-(Ncarry+2)+1)*expc))),
													tmpG(I)(exp-1-(((K-1)*2**(I-(Ncarry+2)+2)*expc)+(2**(I-(Ncarry+2)+1)*expc))),
													tmpP(I+1)(exp-1-(((K-1)*2**(I-(Ncarry+2)+2)*expc)+(((2**(I-(Ncarry+2)+1)-(2**M))+J)*expc))),
													tmpG(I+1)(exp-1-(((K-1)*2**(I-(Ncarry+2)+2)*expc)+(((2**(I-(Ncarry+2)+1)-(2**M))+J)*expc)))
												);
						end generate EL;
					end generate DL;
					pg2: PGB port map(
											tmpP((Ncarry+2)-1)(exp-1-(((K-1)*2**(I-(Ncarry+2)+2)*expc)+((2**(I-(Ncarry+2)+1)-1)*expc))),
											tmpG((Ncarry+2)-1)(exp-1-(((K-1)*2**(I-(Ncarry+2)+2)*expc)+((2**(I-(Ncarry+2)+1)-1)*expc))),
											tmpP(I)(exp-1-(((K-1)*2**(I-(Ncarry+2)+2)*expc)+(2**(I-(Ncarry+2)+1)*expc))),
											tmpG(I)(exp-1-(((K-1)*2**(I-(Ncarry+2)+2)*expc)+(2**(I-(Ncarry+2)+1)*expc))),
											tmpP(I+1)(exp-1-(((K-1)*2**(I-(Ncarry+2)+2)*expc)+((2**(I-(Ncarry+2)+1)-1)*expc))),
											tmpG(I+1)(exp-1-(((K-1)*2**(I-(Ncarry+2)+2)*expc)+((2**(I-(Ncarry+2)+1)-1)*expc)))
										);
				end generate IFC;
				IFD: if K = (2**(Nbit-I)) generate --																							blocchi P
					FL: for M in 1 to (I-(Ncarry+2)+1) generate -- 					1, 		1_2,	1_2_3, ...
						GL: for J in (2**(M-1)-1) downto 0 generate -- ...	3_2_1_0,	1_0,	0				for interconnections
							g1: GB port map(
													tmpP(I-(I-(Ncarry+2)+1)+M)(exp-1-(((K-1)*2**(I-(Ncarry+2)+2)*expc)+(((2**(I-(Ncarry+2)+1)-(2**M))+J)*expc))),
													tmpG(I-(I-(Ncarry+2)+1)+M)(exp-1-(((K-1)*2**(I-(Ncarry+2)+2)*expc)+(((2**(I-(Ncarry+2)+1)-(2**M))+J)*expc))),
													tmpG(I)(exp-1-(((K-1)*2**(I-(Ncarry+2)+2)*expc)+(2**(I-(Ncarry+2)+1)*expc))),
													Co(2**(I-(Ncarry+2)+1)+(2**(M-1)+((2**(M-1)-1)-J)))
												);
						end generate GL;
					end generate FL;
					g2: GB port map(
											tmpP((Ncarry+2)-1)(exp-1-(((K-1)*2**(I-(Ncarry+2)+2)*expc)+((2**(I-(Ncarry+2)+1)-1)*expc))),
											tmpG((Ncarry+2)-1)(exp-1-(((K-1)*2**(I-(Ncarry+2)+2)*expc)+((2**(I-(Ncarry+2)+1)-1)*expc))),
											tmpG(I)(exp-1-(((K-1)*2**(I-(Ncarry+2)+2)*expc)+(2**(I-(Ncarry+2)+1)*expc))),
											Co(2**(I-(Ncarry+2)+1))
										);
				end generate IFD;
			end generate CL;
		end generate IFB;
	end generate AL;
end STRUCTURAL;