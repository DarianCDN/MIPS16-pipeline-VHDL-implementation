----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/02/2026 09:24:11 AM
-- Design Name: 
-- Module Name: Instruction_fetch - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Instruction_fetch is
    Port ( Jump : in STD_LOGIC;
           PCSrc : in STD_LOGIC;
           clk: in std_logic;
           Jump_addr: in std_logic_vector(15 downto 0);
           Branch_addr: in std_logic_vector(15 downto 0);
           PC_next : out STD_LOGIC_VECTOR (15 downto 0);
           Instruction : out STD_LOGIC_VECTOR (15 downto 0));
end Instruction_fetch;

architecture Behavioral of Instruction_fetch is

--type matrix_16x16 is array(0 to 65535) of std_logic_vector(15 downto 0);
type matrix_16x16 is array(0 to 255) of std_logic_vector(15 downto 0);

signal rom: matrix_16x16 :=
    (
        
    --R instructions
    --B"000_010_011_001_0_000", --ADD $1, $2, $3
    --B"000_010_011_001_0_001", --SUB $1, $2, $3
    B"000_010_000_001_1_010", --SLL $1, $2, 1
    B"000_010_000_001_1_011", --SRL $1, $2, 1
    B"000_010_011_001_0_100", --AND $1, $2, $3
    B"000_010_011_001_0_101", --OR $1, $2, $3
    B"000_010_011_001_0_110", --XOR $1, $2, $3
    
    B"000_011_000_001_1_111", --SRA $1, $3, 1

    B"000_101_111_100_0_001", --SUB $4, $5, $7
    B"0000000000000000", --NoOp
    B"0000000000000000", --NoOp
    B"000_100_000_001_1_111", --SRA $1, $4, 1
    
    --I instructions
    B"011_000_010_0000101", --SW $2, offset(5)
    B"0000000000000000", --NoOp
    B"0000000000000000", --NoOp
    B"010_000_011_0000101", --LW $3, offset(5)
    B"0000000000000000", --NoOp
    B"0000000000000000", --NoOp
    B"000_010_011_001_0_000", -- ADD $1, $2, $3  
    B"001_010_001_0000111", --ADDI $1, $2, 7
    B"100_001_001_0000101", --BEQ $1, $1, 5
    B"0000000000000000", --NoOp
    B"0000000000000000", --NoOp
    B"0000000000000000", --NoOp    
    B"111_0000000000001", --JUMP 1
    B"0000000000000000", --NoOp
    B"101_010_001_0001010", --ANDI $1, $2, 10
    B"110_010_001_0001010", --ORI $1, $2, 10
    B"100_001_010_0000100", -- BEQ $1, $2, 7
    B"0000000000000000", --NoOp
    B"0000000000000000", --NoOp
    B"0000000000000000", --NoOp
    --J instruction
    B"111_0000000000000", --JUMP 0
    B"0000000000000000", --NoOp
    
    
    others => x"0000"
    );

signal pc: std_logic_vector(15 downto 0);
signal following_pc: std_logic_vector(15 downto 0);
signal branch_pc: std_logic_vector(15 downto 0);
signal new_pc: std_logic_vector(15 downto 0);

begin

process(pc) 
begin
Instruction <= rom(conv_integer(pc(7 downto 0)));
--Instruction <= rom(conv_integer(pc));

end process;

process(pc)
begin
following_pc <= pc + 1;


end process;

process(following_pc)
begin
Pc_next <= following_pc;
end process;

process(following_pc, PCSrc, Branch_addr)
begin
if PCSrc = '0' then 
branch_pc <= following_pc; 
else branch_pc <= Branch_addr;
end if;
end process;

process(Jump_addr, Jump, branch_pc)
begin
if Jump = '1' then
new_pc <= Jump_addr;
else new_pc <= branch_pc;
end if;
end process;

process(clk, new_pc)
begin
if rising_edge(clk) then
    pc <= new_pc;
end if;
end process;

end Behavioral;
