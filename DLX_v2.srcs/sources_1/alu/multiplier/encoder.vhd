library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity ENCODER is
	port( B: in std_logic_vector(2 downto 0);
	      Vp: out std_logic_vector (2 downto 0));
end ENCODER;

architecture behavioral of ENCODER is 
begin
   process(B)
   begin
	case B is
	when "000" => Vp <= "000";	---0	
	when "001" => Vp <= "001";      ---A
	when "010" => Vp <= "001";      ---A
	when "011" => Vp <= "011";      ---2A
	when "100" => Vp <= "100";      ---(-2A)
	when "101" => Vp <= "010";      ---(-A)
	when "110" => Vp <= "010";      ---(-A)
	when "111" => Vp <= "000";      ---0
	when others => Vp <= "ZZZ";
	end case;
   end process;
end architecture behavioral;
