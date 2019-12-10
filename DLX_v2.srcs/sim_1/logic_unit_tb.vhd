library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity logic_unit_tb is
end logic_unit_tb;

architecture arch of logic_unit_tb is
component logic_unit is
  generic (
    Nbit : integer := 5
  );
  port (
    A : in std_logic_vector((2**Nbit)-1 downto 0);
    B : in std_logic_vector((2**Nbit)-1 downto 0);
    control : in std_logic_vector(2 downto 0);
    result : out std_logic_vector((2**Nbit)-1 downto 0)
  );
end component;
constant Nbit : integer := 5;
signal A : std_logic_vector((2**Nbit)-1 downto 0) := (others => '0');
signal B : std_logic_vector((2**Nbit)-1 downto 0) := (others => '0');
signal control1, control2, control3 : std_logic_vector(2 downto 0) := (others => '0');
signal result1, result2, result3 : std_logic_vector((2**Nbit)-1 downto 0) := (others => '0');
signal test1, test2, test3 : std_logic_vector((2**Nbit)-1 downto 0) := (others => '0');
begin
    dut1 : logic_unit generic map(Nbit => Nbit)
    port map(
        A => A,
        B => B,
        control => control1,
        result => result1
    );
    dut2 : logic_unit generic map(Nbit => Nbit)
    port map(
        A => A,
        B => B,
        control => control2,
        result => result2
    );
    dut3 : logic_unit generic map(Nbit => Nbit)
    port map(
        A => A,
        B => B,
        control => control3,
        result => result3
    );
    control1 <= "111"; --OR <--
    control2 <= "001"; --AND
    control3 <= "110"; --XOR <--
	test1 <= A or B;
	test2 <= A and B;
	test3 <= A xor B;
    A((2**Nbit)-1 downto ((2**Nbit)-1)/2) <= (others => '1') after 0ns,
                                     (others => '0') after 5ns,
                                     (others => '1') after 10ns,
                                     (others => '0') after 15ns;
    B((2**Nbit)-1 downto ((2**Nbit)-1)/2) <= (others => '1') after 0ns,
                                     (others => '1') after 5ns,
                                     (others => '0') after 10ns,
                                     (others => '0') after 15ns;
end arch;