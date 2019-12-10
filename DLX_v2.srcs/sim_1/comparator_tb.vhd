library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity comparator_tb is
end comparator_tb;

architecture Behavioral of comparator_tb is
component comparator is
  generic(
    Nbit : integer := 5
  );
  port (
    sub_result : in std_logic_vector((2**Nbit)-1 downto 0);
    carry_out : in std_logic;
    selection : in std_logic_vector(2 downto 0);
    result : out std_logic
  );
end component;
constant Nbit : integer := 5;
signal A, B, Bcomp : std_logic_vector((2**Nbit)-1 downto 0) := (others => '0');
signal tmp : std_logic_vector(2**Nbit downto 0) := (others => '0');
signal selection : std_logic_vector(2 downto 0) := (others => '0');
signal result, test_result : std_logic := '0';
constant Period: time := 2 ns; -- Clock period (1 GHz)
signal CLK : std_logic := '0';
type testtype is (AgB, AgeB, AlB, AleB, AeB, AdB);
signal test : testtype := AgB;
begin
    CLK <= not CLK after Period/2;
    dut : comparator generic map(Nbit => Nbit)
    port map(
        sub_result => tmp((2**Nbit)-1 downto 0),
        carry_out => tmp(2**Nbit),
        selection => selection,
        result => result
    );
    Bcomp <= not(B) + 1;
    tmp <= ('0'&A) + ('0'&Bcomp);
    process(clk)
    variable shft : std_logic_vector(5 downto 0) := "000001";
    begin
        if (clk'event and clk = '1') then
            if shft(0) = '1' then
                selection <= "000";
				test <= AgB;
            elsif shft(1) = '1' then
                selection <= "001";
				test <= AgeB;
            elsif shft(2) = '1' then
                selection <= "010";
				test <= AlB;
            elsif shft(3) = '1' then
                selection <= "011";
				test <= AleB;
            elsif shft(4) = '1' then
                selection <= "100";
				test <= AeB;
            else
                selection <= "101";
				test <= AdB;
		  end if;
		  shft := (shft(4 downto 0)&shft(5));
		end if;
    end process;
    process(A, B, selection)
    begin
        if selection = "000" then
            if A > B then
				test_result <= '1';
			else
				test_result <= '0';
            end if;
        elsif selection = "001" then
            if A >= B then
				test_result <= '1';
			else
				test_result <= '0';
            end if;
        elsif selection = "010" then
            if A < B then
				test_result <= '1';
			else
				test_result <= '0';
            end if;
        elsif selection = "011" then
            if A <= B then
				test_result <= '1';
			else
				test_result <= '0';
            end if;
        elsif selection = "100" then
            if A = B then
				test_result <= '1';
			else
				test_result <= '0';
            end if;
        else
            if A /= B then
				test_result <= '1';
			else
				test_result <= '0';
            end if;
		end if;
    end process;
    A <= std_logic_vector(to_unsigned(10, (2**Nbit))) after 0ns,  --A>B
		 std_logic_vector(to_unsigned(10, (2**Nbit))) after 13ns, --A>=B
		 std_logic_vector(to_unsigned(4, (2**Nbit))) after 25ns, --A<B
		 std_logic_vector(to_unsigned(4, (2**Nbit))) after 37ns, --A<=B
		 std_logic_vector(to_unsigned(4, (2**Nbit))) after 49ns, --A=B
		 std_logic_vector(to_unsigned(3, (2**Nbit))) after 61ns; --A!=B
		 
    B <= std_logic_vector(to_unsigned(4, (2**Nbit))) after 0ns,  --A>B
		 std_logic_vector(to_unsigned(4, (2**Nbit))) after 13ns, --A>=B
		 std_logic_vector(to_unsigned(10, (2**Nbit))) after 25ns, --A<B
		 std_logic_vector(to_unsigned(10, (2**Nbit))) after 37ns, --A<=B
		 std_logic_vector(to_unsigned(4, (2**Nbit))) after 49ns, --A=B
		 std_logic_vector(to_unsigned(4, (2**Nbit))) after 61ns; --A!=B
--    A <= x"00000001" after 0ns, x"00000010" after 10ns, x"00000000" after 20ns, x"00000010" after 30ns, x"00000000" after 40ns;
--    B <= x"00000001" after 0ns, (others => '1') after 30ns;
end Behavioral;