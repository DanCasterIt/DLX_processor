library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity comparator is
  generic(
    Nbit : integer := 5
  );
  port (
    sub_result : in std_logic_vector((2**Nbit)-1 downto 0);
    carry_out : in std_logic;
    selection : in std_logic_vector(2 downto 0);
    result : out std_logic
  );
end comparator;

architecture structural of comparator is
    signal Z, C : std_logic := '0';
    signal temp : std_logic_vector((2**Nbit)-1 downto 0) := (others => '0');
	signal result_array :  std_logic_vector(6-1 downto 0) := (others => '0');
begin
    temp(0) <= sub_result(0);
    gen: for i in 1 to (2**Nbit)-1 generate
        temp(i) <= temp(i-1) or sub_result(i);
    end generate;
    Z <= not(temp((2**Nbit)-1));
    C <= carry_out;
    result_array(0) <= (C and not(Z));  --A>B
    result_array(1) <= C;               --A>=B
    result_array(2) <= not(C);          --A<B
    result_array(3) <= (not(C) or Z);   --A<=B
    result_array(4) <= Z;               --A=B
    result_array(5) <= not(Z);          --A!=B
    result <= result_array(to_integer(unsigned(selection)));	--here I expect a multiplexer is generated.
end structural;