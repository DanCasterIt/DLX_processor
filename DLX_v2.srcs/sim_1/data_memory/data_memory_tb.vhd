library IEEE;
use IEEE.std_logic_1164.all;
use WORK.rf_and_mem_constants.all;

entity data_memory_tb is
end data_memory_tb;

architecture TESTA of data_memory_tb is
component data_memory is
    generic(
       nbit_addr: integer;
	   nbit_cells: integer;
	   n_cells: integer
	);
    port(
       RESET: 		IN std_logic;
	   ENABLE: 		IN std_logic;
	   RD: 		    IN std_logic;
	   WR: 			IN std_logic;
	   ADD_WR: 		IN std_logic_vector(nbit_addr-1 downto 0);
	   ADD_RD: 	    IN std_logic_vector(nbit_addr-1 downto 0);
	   DATAIN: 		IN std_logic_vector(nbit_cells-1 downto 0);
       OUTP: 		OUT std_logic_vector(nbit_cells-1 downto 0)
	);
end component;
signal RESET: std_logic;
signal ENABLE: std_logic;
signal RD: std_logic;
signal WR: std_logic;
signal ADD_WR: std_logic_vector(4 downto 0);
signal ADD_RD: std_logic_vector(4 downto 0);
signal DATAIN: std_logic_vector(31 downto 0);
signal OUTP: std_logic_vector(31 downto 0);
begin 
mem : data_memory
    generic map(nbit_addr => 5, nbit_cells => 32, n_cells => 32)
    PORT MAP (RESET => RESET, ENABLE => ENABLE, RD => RD, WR => WR ,ADD_WR => ADD_WR ,ADD_RD => ADD_RD, DATAIN => DATAIN, OUTP => OUTP);
	RESET <= '1','0' after 1 ns;
	ENABLE <= '0','1' after 2 ns;
	WR <= '0';--,'1' after 6 ns, '0' after 7 ns, '1' after 10 ns, '0' after 20 ns;
	RD <= '1';--,'0' after 5 ns, '1' after 13 ns, '0' after 20 ns; 
	ADD_WR <= "00000";--"10110", "01000" after 9 ns;
	ADD_RD <= "00000", "00001" after 3ns, "00010" after 4ns, "00011" after 5ns, "11111" after 6ns, "11110" after 7ns;--"10110", "01000" after 9 ns;
	DATAIN <=(others => '0');--,(others => '1') after 8 ns;
end TESTA;