library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity NETB is 
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
end NETB;
architecture BEHAVIORAL of NETB is
    component GB is 
		Port (
			pA: in std_logic;
			gA: in std_logic;
			gB: in std_logic;
			gO: out std_logic
		);
	end component;
	signal pO_tmp, gO_tmp : std_logic;
begin
    --modified N block enabling carry in
    pO_tmp <= A(0) xor B(0);
	gO_tmp <= A(0) and B(0);
    gb_blk: GB port map(pO_tmp, gO_tmp, C, gO(0));
    pO(0) <= '0';
    --normal N blocks
	pO(N-1 downto 1) <= A(N-1 downto 1) xor B(N-1 downto 1);
	gO(N-1 downto 1) <= A(N-1 downto 1) and B(N-1 downto 1);
--    --modified N block enabling carry in
--    pO_tmp <= A(N-1) xor B(N-1);
--	gO_tmp <= A(N-1) and B(N-1);
--    gb_blk: GB port map(pO_tmp, gO_tmp, C, gO(N-1));
--    pO(N-1) <= '0';
--    --normal N blocks
--	pO(N-2 downto 0) <= A(N-2 downto 0) xor B(N-2 downto 0);
--	gO(N-2 downto 0) <= A(N-2 downto 0) and B(N-2 downto 0);
--    --unmodified N block enabling carry in
--	pO(N-1 downto 0) <= A(N-1 downto 0) xor B(N-1 downto 0);
--	gO(N-1 downto 0) <= A(N-1 downto 0) and B(N-1 downto 0);
end BEHAVIORAL;