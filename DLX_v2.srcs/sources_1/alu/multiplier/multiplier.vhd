library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;
use WORK.constants.all;
entity BOOTHMUL is
	generic(num_A: integer;
                num_B: integer);
	port(A: in std_logic_vector(num_A-1 downto 0);
	     B: in std_logic_vector(num_B-1 downto 0);
	     P: out std_logic_vector(num_A+num_B-1 downto 0));
end BOOTHMUL;

architecture MIX of BOOTHMUL is

component booth_encoder is
	generic(n_B: integer);
	port(Bi: in std_logic_vector(n_B-1 downto 0);
	     B_E_out: out std_logic_vector(3*(n_B/2)-1 downto 0));
end component booth_encoder;

component MUX51 is 
	generic (n: integer);
	port (A: in std_logic_vector (n-1 downto 0);
	      B: in std_logic_vector (n-1 downto 0);
	      C: in std_logic_vector (n-1 downto 0);
	      D: in std_logic_vector (n-1 downto 0);
	      E: in std_logic_vector (n-1 downto 0); 	
	      S: in std_logic_vector (2 downto 0);
              Y: out std_logic_vector (n-1 downto 0));
end component MUX51;

component RCA_MULT is 
	generic (n: integer);
	port (A: in std_logic_vector(n-1 downto 0);
	      B: in std_logic_vector(n-1 downto 0);
	      Ci: in std_logic;
	      S: out std_logic_vector(n-1 downto 0);
	      Co: out std_logic);
end component RCA_MULT;

type mux51_out_type is array (0 to (num_B/2)-1) of std_logic_vector (num_A+num_B-1 downto 0);
type rca_out_type is array (1 to (num_B/2)-1) of std_logic_vector (num_A+num_B-1 downto 0);
type a_shifted_type is array(0 to num_B-1) of std_logic_vector (num_A+num_B-1 downto 0);

signal a_shifted, minus_a_shifted: a_shifted_type;
signal rca_out: rca_out_type; 
signal mux51_out: mux51_out_type;
signal boothenc_out: std_logic_vector(3*num_B/2-1 downto 0);
signal A_sig: std_logic_vector(num_A+num_B-1 downto 0);
signal minus_A_sig: std_logic_vector(num_A+num_B-1 downto 0);
signal sign: std_logic_vector(num_B-1 downto 0);

begin

estendo_segno: for j in 0 to num_B-1 generate
		begin
		sign(j) <= A(num_A-1);
		end generate estendo_segno;

A_sig <= sign & A;
minus_A_sig <= not(A_sig) + '1';


a_shifted(0) <= A_sig;
minus_a_shifted(0) <= minus_A_sig;
shift_gen: for i in 1 to num_B-1 generate
	   begin
	   a_shifted(i) <=  std_logic_vector(shift_left (unsigned(A_sig), i)); --A_sig(num_A+num_B-1-i downto 0 & (i-1 downto 0 => '0');
	   minus_a_shifted(i) <= std_logic_vector(shift_left (unsigned(minus_A_sig), i)); --minus_A_sig(num_A+num_B-1-i downto 0 & (i-1 downto 0 => '0');
	   end generate shift_gen;
---------------------------------------------------------------------
booth_enc: booth_encoder generic map(n_B => num_B)
			 port map(Bi => B, B_E_out => boothenc_out);
---------------------------------------------------------------------
mux_gen: for i in 0 to num_B/2-1 generate 
	 begin
	 mux: MUX51 generic map(n => num_A+num_B)
		    port map(A => (others => '0'),
			     B =>  a_shifted(2*i),--std_logic_vector(shift_left (A_sig, 2*i) ),--A*(4**i),
			     C =>  minus_a_shifted(2*i),--std_logic_vector(shift_left (minus_A_sig, 2*i) ),--A*(4**i),
                             D => a_shifted(2*i+1),--std_logic_vector(shift_left (A_sig, 2*i+1) ),--A*((4**(i+1))/2),
                             E => minus_a_shifted(2*i+1),--std_logic_vector(shift_left (minus_A_sig, 2*i+1) ),--A*((4**(i+1))/2),	 
		             S => boothenc_out((i+1)*3-1 downto (i+1)*3-3),
			     Y => mux51_out(i));
end generate mux_gen;
---------------------------------------------------------------------
--the first rca takes as inputs two mux51_out, so:
first_rca: RCA_MULT generic map(n => num_A+num_B)
		    port map(A => mux51_out(0),
			     B => mux51_out(1),
			     Ci => '0',
                             S => rca_out(1),
                             Co => open);
---------------------------------------------------------------------	
--second and third rca take as inputs mux51_out and rca_out of the previous rca, so:
rca_gen: for i in 2 to num_B/2-1 generate
	 begin
         rca: RCA_MULT generic map(n => num_A+num_B)
		       port map(A => mux51_out(i),
			     B => rca_out(i-1),
			     Ci => '0',
                             S => rca_out(i),
                             Co => open);	
end generate rca_gen;
---------------------------------------------------------------------
P <= rca_out(num_B/2-1);

end architecture MIX;






















