library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity booth_encoder is
	generic(n_B: integer);
	port(Bi: in std_logic_vector(n_B-1 downto 0);
	     B_E_out: out std_logic_vector(3*(n_B/2)-1 downto 0));
end booth_encoder;

architecture structural of booth_encoder is

component ENCODER is
	port( B: in std_logic_vector(2 downto 0);
	      Vp: out std_logic_vector (2 downto 0));
end component ENCODER;
signal first: std_logic_vector(2 downto 0);
begin
first <= Bi(1) & Bi(0) & '0';
enc0: ENCODER port map(B => first, Vp => B_E_out(2 downto 0));


gen_enc: for i in 1 to (n_B/2)-1 generate
	 begin 
	 encx: ENCODER port map(B => Bi(2*i+1 downto 2*i-1), Vp => B_E_out((i+1)*3-1 downto (i+1)*3-3));
end generate;

end architecture structural;		
