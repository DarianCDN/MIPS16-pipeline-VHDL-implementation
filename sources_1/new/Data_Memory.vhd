----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/16/2026 09:10:27 AM
-- Design Name: 
-- Module Name: Data_Memory - Behavioral
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

entity Data_Memory is
    Port ( MemWrite : in STD_LOGIC;
           clk: in std_logic;
           ALUResIn : in STD_LOGIC_VECTOR (15 downto 0);
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           MemData: out std_logic_vector(15 downto 0);
           ALUResOut: out std_logic_vector(15 downto 0));
end Data_Memory;

architecture Behavioral of Data_Memory is
type ram_type is array (0 to 255) of std_logic_vector (15 downto 0); 
signal RAM: ram_type := (
x"0001",
x"0002",
x"0003",
x"0004",
others => "0001"
);


begin

ALUResOut <= ALUResIn;

process (clk)
begin
if falling_edge(clk) then
    if MemWrite = '1' then
        RAM(conv_integer(ALUResIn(7 downto 0))) <= RD2;
    end if;
end if;

end process;

MemData <= RAM( conv_integer(ALUResIn(7 downto 0)));




end Behavioral;
