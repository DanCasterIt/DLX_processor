library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity logic_unit is
  generic (
    Nbit : integer := 5
  );
  port (
    A : in std_logic_vector((2**Nbit)-1 downto 0);
    B : in std_logic_vector((2**Nbit)-1 downto 0);
    control : in std_logic_vector(2 downto 0);
    result : out std_logic_vector((2**Nbit)-1 downto 0)
  );
end logic_unit;

architecture structural of logic_unit is
signal tmp1, tmp2, tmp3: std_logic_vector((2**Nbit)-1 downto 0);
type SignalVector is array (0 to 2) of std_logic_vector((2**Nbit)-1 downto 0);
signal con : SignalVector := ((others=> (others=>'0')));
begin
    con(0) <= (others => control(0));
    con(1) <= (others => control(1));
    con(2) <= (others => control(2));
    tmp1 <= NOT((A AND B) AND con(0));
    tmp2 <= NOT((NOT(A) AND B) AND con(1));
    tmp3 <= NOT((A AND NOT(B)) AND con(2));
    result <= NOT((tmp1 AND tmp2) AND tmp3);
end structural;