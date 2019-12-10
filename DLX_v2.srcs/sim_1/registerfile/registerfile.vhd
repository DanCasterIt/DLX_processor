library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_signed.all;
use IEEE.numeric_std.all;
use WORK.rf_and_mem_constants.all;

entity register_file is
    generic(
        nbit_addr: integer;
	    nbit_reg: integer;
	    n_reg: integer
	);
	port (
	    RD1: 		IN std_logic;
	    RD2: 		IN std_logic;
	    WR: 		IN std_logic;
	    ADD_WR: 	IN std_logic_vector(nbit_addr-1 downto 0);
	    ADD_RD1: 	IN std_logic_vector(nbit_addr-1 downto 0);
	    ADD_RD2: 	IN std_logic_vector(nbit_addr-1 downto 0);
	    DATAIN: 	IN std_logic_vector(nbit_reg-1 downto 0);
        OUT1: 		OUT std_logic_vector(nbit_reg-1 downto 0);
	    OUT2: 		OUT std_logic_vector(nbit_reg-1 downto 0)
    );
end register_file;

architecture A of register_file is
    subtype REG_ADDR is natural range 0 to n_reg-1; -- using natural type
	type REG_ARRAY is array(REG_ADDR) of std_logic_vector(nbit_reg-1 downto 0); 
    signal REGISTERS : REG_ARRAY := (
--                                     "00000000000000000000000000000000",   --R0
--                                     "00000000000000000000000000000000",   --R1
--                                     "00000000000000000000000000000011",   --R2
--                                     "00000000000000000000000000000010",   --R3
--                                     "00000000000000000000000000000100",   --R4
--                                     "00000000000000000000000000000101",   --R5
--                                     "00000000000000000000000000000110",   --R6
                                     others=> (others=>'0')
                                     );
begin
    REGISTERS(to_integer(unsigned(ADD_WR))) <= DATAIN when WR = '1';
    OUT1 <= REGISTERS(to_integer(unsigned(ADD_RD1))) when RD1 = '1';
    OUT2 <= REGISTERS(to_integer(unsigned(ADD_RD2))) when RD2 = '1';
end A;