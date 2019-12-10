library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use WORK.constants.all;

entity MULTIPLIER_tb is
end MULTIPLIER_tb;


architecture TEST of MULTIPLIER_tb is


  --constant numBit : integer; --:= 16;     --:=8  --:=16    

  --  input	 
  signal A_mp_i : std_logic_vector(numBit-1 downto 0) := (others => '0');
  signal B_mp_i : std_logic_vector(numBit-1 downto 0) := (others => '0');

  -- output
  signal Y_mp_i : std_logic_vector(2*numBit-1 downto 0);


-- MUL component declaration
--
--

component BOOTHMUL is
	generic(num_A: integer;
                num_B: integer);
	port(A: in std_logic_vector(num_A-1 downto 0);
	     B: in std_logic_vector(num_B-1 downto 0);
	     P: out std_logic_vector(num_A+num_B-1 downto 0));
end component BOOTHMUL;

begin

-- MUL instantiation
--
--
booth_mul: BOOTHMUL generic map(num_A => numBit, num_B => numBit) port map(A => A_mp_i, B => B_mp_i, P => Y_mp_i);

-- PROCESS FOR TESTING TEST - COMLETE CYCLE ---------
  test: process
  begin

    -- cycle for operand A
    NumROW : for i in 0 to 2**(NumBit)-1 loop

      --   cycle for operand B
    	NumCOL : for i in 0 to 2**(NumBit)-1 loop
	    wait for 5 ns;
	    B_mp_i <= B_mp_i + '1';
	end loop NumCOL ;
        
	A_mp_i <= A_mp_i + '1'; 	
    end loop NumROW ;

    wait;          
	--	A_mp_i <= "00001000";  
	--	B_mp_i <= "00000010";
	--	wait for 5 ns;
	--	A_mp_i <= "00000010";  
	--	B_mp_i <= "00000011";
	--	wait for 5 ns;
	--	A_mp_i <= "00000000";  
	--	B_mp_i <= "00000110";
	--	wait for 5 ns;
end process test;


end TEST;
