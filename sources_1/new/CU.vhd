----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/15/2026 06:53:37 PM
-- Design Name: 
-- Module Name: CU - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CU is
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
end CU;

architecture Behavioral of CU is


begin

process(instr)
begin
case instr is
    when "000" => 
        RegDst <= '1';
        RegWrite <= '1';
        ALUSrc <= '0';
        Branch <= '0';
        MemWrite <= '0';
        MemtoReg <= '0';
        ExtOp <= '0';
        ALUOp <= "111";
        Jump <= '0';
   when "001" => 
        RegDst <= '0';
        RegWrite <= '1';
        ALUSrc <= '1';
        Branch <= '0';
        MemWrite <= '0';
        MemtoReg <= '0';
        ExtOp <= '1';
        ALUOp <= "000";
        Jump <= '0';
    when "010" =>
        RegDst <= '0';
        RegWrite <= '1';
        ALUSrc <= '1';
        Branch <= '0';
        MemWrite <= '0';
        MemtoReg <= '1';
        ExtOp <= '1';
        ALUOp <= "000";
        Jump <= '0';
    when "011" => 
        RegDst <= '1';
        RegWrite <= '0';
        ALUSrc <= '1';
        Branch <= '0';
        MemWrite <= '1';
        MemtoReg <= '0';
        ExtOp <= '1';
        ALUOp <= "000";
        Jump <= '0';
    when "100" =>
        RegDst <= '0';
        RegWrite <= '0';
        ALUSrc <= '0';
        Branch <= '1';
        MemWrite <= '0';
        MemtoReg <= '0';
        ExtOp <= '1';
        ALUOp <= "001";
        Jump <= '0';
    when "101" => 
        RegDst <= '0';
        RegWrite <= '1';
        ALUSrc <= '1';
        Branch <= '0';
        MemWrite <= '0';
        MemtoReg <= '0';
        ExtOp <= '0';
        ALUOp <= "100";
        Jump <= '0';
    when "110" => 
        RegDst <= '0';
        RegWrite <= '1';
        ALUSrc <= '1';
        Branch <= '0';
        MemWrite <= '0';
        MemtoReg <= '0';
        ExtOp <= '0';
        ALUOp <= "101";
        Jump <= '0';
    when others =>
        RegDst <= '0';
        RegWrite <= '0';
        ALUSrc <= '0';
        Branch <= '0';
        MemWrite <= '0';
        MemtoReg <= '0';
        ExtOp <= '0';
        ALUOp <= "000";
        Jump <= '1';
end case;

end process;

end Behavioral;
