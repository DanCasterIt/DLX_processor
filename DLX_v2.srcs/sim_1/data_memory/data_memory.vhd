library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_signed.all;
use IEEE.numeric_std.all;
use WORK.rf_and_mem_constants.all;

entity data_memory is
    generic(
       nbit_addr: integer;
	   nbit_cells: integer;
	   n_cells: integer
	);
    port(
	   RD: 		    IN std_logic;
	   WR: 			IN std_logic;
	   ADD_WR: 		IN std_logic_vector(nbit_addr-1 downto 0);
	   ADD_RD: 	    IN std_logic_vector(nbit_addr-1 downto 0);
	   DATAIN: 		IN std_logic_vector(nbit_cells-1 downto 0);
       OUTP: 		OUT std_logic_vector(nbit_cells-1 downto 0)
	);
end data_memory;

architecture A of data_memory is
    subtype MEM_ADDR is natural range 0 to n_cells-1; -- using natural type
	type DATA_MEMORY_CELLS_ARRAY is array(MEM_ADDR) of std_logic_vector(nbit_cells-1 downto 0); 
	signal DATA_MEMORY_CELLS : DATA_MEMORY_CELLS_ARRAY := (others=> (others=>'0'));
begin
	DATA_MEMORY_CELLS(to_integer(unsigned(ADD_WR))) <= DATAIN when WR = '1';
	OUTP <= DATA_MEMORY_CELLS(to_integer(unsigned(ADD_RD)))when RD = '1';
end A;