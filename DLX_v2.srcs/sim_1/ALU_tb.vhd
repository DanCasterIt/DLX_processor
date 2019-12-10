library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.all;
use IEEE.numeric_std.all;

entity ALUtb is 
end ALUtb; 

architecture arch of ALUtb is
	component ALU is
    generic (
		  Nbit : integer := 5;
		  Ncarry : integer := 2
    );
    Port (
        alu : in std_logic_vector(2 downto 0);
        A : in std_logic_vector((2**Nbit)-1 downto 0);
        B : in std_logic_vector((2**Nbit)-1 downto 0);
        alu_out : out std_logic_vector((2**Nbit)-1 downto 0)
    );
	end component;
constant bitsize : integer := 5;
constant carrysize : integer := 2;
constant Period: time := 1 ns; -- Clock period (1 GHz)
signal CLK : std_logic := '0';
signal As, Bs, Ss, res : std_logic_vector(2**bitsize-1 downto 0) := (others => '0');
signal alus : std_logic_vector(2 downto 0) := (others => '0');
begin
  CLK <= not CLK after Period/2;
  clac: ALU generic map(Nbit => bitsize, Ncarry => carrysize) port map(alus, As, Bs, Ss);
  process(alus, As, Bs)
  begin
    case alus is
      when "000" =>
        res <= As + Bs;
      when "001" =>
        res <= As - Bs;
      when "010" =>
        res <= As * Bs;
      when "011" =>
        --res <= As / Bs;
        res <= std_logic_vector(to_unsigned((to_integer(unsigned(As)) / to_integer(unsigned(Bs))),res'length));
      when "100" =>
        res <= As or Bs;
      when "101" =>
        res <= As xor Bs;
      when others =>
      end case;
  end process;
  process(CLK)
  variable cnt : integer := 0;
  variable ones : std_logic_vector(2**bitsize-1 downto 0) := (others => '1');
  variable zeros : std_logic_vector(2**bitsize-1 downto 0) := (others => '0');
  variable alu_cnt : std_logic_vector(2 downto 0) := (others => '0');
  begin
  case cnt is
	when 0 =>
		As <= x"7"&ones((2**bitsize-1)-4 downto 0);
		Bs <= x"7"&ones((2**bitsize-1)-4 downto 0);
	when 1 =>
		As <= zeros((2**bitsize-1)-20 downto 0)&x"3F5CA";
		Bs <= zeros((2**bitsize-1)-20 downto 0)&x"AECF1";
	when 2 =>
		As <= x"3F5CA"&zeros((2**bitsize-1)-20 downto 0);
		Bs <= x"AECF1"&zeros((2**bitsize-1)-20 downto 0);
	when 3 =>
		As <= zeros(((2**bitsize-1)/2)-10 downto 0)&x"3F5CA"&zeros(((2**bitsize-1)/2)-10 downto 0);
		Bs <= zeros(((2**bitsize-1)/2)-10 downto 0)&x"AECF1"&zeros(((2**bitsize-1)/2)-10 downto 0);
	when 4 =>
		As <= x"4"&zeros((2**bitsize-1)-4 downto 0);
		Bs <= x"4"&zeros((2**bitsize-1)-4 downto 0);
	when others =>
		As <= zeros;
		Bs <= zeros;
	end case;
	if cnt < 5 then
	   cnt := cnt + 1;
	else
	   cnt := 0;
	   alu_cnt := alus + 1;
	   alus <= alu_cnt;
	end if;
  end process;
end arch;
