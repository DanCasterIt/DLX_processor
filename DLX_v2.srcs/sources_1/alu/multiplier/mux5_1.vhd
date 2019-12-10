library IEEE;
use IEEE.std_logic_1164.all; --  libreria IEEE con definizione tipi standard logic
use ieee.std_logic_unsigned;
--use WORK.constants.all; -- libreria WORK user-defined

entity MUX51 is 
	generic (n: integer);
	port (A: in std_logic_vector (n-1 downto 0);
	      B: in std_logic_vector (n-1 downto 0);
	      C: in std_logic_vector (n-1 downto 0);
	      D: in std_logic_vector (n-1 downto 0);
	      E: in std_logic_vector (n-1 downto 0); 	
	      S: in std_logic_vector (2 downto 0);
              Y: out std_logic_vector (n-1 downto 0));
end MUX51;

architecture BEHAVIORAL of MUX51 is 
begin
	pmux51: process(A,B,C,D,E,S)
		begin
		case S is
		when "000" => Y <= A;		
		when "001" => Y <= B;
		when "010" => Y <= C;
		when "011" => Y <= D;
		when "100" => Y <= E;
                when others => Y <= (others => '0');
		end case;
		end process;
end BEHAVIORAL;
