library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.all;
use IEEE.numeric_std.all;

entity ALU is
  generic (
		Nbit : integer := 5--;
		--Ncarry : integer := 2
  );
  Port (
        alu : in std_logic_vector(4 downto 0);
        A : in std_logic_vector((2**Nbit)-1 downto 0);
        B : in std_logic_vector((2**Nbit)-1 downto 0);
        alu_out : out std_logic_vector((2**Nbit)-1 downto 0)
   );
end ALU;

architecture dataflow of ALU is
	component multiplexer is
		generic (
			Nbit : integer := 5
		);
		port (
			X : in std_logic_vector(Nbit-1 downto 0);
			Y : in std_logic_vector(Nbit-1 downto 0);
			sel : in std_logic;
			Z : out std_logic_vector(Nbit-1 downto 0)
		);
	end component;
--	component PPA is
--	generic (
--		Nbit : integer := 5;
--		Ncarry : integer := 2
--	);
--	Port (
--		A, B:	In	std_logic_vector((2**Nbit)-1 downto 0);
--		C :	In	std_logic;
--		S:	Out std_logic_vector((2**Nbit)-1 downto 0)
--	);
--	end component;
	component BOOTHMUL is
        generic(
			num_A: integer;
            num_B: integer
		);
        port(
			A: in std_logic_vector(num_A-1 downto 0);
            B: in std_logic_vector(num_B-1 downto 0);
            P: out std_logic_vector(num_A+num_B-1 downto 0)
		);
    end component;
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
    component comparator is
      generic(
        Nbit : integer := 5
      );
      port (
        sub_result : in std_logic_vector((2**Nbit)-1 downto 0);
        carry_out : in std_logic;
        selection : in std_logic_vector(2 downto 0);
        result : out std_logic
      );
    end component;
	function shifter (
			A : std_logic_vector((2**Nbit)-1 downto 0) := (others => '0');	--number of shifts
			B : std_logic_vector((2**Nbit)-1 downto 0) := (others => '0');	--number to be shifted
			LR : std_logic	:= '0'											--'1' = R, '0' = L
		)
		return std_logic_vector is
		variable tmp : std_logic_vector((2**Nbit)-1 downto 0);
		variable I : integer;
		begin
			I := 0;
			tmp := B;
			while ((I < to_integer(unsigned(A))) and (I < (2**Nbit))) loop
				if (LR = '1') then
					tmp := '0'&tmp((2**Nbit)-1 downto 1);	--R
				else
					tmp := tmp((2**Nbit)-2 downto 0)&'0';	--L
				end if;
				I := I + 1;
			end loop;
			return tmp;
	end shifter;
	function logic_shifter (
			A : std_logic_vector((2**Nbit)-1 downto 0) := (others => '0');	--number of shifts
			B : std_logic_vector((2**Nbit)-1 downto 0) := (others => '0')	--number to be shifted
		)
		return std_logic_vector is
		variable tmp : std_logic_vector((2**Nbit)-1 downto 0);
		variable I : integer;
		begin
			I := 0;
			tmp := B;
			while ((I < to_integer(unsigned(A))) and (I < (2**Nbit))) loop
				tmp := tmp((2**Nbit)-1)&tmp((2**Nbit)-1 downto 1);	--R
				I := I + 1;
			end loop;
			return tmp;
	end logic_shifter;
	signal temp_m : std_logic_vector((2*(2**Nbit))-1 downto 0) := (others => '0');
	signal temp_s, temp_l, MUX_to_ADDER, notB : std_logic_vector((2**Nbit)-1 downto 0) := (others => '0');
    signal tmp : std_logic_vector(2**Nbit downto 0) := (others => '0');
	signal Cis, Cos, result, mux_sel : std_logic := '0';
	signal control : std_logic_vector(2 downto 0);
	signal selection : std_logic_vector(2 downto 0);
begin
	notB <= not(B);
	mux : multiplexer generic map(
			Nbit => 2**Nbit
		)
		port map(
			X => B,
			Y => notB,
			sel => mux_sel,
			Z => MUX_to_ADDER
		);
    tmp <= ('0'&A) + (('0'&MUX_to_ADDER) + Cis);
    temp_s <= tmp((2**Nbit)-1 downto 0);
	Cos <= tmp(2**Nbit);
