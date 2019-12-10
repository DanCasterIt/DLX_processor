library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity DLX is
    generic(
        --PROGRAM & DATA MEMORY GENERICS
        nbit_addr: integer := 32;
        nbit_cells: integer := 32;
        --REGISTERFILE GENERICS
        nbit_reg_addr: integer := 5;
	    nbit_reg: integer := 32
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
end DLX;

architecture dataflow of DLX is
component ALU is
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
end component;
component control_unit is
	port(
	   Clk : in std_logic;
	   Rst : in std_logic;
       instruction_bus : in std_logic_vector(31 downto 0);
       PC_drive : out std_logic;
	   ---pipe stage 1---
	   RF1: out std_logic;
	   RF2: out std_logic;
	   SESel: out std_logic;
	   EN1: out std_logic;
	   ---pipe stage 2---
	   S1: out std_logic;
	   S2: out std_logic;
	   ALU: out std_logic_vector(4 downto 0);
	   ZSel: out std_logic;
	   EN2: out std_logic;
	   ---pipe stage 3---
	   RM: out std_logic;
	   WM: out std_logic;
	   BraE: out std_logic;
	   JmpE: out std_logic;
	   EN3: out std_logic;
	   ---pipe stage 4---
	   S3: out std_logic;
       WF1: out std_logic;
	   RegDst: out std_logic;
       EN0: out std_logic
    );
end component;
component D_Flip_Flop is
	generic (
		Nbit : integer := 5
	);
    port (
        clk: in std_logic;
        en: in std_logic;
        d: in std_logic_vector(Nbit-1 downto 0);
        q: out std_logic_vector(Nbit-1 downto 0)
    );
end component;
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
constant data_bus_len		: integer := 5;
constant adress_bus_len		: integer := 5;
constant n_reg				: integer := 5;
signal CU_to_ALU																					: std_logic_vector(4 downto 0) := (others => '0');
signal S1, S2, S3, EN0, EN1, EN2, EN3, BC_to_brnc_logic, BraE, JmpE									: std_logic := '0';
signal RF1, RF2, WF1, WM, RM, SEsel, ZSel, is_zero_to_BC_reg										: std_logic := '0';
signal WF1_to_RF, RF1_to_RF, RF2_to_RF, jump_logic_to_add_mux, HDU_to_PCen, RegDst					: std_logic := '0';
signal buffA, buffB, PC_to_IM_and_add, NPC_to_NPC1_and_JAL											: std_logic_vector((2**adress_bus_len)-1 downto 0) := (others => '0');
signal instruction_bus, IR_bus, RF_to_R0RD_A, RF_to_R0RD_B, SE_to_SEREG, A_mux_to_ALU, WB_mux_to_JAL_mux	: std_logic_vector((2**data_bus_len)-1 downto 0) := (others => '0');
signal A_to_A_mux_and_is_zero, B_to_B_mux_and_B1, SEREG_to_B_mux, NPC1_to_mux_A, ALU_to_ALUOut_reg	: std_logic_vector((2**data_bus_len)-1 downto 0) := (others => '0');
signal ALUOut_reg_to_DM_addr_and_mux_add, B1_to_DM_dat, DM_to_MD_reg, MD_to_WB_mux, JAL_mux_to_RF	: std_logic_vector((2**data_bus_len)-1 downto 0) := (others => '0');
signal add_to_mux, mux_to_NPC_and_PC, R0RD_to_A_reg, R0RD_to_B_reg, B_mux_to_ALU, ALUOut1_to_WB_mux	: std_logic_vector((2**data_bus_len)-1 downto 0) := (others => '0');
signal JAL_to_IR1_reg, IR1_to_IR2, IR2_to_IR3, IR3_to_RF_mux										: std_logic_vector(10-1 downto 0) := (others => '0');
signal RF_mux_to_RF_and_R0RW																		: std_logic_vector(5-1 downto 0) := (others => '0');
signal JAL_to_JAL_reg, JAL_reg_to_JAL1_reg, JAL1_reg_to_JAL2_reg, JAL2_reg_to_JAL_mux				: std_logic_vector(2**adress_bus_len downto 0) := (others => '0');
begin
    control_unit_instance : control_unit
        port map(
               Clk => clk,
               Rst => rst,
			   instruction_bus => instruction_bus,
			   PC_drive => HDU_to_PCen,
               ---pipe stage 1---
               RF1 => RF1,
               RF2 => RF2,
               SESel => SESel,
               EN1 => EN1,
               ---pipe stage 2---
               S1 => S1,
               S2 => S2,
               ALU => CU_to_ALU,
               ZSel => ZSel,
               EN2 => EN2,
               ---pipe stage 3---
               RM => RM,
               WM => WM,
               BraE => BraE,
               JmpE => JmpE,
               EN3 => EN3,
               ---pipe stage 4---
               S3 => S3,
               WF1 => WF1,
			   RegDst => RegDst,
               EN0 => EN0
            );
    --Instruction fetch(IF)
    PC_register : D_Flip_Flop
        generic map(Nbit => 2**adress_bus_len)
        port map(en => HDU_to_PCen, clk => clk, d => mux_to_NPC_and_PC, q => buffA);
    POST_PC_register : D_Flip_Flop
        generic map(Nbit => 2**adress_bus_len)
        port map(en => HDU_to_PCen, clk => clk, d => buffA, q => buffB);
    decisor : process(buffB, buffA, HDU_to_PCen)
    begin
        if HDU_to_PCen = '1' then
            PC_to_IM_and_add <= buffB;
        else
            PC_to_IM_and_add <= buffA;
        end if;
    end process;
    instruction_memory : process(PC_to_IM_and_add, P_MEM_OUT)
    begin
        P_ADD_RD <= PC_to_IM_and_add;
        instruction_bus <= P_MEM_OUT;
    end process;
              --IF/ID registers
    IR_register : D_Flip_Flop
        generic map(Nbit => 2**data_bus_len)
        port map(en => EN0, clk => clk, d => instruction_bus, q => IR_bus);
    NPC_register : D_Flip_Flop
        generic map(Nbit => 2**adress_bus_len)
        port map(en => EN0, clk => clk, d => mux_to_NPC_and_PC, q => NPC_to_NPC1_and_JAL);
    PC_adder: process(rst, PC_to_IM_and_add)
    begin
        if rst = '1' then
            add_to_mux <= (others => '0');
        else
            add_to_mux <= std_logic_vector(to_unsigned(4, data_bus_len)) + PC_to_IM_and_add;
        end if;
    end process;
    PC_mux : multiplexer
        generic map(Nbit => 2**adress_bus_len)
        port map(X => ALUOut_reg_to_DM_addr_and_mux_add, Y => add_to_mux, sel => jump_logic_to_add_mux, Z => mux_to_NPC_and_PC );
    --Instruction decode/register fetch(ID)
    RF_mux : multiplexer
        generic map(Nbit => 5)
        port map(X => IR3_to_RF_mux(9 downto 5), Y => IR3_to_RF_mux(4 downto 0), sel => RegDst, Z => RF_mux_to_RF_and_R0RW );
	R0_write_detect : process(WF1, RF_mux_to_RF_and_R0RW)	--mostly to prevent useless switchings in memory
	begin
		if(RF_mux_to_RF_and_R0RW = "00000") then
			WF1_to_RF <= '0';
		else
			WF1_to_RF <= WF1;			
		end if;
	end process;
	Register_file_unit : process(RF1_to_RF, RF2_to_RF, WF1_to_RF, RF_mux_to_RF_and_R0RW, IR_bus(25 downto 16), JAL_mux_to_RF, R_OUT1, R_OUT2)
	begin
        R_RD1 <= RF1_to_RF;
        R_RD2 <= RF2_to_RF;
        R_WR <= WF1_to_RF;
        R_ADD_WR <= RF_mux_to_RF_and_R0RW;   --destination register address
        R_ADD_RD1 <= IR_bus(25 downto 21);   --source register 1 address
        R_ADD_RD2 <= IR_bus(20 downto 16);   --source register 2 address
        R_DATAIN <= JAL_mux_to_RF;
        RF_to_R0RD_A <= R_OUT1;
        RF_to_R0RD_B <= R_OUT2;
	end process;
	R0_read_detect : process(IR_bus(25 downto 16), RF_to_R0RD_A, RF_to_R0RD_B, RF1, RF2)
	begin
		if(IR_bus(25 downto 21) = "00000" and RF1 = '1') then	--A
			RF1_to_RF <= '0';
			R0RD_to_A_reg <= (others => '0');
		else
			RF1_to_RF <= RF1;
			R0RD_to_A_reg <= RF_to_R0RD_A;
		end if;
		if(IR_bus(20 downto 16) = "00000" and RF2 = '1') then	--B
			RF2_to_RF <= '0';
			R0RD_to_B_reg <= (others => '0');
		else
			RF2_to_RF <= RF2;
			R0RD_to_B_reg <= RF_to_R0RD_B;
		end if;
	end process;
    sign_extender : process(SEsel, IR_bus(25 downto 0))
    begin
        if SEsel = '1' then   --16-bit extend
            if IR_bus(15) = '1' then
                SE_to_SEREG <= ("1111111111111111"&IR_bus(15 downto 0));
             else
                SE_to_SEREG <= ("0000000000000000"&IR_bus(15 downto 0));
             end if;
        else   --26-bit extend
            if IR_bus(25) = '1' then
                SE_to_SEREG <= ("111111"&IR_bus(25 downto 0));
            else
                SE_to_SEREG <= ("000000"&IR_bus(25 downto 0));
            end if;
        end if;
    end process;
	JAL_detection : process(IR_bus, NPC_to_NPC1_and_JAL)
	begin
		if(IR_bus(31 downto 26) = "000011" or			--if JAL  operation code is detected OR
		IR_bus(31 downto 26) = "010011") then			--if JALR operation code is detected
			JAL_to_IR1_reg(10-1 downto 5) <= "11111";	--forces R31
			JAL_to_IR1_reg(5-1 downto 0) <= IR_bus(15 downto 11);
			JAL_to_JAL_reg(2**adress_bus_len downto 1) <= std_logic_vector(to_unsigned(8, 2**adress_bus_len)) + NPC_to_NPC1_and_JAL;
			JAL_to_JAL_reg(0) <= '1';
		else
			JAL_to_IR1_reg <= IR_bus(20 downto 11);
			JAL_to_JAL_reg <= (others => '0');
		end if;
	end process;
               --ID/EX registers
    NPC1_register : D_Flip_Flop
        generic map(Nbit => 2**adress_bus_len)
        port map(en => EN1, clk => clk, d => NPC_to_NPC1_and_JAL, q => NPC1_to_mux_A);
    A_register : D_Flip_Flop
        generic map(Nbit => 2**data_bus_len)
        port map(en => EN1, clk => clk, d => R0RD_to_A_reg, q => A_to_A_mux_and_is_zero);
    B_register : D_Flip_Flop
        generic map(Nbit => 2**data_bus_len)
        port map(en => EN1, clk => clk, d => R0RD_to_B_reg, q => B_to_B_mux_and_B1);
    SEREG_register : D_Flip_Flop
        generic map(Nbit => 2**data_bus_len)
        port map(en => EN1, clk => clk, d => SE_to_SEREG, q => SEREG_to_B_mux);
    IR1_register : D_Flip_Flop
        generic map(Nbit => 10)
        port map(en => EN1, clk => clk, d => JAL_to_IR1_reg, q => IR1_to_IR2);    --I save only the possible output registers address
    JAL_register : D_Flip_Flop
        generic map(Nbit => (2**data_bus_len)+1)
        port map(en => EN1, clk => clk, d => JAL_to_JAL_reg, q => JAL_reg_to_JAL1_reg);
    --Execution/effective address cycle(EX)
    mux_A : multiplexer
        generic map(Nbit => 2**data_bus_len)
        port map(X => NPC1_to_mux_A, Y => A_to_A_mux_and_is_zero, sel => S1, Z => A_mux_to_ALU);
    mux_B : multiplexer
        generic map(Nbit => 2**data_bus_len)
        port map(X => B_to_B_mux_and_B1, Y => SEREG_to_B_mux, sel => S2, Z => B_mux_to_ALU);
    ALU_unit : ALU
        generic map(
            Nbit => data_bus_len--,
            --Ncarry => 2
        )
        port map(
            alu => CU_to_ALU,
            A => A_mux_to_ALU,
            B => B_mux_to_ALU,
            alu_out => ALU_to_ALUOut_reg
        );
    is_equal : process(ZSel, A_to_A_mux_and_is_zero)
    begin
        if ZSel = '1' then
            if A_to_A_mux_and_is_zero = std_logic_vector(to_unsigned(0, A_to_A_mux_and_is_zero'length)) then
                is_zero_to_BC_reg <= '1';
            else
                is_zero_to_BC_reg <= '0';
            end if;
        else
            is_zero_to_BC_reg <= '0';
        end if;
    end process;
               --EX/MEM
    BC_register : D_Flip_Flop
        generic map(Nbit => 1)
        port map(en => EN2, clk => clk, d(0) => is_zero_to_BC_reg, q(0) => BC_to_brnc_logic);
    ALUOut_register : D_Flip_Flop
        generic map(Nbit => 2**data_bus_len)
        port map(en => EN2, clk => clk, d => ALU_to_ALUOut_reg, q => ALUOut_reg_to_DM_addr_and_mux_add);
    B1_register : D_Flip_Flop
        generic map(Nbit => 2**data_bus_len)
        port map(en => EN2, clk => clk, d => B_to_B_mux_and_B1, q => B1_to_DM_dat);
    IR2_register : D_Flip_Flop
        generic map(Nbit => 10)
        port map(en => EN2, clk => clk, d => IR1_to_IR2, q => IR2_to_IR3);
    JAL1_register : D_Flip_Flop
        generic map(Nbit => (2**data_bus_len)+1)
        port map(en => EN2, clk => clk, d => JAL_reg_to_JAL1_reg, q => JAL1_reg_to_JAL2_reg);
    --Memory access/branch completion(MEM)
    data_memory : process(EN3, RM, WM, ALUOut_reg_to_DM_addr_and_mux_add, B1_to_DM_dat, D_MEM_OUT)
    begin
        D_EN <= EN3;
        D_RD <= RM;
        D_WR <= WM;
        D_ADD_WR <= ALUOut_reg_to_DM_addr_and_mux_add;
        D_ADD_RD <= ALUOut_reg_to_DM_addr_and_mux_add;
        D_MEM_DATAIN <= B1_to_DM_dat;
        DM_to_MD_reg <= D_MEM_OUT;
    end process;
    jump_logic : process(BraE, JmpE, BC_to_brnc_logic)
    begin
        jump_logic_to_add_mux <= (BC_to_brnc_logic and BraE) or JmpE;
    end process;
               --MEM/WB
    MD_register : D_Flip_Flop
        generic map(Nbit => 2**data_bus_len)
        port map(en => EN3, clk => clk, d => DM_to_MD_reg, q => MD_to_WB_mux);
    ALUOut1_register : D_Flip_Flop
        generic map(Nbit => 2**data_bus_len)
        port map(en => EN3, clk => clk, d => ALUOut_reg_to_DM_addr_and_mux_add, q => ALUOut1_to_WB_mux);
    IR3_register : D_Flip_Flop
        generic map(Nbit => 10)
        port map(en => EN3, clk => clk, d => IR2_to_IR3, q => IR3_to_RF_mux);
    JAL2_register : D_Flip_Flop
        generic map(Nbit => (2**data_bus_len)+1)
        port map(en => EN3, clk => clk, d => JAL1_reg_to_JAL2_reg, q => JAL2_reg_to_JAL_mux);
    --Write-back(WB)
    WB_mux : multiplexer
        generic map(Nbit => 2**data_bus_len)
        port map(X => MD_to_WB_mux, Y => ALUOut1_to_WB_mux, sel => S3, Z => WB_mux_to_JAL_mux );
    JAL_mux : multiplexer
        generic map(Nbit => 2**data_bus_len)
        port map(X => JAL2_reg_to_JAL_mux(2**data_bus_len downto 1), Y => WB_mux_to_JAL_mux, sel => JAL2_reg_to_JAL_mux(0), Z => JAL_mux_to_RF );
end dataflow;