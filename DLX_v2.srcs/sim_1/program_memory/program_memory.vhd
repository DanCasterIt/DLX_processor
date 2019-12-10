library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_signed.all;
use IEEE.numeric_std.all;
use WORK.rf_and_mem_constants.all;
USE std.textio.ALL;
use ieee.std_logic_textio.all;

entity program_memory is
    generic(
       nbit_addr: integer;
	   nbit_cells: integer;
	   n_cells: integer
	);
    port(
       RESET :      IN std_logic;
	   ENABLE :     IN std_logic;
	   RD :         IN std_logic;
	   ADD_RD :     IN std_logic_vector(nbit_addr-1 downto 0);
       OUTP :       OUT std_logic_vector(nbit_cells-1 downto 0)
	);
end program_memory;

architecture A of program_memory is
    subtype MEM_ADDR is natural range 0 to n_cells-1; -- using natural type
	type PROGRAM_MEMORY_CELLS_ARRAY is array(MEM_ADDR) of std_logic_vector(nbit_cells-1 downto 0); 
	signal PROGRAM_MEMORY_CELLS : PROGRAM_MEMORY_CELLS_ARRAY := (others=> (others=>'0'));
begin
	mem: process(RESET, ENABLE, RD, ADD_RD, PROGRAM_MEMORY_CELLS)
    FILE vectorfile: text;
    VARIABLE inputline: LINE;
    VARIABLE var : std_logic_vector(nbit_cells-1 downto 0);
    variable cnt : integer := 0;
    variable empty_row : boolean;
	begin
		---- RESET ASYNCHRONOUS ----
		if(RESET = '1') then
            OUTP <= ("010101"&(nbit_cells-1 downto 6 => '0'));
            cnt := 0;
            file_open(vectorfile, "source.txt", read_mode);
            WHILE NOT endfile(vectorfile) LOOP
                readline(vectorfile, inputline);
                hread(inputline, var, empty_row);
                if empty_row then
                    PROGRAM_MEMORY_CELLS(cnt) <= var;
                else
                    PROGRAM_MEMORY_CELLS(cnt) <= PROGRAM_MEMORY_CELLS(cnt-1);
                end if;
                cnt := cnt + 1;
            END LOOP;
            file_close(vectorfile);
		else
			if(ENABLE = '1') then
				if(RD = '1')then
					OUTP <= PROGRAM_MEMORY_CELLS(to_integer(unsigned(ADD_RD)));
				end if;
			end if;
		end if;
	end process mem;
end A;