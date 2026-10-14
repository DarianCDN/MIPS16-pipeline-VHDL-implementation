
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity test_env_pipeline is
       Port(
            led: out std_logic_vector(15 downto 0);
            sw: in std_logic_vector(7 downto 0);
            an: out std_logic_vector(3 downto 0);
            cat: out std_logic_vector(6 downto 0);
            btn : in STD_LOGIC_vector(4 downto 0);
            clk : in STD_LOGIC);
end test_env_pipeline;
            
architecture Behavioral of test_env_pipeline is

component mpg_4but is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0); --CULRD
           en : out STD_LOGIC_VECTOR (4 downto 0));
end component;

component CU is
    Port ( instr : in STD_LOGIC_VECTOR (15 downto 13);
           RegDst : out STD_LOGIC;
           ExtOp : out STD_LOGIC;
           ALUSrc : out STD_LOGIC;
           Branch : out STD_LOGIC;
           Jump : out STD_LOGIC;
           ALUOp : out STD_LOGIC_VECTOR (2 downto 0);
           MemWrite : out STD_LOGIC;
           MemToReg : out STD_LOGIC;
           RegWrite : out STD_LOGIC);
end component;

component Instruction_fetch is
    Port ( Jump : in STD_LOGIC;
           PCSrc : in STD_LOGIC;
           clk: in std_logic;
           Jump_addr: in std_logic_vector(15 downto 0);
           Branch_addr: in std_logic_vector(15 downto 0);
           PC_next : out STD_LOGIC_VECTOR (15 downto 0);
           Instruction : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component Data_Memory is
    Port ( MemWrite : in STD_LOGIC;
           clk: in std_logic;
           ALUResIn : in STD_LOGIC_VECTOR (15 downto 0);
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           MemData: out std_logic_vector(15 downto 0);
           ALUResOut: out std_logic_vector(15 downto 0));
end component;

component instruction_decode is
    Port ( RegWrite : in STD_LOGIC;
           RegDst : in STD_LOGIC;
           ExtOp : in STD_LOGIC;
           Instr : in STD_LOGIC_VECTOR (15 downto 0);
           Wd : in STD_LOGIC_VECTOR (15 downto 0);
           clk: in std_logic;
           wa: in std_logic_vector(2 downto 0);
           rd1 : out STD_LOGIC_VECTOR (15 downto 0);
           rd2 : out STD_LOGIC_VECTOR (15 downto 0);
           Ext_Imm : out STD_LOGIC_VECTOR (15 downto 0);
           func : out STD_LOGIC_VECTOR (2 downto 0);
           sa : out STD_LOGIC);
end component;

component ExecutionUnit is
    Port ( PC_next : in STD_LOGIC_VECTOR (15 downto 0);
           RD1 : in STD_LOGIC_VECTOR (15 downto 0);
           ALUsrc : in STD_LOGIC;
           RD2: in std_logic_vector(15 downto 0);
           Ext_Imm: in std_logic_vector(15 downto 0);
           sa: in std_logic;
           func: in std_logic_vector(2 downto 0);
           ALUOp: in std_logic_vector(2 downto 0);
           BranchAddress: out std_logic_vector(15 downto 0);
           Zero: out std_logic;
           ALURes: out std_logic_vector(15 downto 0));
end component;

signal zero, sa, jump, PCSrc, RegWrite, ExtOp, RegDst, ALUSrc, Branch, MemWrite, MemtoReg: std_logic;
signal Jump_Addr, Branch_Addr, PC_next, instruction: std_logic_vector(15 downto 0);
signal RD1, RD2, WD, Ext_Imm, ALURes: std_logic_vector(15 downto 0);
signal func: std_logic_vector(2 downto 0);
signal ALUOp: std_logic_vector(2 downto 0);
signal ALUResOut, MemData: std_logic_vector(15 downto 0);

signal wa : std_logic_vector(2 downto 0);
 
component ssd is
    Port ( 
          digit0: in std_logic_vector(3 downto 0);
          digit1: in std_logic_vector(3 downto 0);
          digit2: in std_logic_vector(3 downto 0);
          digit3: in std_logic_vector(3 downto 0);
          cat: out std_logic_vector(6 downto 0);
          an: out std_logic_vector(3 downto 0);
          clk : in STD_LOGIC);

end component;

signal digit0, digit1, digit2, digit3: std_logic_vector(3 downto 0);

signal en: std_logic_vector(4 downto 0);
signal clock: std_logic;

signal IF_ID : std_logic_vector(31 downto 0);
signal ID_EX : std_logic_vector(81 downto 0);
signal EX_MEM : std_logic_vector(55 downto 0);
signal MEM_WB : std_logic_vector(36 downto 0);


begin

mpg: mpg_4but port map (btn => btn, clk => clk, en => en);
clock <= en(0);

InstrFetch: instruction_fetch port map (Branch_Addr => EX_MEM(51 downto 36), instruction => instruction, clk => clock, Jump => Jump, PCSrc =>PCSrc, PC_next => PC_next, Jump_Addr => Jump_Addr);

InstrDec: instruction_decode port map(clk => clock, wa => MEM_WB(2 downto 0), RegWrite => MEM_WB(35), Instr=> if_id(15 downto 0), RegDst => RegDst, ExtOp => ExtOp, sa => sa, func => func, Ext_Imm => Ext_Imm, WD => WD, RD1 => RD1, RD2 => RD2);

ControlUnit: CU port map (instr=> if_id(15 downto 13), RegDst => RegDst, ExtOp => ExtOp, ALUSrc => ALUSrc, Branch => Branch, Jump => Jump, ALUOp => ALUOp, MemWrite => MemWrite, MemtoReg => MemtoReg, RegWrite => RegWrite);

EU: ExecutionUnit port map (PC_next => ID_EX(81 downto 66), RD1 => ID_EX(56 downto 41), RD2 => ID_EX(40 downto 25), Ext_Imm => ID_EX(21 downto 6), ALUSrc =>ID_EX(59), sa => ID_EX(57), func => ID_EX(24 downto 22), ALUOp => ID_EX(62 downto 60), ALURes => ALURes, zero => zero, BranchAddress => Branch_Addr);

Memory_Unit: Data_Memory port map (RD2 => EX_MEM(18 downto 3), MemWrite => EX_MEM(53), ALUResIn => EX_MEM(34 downto 19), clk => clock, MemData => MemData, AluResOut => AluResOut);

writeback_mux: process(MEM_WB)
begin
if MEM_WB(36) = '1' then
    WD <= MEM_WB(34 downto 19);
else WD <= MEM_WB(18 downto 3);
end if;
end process;

process(sw(7 downto 5))
begin
case sw(7 downto 5) is
    when "000" => digit0 <= instruction(3 downto 0);
                digit1 <= instruction(7 downto 4);
                digit2 <= instruction(11 downto 8);
                digit3 <= instruction(15 downto 12);
    when "001" => digit0 <= PC_next(3 downto 0);
                digit1 <= PC_next(7 downto 4);
                digit2 <= PC_next(11 downto 8);
                digit3 <= PC_next(15 downto 12);
    when "010" => digit0 <= RD1(3 downto 0);
                  digit1 <= RD1(7 downto 4);
                  digit2 <= RD1(11 downto 8);
                  digit3 <= RD1(15 downto 12);
    when "011" => digit0 <= RD2(3 downto 0);
                  digit1 <= RD2(7 downto 4);
                  digit2 <= RD2(11 downto 8);
                  digit3 <= RD2(15 downto 12);
    when "100" => digit0 <= Ext_Imm(3 downto 0);
                  digit1 <= Ext_Imm(7 downto 4);
                  digit2 <= Ext_Imm(11 downto 8);
                  digit3 <= Ext_Imm(15 downto 12);
    when "101" => digit0 <= ALURes(3 downto 0);
                  digit1 <= ALURes(7 downto 4);
                  digit2 <= ALURes(11 downto 8);
                  digit3 <= ALURes(15 downto 12);  
    when "110" => digit0 <= MemData(3 downto 0);
                  digit1 <= MemData(7 downto 4);
                  digit2 <= MemData(11 downto 8);
                  digit3 <= MemData(15 downto 12);
    when others => digit0 <= WD(3 downto 0);
                   digit1 <= WD(7 downto 4);
                   digit2 <= WD(11 downto 8);
                   digit3 <= WD(15 downto 12);               
end case;

end process;

SSD_instr: ssd port map (digit0 => digit0, digit1 => digit1, digit2 => digit2, digit3 => digit3, cat => cat, an => an, clk => clk);

process(sw(0))
begin
if sw(0) = '0' then 
    led(0) <= RegDst;
    led(1) <= ExtOp;
    led(2) <= ALUSrc;
    led(3) <= Branch;
    led(4) <= Jump;
    led(5) <= MemWrite;
    led(6) <= MemtoReg;
    led(7) <= RegWrite;
    led(15 downto 8) <= "00000000";
else led(2 downto 0) <= ALUOp;
    led(15 downto 3) <= "0000000000000";
end if;
end process;

PCSrc <= EX_MEM(52) and EX_MEM(35);

Jump_Addr <= if_id(31 downto 29) & if_id(12 downto 0);

IFID: process(pc_next, instruction, clock)
begin
if rising_edge(clock) then
    if_id(31 downto 16) <= pc_next;
    if_id(15 downto 0) <= instruction;
end if;
end process;
 
IDEX: process(clock, MemToReg, RegWrite, MemWrite, ALUOP, ALUSrc, RegDst, RD1, RD2, Ext_Imm, func, IF_ID(15 downto 0))
begin

if rising_edge(clock) then  
    if RegDst = '1' then
        ID_EX(2 downto 0) <= IF_ID(6 downto 4);
    else 
        ID_EX(2 downto 0) <= IF_ID(9 downto 7);
    end if;
    
    ID_EX(5 downto 3) <= IF_ID(9 downto 7);
    ID_EX(21 downto 6) <= Ext_Imm;
    ID_EX(24 downto 22) <= func;
    ID_EX(40 downto 25) <= RD2;
    ID_EX(56 downto 41) <=  RD1;
    ID_EX(57) <= sa;
    ID_EX(58) <= Branch;
    ID_EX(59) <= ALUSrc;
    ID_EX(62 downto 60) <= ALUOp;
    ID_EX(63) <= MemWrite;
    ID_EX(64) <= RegWrite;
    ID_EX(65) <= MemtoReg;
    ID_EX(81 downto 66) <= IF_ID(31 downto 16);

end if;

end process;
wa <= ID_EX(2 downto 0);


EXMEM: process(ID_EX, clock, AluRes, Zero, Branch_addr, wa)
begin
if rising_edge(clock) then
    EX_MEM(2 downto 0) <= wa;
    EX_MEM(18 downto 3) <= ID_EX(40 downto 25);
    EX_MEM(34 downto 19) <= AluRes;
    EX_MEM(35) <= Zero;
    EX_MEM(51 downto 36) <= Branch_addr;
    EX_MEM(52) <= ID_EX(58);
    EX_MEM(53) <= ID_EX(63);
    EX_MEM(54) <= ID_EX(64);
    EX_MEM(55) <= ID_EX(65);
    
end if;

end process;

MEMWB: process(clock, MemData, AluResOut, EX_MEM)
begin

if rising_edge(clock) then
    MEM_WB(2 downto 0) <= EX_MEM(2 downto 0);
    MEM_WB(18 downto 3) <= AluResOut;
    MEM_WB(34 downto 19) <= MemData;
    MEM_WB(35) <= EX_MEM(54);
    MEM_WB(36) <= EX_MEM(55);

end if;


end process;



end Behavioral;
