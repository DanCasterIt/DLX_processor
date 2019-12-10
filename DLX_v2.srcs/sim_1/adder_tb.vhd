library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity TBPPA is 
end TBPPA; 

architecture TEST of TBPPA is
	component PPA is
	generic (
		Nbit : integer := 5;
		Ncarry : integer := 2
	);
	Port (
		A, B:	In	std_logic_vector((2**Nbit)-1 downto 0);
		C :	In	std_logic;
		S:	Out std_logic_vector((2**Nbit)-1 downto 0)
	);
	end component;
constant bitsize : integer := 5;
constant carrysize : integer := 2;
constant Period: time := 1 ns; -- Clock period (1 GHz)
signal CLK : std_logic := '0';
signal As, Bs, Ss, res : std_logic_vector(2**bitsize-1 downto 0) := (others => '0');
signal Cs : std_logic;
begin
  CLK <= not CLK after Period/2;
  clac: PPA generic map(Nbit => bitsize, Ncarry => carrysize) port map(As, Bs, Cs, Ss);
  res <= As + Bs + Cs;
  process(CLK)
  variable cnt : integer := 0;
  variable ones : std_logic_vector(2**bitsize-1 downto 0) := (others => '1');
  variable zeros : std_logic_vector(2**bitsize-1 downto 0) := (others => '0');
  begin
  case cnt is
	when 0 =>
		As <= x"7"&ones((2**bitsize-1)-4 downto 0);
		Bs <= x"7"&ones((2**bitsize-1)-4 downto 0);
		Cs <= '0';
	when 1 =>
		As <= zeros((2**bitsize-1)-20 downto 0)&x"3F5CA";
		Bs <= zeros((2**bitsize-1)-20 downto 0)&x"AECF1";
        Cs <= '0';
	when 2 =>
		As <= x"3F5CA"&zeros((2**bitsize-1)-20 downto 0);
		Bs <= x"AECF1"&zeros((2**bitsize-1)-20 downto 0);
        Cs <= '0';
	when 3 =>
		As <= zeros(((2**bitsize-1)/2)-10 downto 0)&x"3F5CA"&zeros(((2**bitsize-1)/2)-10 downto 0);
		Bs <= zeros(((2**bitsize-1)/2)-10 downto 0)&x"AECF1"&zeros(((2**bitsize-1)/2)-10 downto 0);
        Cs <= '0';
	when 4 =>
		As <= x"4"&zeros((2**bitsize-1)-4 downto 0);
		Bs <= x"4"&zeros((2**bitsize-1)-4 downto 0);
        Cs <= '0';
    when 5 =>
        As <= zeros;
        Bs <= ones;
        Cs <= '1';
    when 6 =>
        As <= zeros;
        Bs <= ones;
        Cs <= '0';
	when 7 =>
        As <= x"8"&x"8"&x"8"&x"8"&x"8"&x"8"&x"8"&x"8";
        Bs <= x"8"&x"8"&x"8"&x"8"&x"8"&x"8"&x"8"&x"8";
    when 8 =>
        As <= ones;
        Bs <= ones;
     when others =>
        As <= zeros;
        Bs <= zeros;
	end case;
	cnt := cnt + 1;
  end process;
end TEST;
