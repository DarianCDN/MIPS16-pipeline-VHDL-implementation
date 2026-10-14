----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/06/2026 08:20:29 PM
-- Design Name: 
-- Module Name: instruction_decode - Behavioral
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

entity instruction_decode is
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
end instruction_decode;

architecture Behavioral of instruction_decode is

component register_file is
Port ( ra1 : in STD_LOGIC_VECTOR (2 downto 0);
           ra2 : in STD_LOGIC_VECTOR (2 downto 0);
           wa : in STD_LOGIC_VECTOR (2 downto 0);
           wd : in STD_LOGIC_VECTOR (15 downto 0);
           regwr: in std_logic;
           clk : in STD_LOGIC;
           rd1 : out STD_LOGIC_VECTOR (15 downto 0);
           rd2 : out STD_LOGIC_VECTOR (15 downto 0));
end component;


begin

reg_file: register_file port map(ra1 => instr(12 downto 10), ra2 => instr(9 downto 7), wa => wa, wd => wd, clk => clk, regwr => regwrite, rd1 => rd1, rd2 => rd2);

process(instr, ExtOp)
begin
if instr(6) = '1' and ExtOp = '1' then
Ext_Imm <= "111111111" & instr(6 downto 0);
else 
Ext_Imm <= "000000000" & instr(6 downto 0);
end if;
end process;

func <= instr(2 downto 0);

sa <= instr(3);


end Behavioral;
