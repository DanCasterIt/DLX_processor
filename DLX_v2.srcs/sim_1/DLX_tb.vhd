library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DLXtb is
end DLXtb;

architecture arch of DLXtb is
    component DLX is
    generic(
        --PROGRAM & DATA MEMORY GENERICS
        nbit_addr: integer := 32;
        nbit_cells: integer := 32;
        --REGISTERFILE GENERICS
        nbit_reg_addr: integer := 32;
	    nbit_reg: integer := 5
	);
    port(
        clk, rst : in std_logic;
        --PROGRAM MEMORY SIGNALS
        P_ADD_RD :    OUT std_logic_vector(nbit_addr-1 downto 0);
        P_MEM_OUT :   IN std_logic_vector(nbit_cells-1 downto 0);
		--REGISTERFILE SIGNALS
        R_RD1:        OUT std_logic;
        R_RD2:        OUT std_logic;
        R_WR:         OUT std_logic;
        R_ADD_WR:     OUT std_logic_vector(nbit_reg_addr-1 downto 0);
        R_ADD_RD1:    OUT std_logic_vector(nbit_reg_addr-1 downto 0);
        R_ADD_RD2:    OUT std_logic_vector(nbit_reg_addr-1 downto 0);
        R_DATAIN:     OUT std_logic_vector(nbit_reg-1 downto 0);
        R_OUT1:       IN std_logic_vector(nbit_reg-1 downto 0);
        R_OUT2:       IN std_logic_vector(nbit_reg-1 downto 0);
        --DATA MEMORY SIGNALS
        D_EN:         OUT std_logic;
        D_RD:         OUT std_logic;
        D_WR:         OUT std_logic;
        D_ADD_WR:     OUT std_logic_vector(nbit_addr-1 downto 0);
        D_ADD_RD:     OUT std_logic_vector(nbit_addr-1 downto 0);
        D_MEM_DATAIN: OUT std_logic_vector(nbit_cells-1 downto 0);
        D_MEM_OUT:    IN std_logic_vector(nbit_cells-1 downto 0)
    );
    end component;
    component program_memory is
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
    end component;
	component register_file is
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
	end component;
    component data_memory is
        generic(
           nbit_addr: integer;
           nbit_cells: integer;
           n_cells: integer
        );
        port(
           RD:             IN std_logic;
           WR:             IN std_logic;
           ADD_WR:         IN std_logic_vector(nbit_addr-1 downto 0);
           ADD_RD:         IN std_logic_vector(nbit_addr-1 downto 0);
           DATAIN:         IN std_logic_vector(nbit_cells-1 downto 0);
           OUTP:           OUT std_logic_vector(nbit_cells-1 downto 0)
        );
    end component;
    constant Period: time := 1 ns; -- Clock period (1 GHz)
    constant nbit_addr : integer := 32;
    constant nbit_cells : integer := 32;
    constant n_cells : integer := 70;
    constant nbit_reg: integer:= 32;
	constant n_reg: integer := 32;
	constant nbit_reg_addr: integer := 5;
    signal clk, rst : std_logic := '0';
    signal P_MEM_OUT, D_MEM_DATAIN, D_MEM_OUT,D_MEM_DATAINd : std_logic_vector(nbit_cells-1 downto 0);
    signal D_EN, D_RD, D_WR, R_RD1, R_RD2, R_WR, R_RD1d, R_RD2d, R_WRd, D_ENd, D_RDd, D_WRd : std_logic;
    signal D_ADD_WR, D_ADD_RD, P_ADD_RD, D_ADD_WRd, D_ADD_RDd : std_logic_vector(nbit_addr-1 downto 0);
    signal R_DATAIN, R_OUT1, R_OUT2, R_DATAINd : std_logic_vector(nbit_reg-1 downto 0);
	signal R_ADD_WR, R_ADD_RD1, R_ADD_RD2, R_ADD_WRd, R_ADD_RD1d, R_ADD_RD2d : std_logic_vector(nbit_reg_addr-1 downto 0);