--    adder: PPA generic map(
--			Nbit => Nbit,
--			Ncarry => Ncarry
--		) port map(
--			A => A,
--			B => MUX_to_ADDER,
--			C => Cis,
--			S => temp_s
--		);
    multiplier: BOOTHMUL generic map(
			num_A => (2**Nbit),
            num_B => (2**Nbit)
        )
        port map(
            A => A,
            B => B,
            P => temp_m
        );
    logicunit : logic_unit generic map(
			Nbit => Nbit
        )
        port map(
        	A => A,
            B => B,
        	control => control,
            result => temp_l
        );
    comparatorunit : comparator generic map(
			Nbit => Nbit
        )
        port map(
        	sub_result => temp_s,
            carry_out => Cos,
        	selection => selection,
            result => result
        );
    process(A, B, temp_s, temp_m, temp_l, result, alu)
	variable ab, bb, cb : std_logic := '0';
    begin
		mux_sel <= '0';
		Cis <= '0';
		control <= (others => '0');
		selection <= (others => '0');
		alu_out <= (others => '0');
        case alu is
            when "00000" =>
                --SUM
				mux_sel <= '1';
                Cis <= '0';
                alu_out <= temp_s;
            when "00001" =>
                --SUB
				mux_sel <= '0';
                Cis <= '1';
                alu_out <= temp_s;
            when "00010" =>
                --MUL
                alu_out <= temp_m((2**Nbit)-1 downto 0);
            when "00011" =>
                --DIV
                --alu_out <= std_logic_vector(to_unsigned((to_integer(unsigned(A)) / to_integer(unsigned(B))),(2**Nbit)));
            when "00100" =>
                --OR
                control <= "111"; --OR
                alu_out <= temp_l;
            when "00101" =>
                --XOR
                control <= "110"; --XOR
                alu_out <= temp_l;
            when "00110" =>
                --AND
                control <= "001"; --AND
                alu_out <= temp_l;
            when "00111" =>
				--A > B unsigned
				mux_sel <= '0';
                Cis <= '1';
				selection <= "000"; --A>B
				alu_out <= (others => result);
            when "01000" =>
				--A >= B unsigned
				mux_sel <= '0';
                Cis <= '1';
				selection <= "001"; --A>=B
                alu_out <= (others => result);
            when "01001" =>
				--A < B unsigned
				mux_sel <= '0';
                Cis <= '1';
				selection <= "010"; --A<B
                alu_out <= (others => result);
            when "01010" =>
				--A <= B unsigned
				mux_sel <= '0';
                Cis <= '1';
				selection <= "011"; --A<=B
                alu_out <= (others => result);
            when "01011" =>
				--A = B
				mux_sel <= '0';
                Cis <= '1';
				selection <= "100"; --A=B
                alu_out <= (others => result);
            when "01100" =>
				--A /= B
				mux_sel <= '0';
                Cis <= '1';
				selection <= "101"; --A!=B
                alu_out <= (others => result);
			when "01101" =>
				--B >> A
				alu_out <= shifter(B, A, '1');  --shifts B times A right
            when "01110" =>
				--B << A
				alu_out <= shifter(B, A, '0');  --shifts B times A left
            when "01111" =>
				--A > B signed
				mux_sel <= '0';
                Cis <= '1';
				selection <= "000"; --A>B
				ab := result;
				bb := A((2**Nbit)-1);
				cb := B((2**Nbit)-1);
				alu_out <= (others => ((not(bb) and cb) or (ab and (not(bb) or cb))));
			when "10000" => 
				--A >= B signed
				mux_sel <= '0';
                Cis <= '1';
				selection <= "001"; --A>=B
				ab := result;
				bb := A((2**Nbit)-1);
				cb := B((2**Nbit)-1);
				alu_out <= (others => ((not(bb) and cb) or (ab and (not(bb) or cb))));
			when "10001" => 
				--A < B signed
				mux_sel <= '0';
                Cis <= '1';
				selection <= "010"; --A<B
				ab := result;
				bb := A((2**Nbit)-1);
				cb := B((2**Nbit)-1);
				alu_out <= (others => ((bb and not(cb)) or (ab and (bb or not(cb)))));
			when "10010" => 
				--A <= B signed
				mux_sel <= '0';
                Cis <= '1';
				selection <= "011"; --A<=B
				ab := result;
				bb := A((2**Nbit)-1);
				cb := B((2**Nbit)-1);
				alu_out <= (others => ((bb and not(cb)) or (ab and (bb or not(cb)))));
			when "10011" => 
				--B >> A arithmetic
				alu_out <= logic_shifter(B, A);  --shifts B times A arithmetically right
            when others =>
                --do nothing, do not switch
        end case;
     end process;
end dataflow;