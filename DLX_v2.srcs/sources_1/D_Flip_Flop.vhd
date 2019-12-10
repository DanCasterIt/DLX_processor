library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity D_Flip_Flop is
	generic (
		Nbit : integer := 5
	);
    port (
        clk: in std_logic;
        en: in std_logic;
        d: in std_logic_vector(Nbit-1 downto 0);
        q: out std_logic_vector(Nbit-1 downto 0)
    );
end D_Flip_Flop;

architecture beh of D_Flip_Flop is
begin
    process (clk, en)
    begin
        if (clk'event and clk='1') and en = '0' then
            q <= d;
        end if;
    end process;
end beh;