begin
    dut : DLX generic map(
        nbit_addr => nbit_addr,
		nbit_reg_addr => nbit_reg_addr,
	    nbit_cells => nbit_cells,
		nbit_reg => nbit_reg
	)
    port map(
        clk => clk,
        rst => rst,
        --PROGRAM MEMORY SIGNALS
        P_ADD_RD => P_ADD_RD,
        P_MEM_OUT => P_MEM_OUT,
		--REGISTERFILE
        R_RD1 => R_RD1,
        R_RD2 => R_RD2,
        R_WR => R_WR,
        R_ADD_WR => R_ADD_WR,
        R_ADD_RD1 => R_ADD_RD1,
        R_ADD_RD2 => R_ADD_RD2,
        R_DATAIN => R_DATAIN,
        R_OUT1 => R_OUT1,
        R_OUT2 => R_OUT2,
        --DATA MEMORY SIGNALS
        D_EN => D_EN,
        D_RD => D_RD,
        D_WR => D_WR,
        D_ADD_WR => D_ADD_WR,
        D_ADD_RD => D_ADD_RD,
        D_MEM_DATAIN => D_MEM_DATAIN,
        D_MEM_OUT => D_MEM_OUT
    );
    dut_prog_mem : program_memory generic map(
        nbit_addr => nbit_addr,
        nbit_cells => nbit_cells,
        n_cells => n_cells
    )
    port map(
        RESET => rst,
        ENABLE => '1',
        RD => '1',
        ADD_RD(nbit_addr-3 downto 0) => P_ADD_RD(nbit_addr-1 downto 2),
		ADD_RD(nbit_addr-1 downto nbit_addr-2) => "00",
        OUTP => P_MEM_OUT
    );
	dut_registerfile : register_file generic map(
        nbit_addr => nbit_reg_addr,
	    nbit_reg => nbit_reg,
	    n_reg => n_reg
	)
	port map(
	    RD1 => R_RD1d,
	    RD2 => R_RD2d,
	    WR => R_WRd,
	    ADD_WR => R_ADD_WRd,
	    ADD_RD1 => R_ADD_RD1d,
	    ADD_RD2 => R_ADD_RD2d,
	    DATAIN => R_DATAINd,
        OUT1 => R_OUT1,
	    OUT2 => R_OUT2
    );
    dut_data_mem : data_memory generic map(
         nbit_addr => nbit_addr,
         nbit_cells => nbit_cells,
         n_cells => n_cells
    )
    port map(
         RD => D_RDd,
         WR => D_WRd,
         ADD_WR => D_ADD_WRd,
         ADD_RD => D_ADD_RDd,
         DATAIN => D_MEM_DATAINd,
         OUTP => D_MEM_OUT
    );
    clk <= not clk after Period/2;
    rst <= '1', '0' after (Period + (Period/2));
	--REGISTERFILE INERTIAL DELAYES (to prevent glitches)
    R_RD1d <= reject 100ps inertial R_RD1 after 100ps;
    R_RD2d <= reject 100ps inertial R_RD2 after 100ps;
    R_WRd <= reject 100ps inertial R_WR after 100ps;
    R_ADD_WRd <= reject 100ps inertial R_ADD_WR after 100ps;
    R_ADD_RD1d <= reject 100ps inertial R_ADD_RD1 after 100ps;
    R_ADD_RD2d <= reject 100ps inertial R_ADD_RD2 after 100ps;
    R_DATAINd <= reject 100ps inertial R_DATAIN after 100ps;
	--DATA MEMORY INERTIAL DELAYES (to prevent glitches)
    D_ENd <= reject 100ps inertial D_EN after 100ps;
    D_RDd <= reject 100ps inertial D_RD after 100ps;
    D_WRd <= reject 100ps inertial D_WR after 100ps;
    D_ADD_WRd <= reject 100ps inertial D_ADD_WR after 100ps;
    D_ADD_RDd <= reject 100ps inertial D_ADD_RD after 100ps;
	D_MEM_DATAINd <= reject 100ps inertial D_MEM_DATAIN after 100ps;
end arch;