library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multiplexer is
    generic (
		Nbit : integer := 5
	);
	port (
        X : in std_logic_vector(Nbit-1 downto 0);
        Y : in std_logic_vector(Nbit-1 downto 0);
        sel : in std_logic;
        Z : out std_logic_vector(Nbit-1 downto 0)
    );
end multiplexer;

architecture dataflow of multiplexer is
begin
    Z <= X when (sel = '1') else Y;
end dataflow;