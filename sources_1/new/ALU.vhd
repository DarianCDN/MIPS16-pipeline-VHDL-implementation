----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/16/2026 08:10:13 AM
-- Design Name: 
-- Module Name: ALU - Behavioral
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

entity ExecutionUnit is
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
end ExecutionUnit;

architecture Behavioral of ExecutionUnit is

signal imm_shifted: std_logic_vector(15 downto 0);
signal op2: std_logic_vector(15 downto 0);
signal ALUCtrl: std_logic_vector(2 downto 0);
signal res: std_logic_vector(15 downto 0);

begin

imm_shifted <= Ext_Imm;
BranchAddress <= PC_next + imm_shifted;

op2 <= RD2 when ALUSrc = '0' else Ext_Imm;

ALUCtrl <= func when ALUOp = "111" else ALUOp;

ALU_operations: process(RD1, op2, sa, ALUCtrl)
begin

case ALUCtrl is

    when "000" => res <= RD1 + op2;
    when "001" => res <= RD1 - op2;
    when "010" => res <= RD1(14 downto 0) & '0';
    when "011" => res <= '0' & RD1(15 downto 1);
    when "100" => res <= RD1 and op2;
    when "101" => res <= RD1 or op2;
    when "110" => res <= RD1 xor op2;
    when others => res <= RD1(15) & RD1(15 downto 1);
end case;

if res = x"0000" then
    Zero <= '1';
else Zero <= '0';
end if;

end process;

ALURes <= res;

end Behavioral;
