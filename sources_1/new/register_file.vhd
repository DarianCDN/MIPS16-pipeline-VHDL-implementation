----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/19/2026 09:17:08 AM
-- Design Name: 
-- Module Name: register_file - Behavioral
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

entity register_file is
    Port ( ra1 : in STD_LOGIC_VECTOR (2 downto 0);
           ra2 : in STD_LOGIC_VECTOR (2 downto 0);
           wa : in STD_LOGIC_VECTOR (2 downto 0);
           wd : in STD_LOGIC_VECTOR (15 downto 0);
           regwr: in std_logic;
           clk : in STD_LOGIC;
           rd1 : out STD_LOGIC_VECTOR (15 downto 0);
           rd2 : out STD_LOGIC_VECTOR (15 downto 0));
end register_file;



architecture Behavioral of register_file is

type matrix_16x16 is array(0 to 15) of std_logic_vector(15 downto 0);
signal reg_file: matrix_16x16 := (
 x"0000",
 x"0002",
 x"0003",
 x"0004",
 x"0005",
 x"0006",
 x"0007",
 x"0008",
 x"0009",
 x"000A",
 x"000B",
 x"000C",
 x"000D",
 x"000E",
 x"000F",
 x"0010");

begin

process(clk)
begin
    if falling_edge(clk) then
        if regwr = '1' then
            reg_file(conv_integer(wa)) <= wd;
        end if;
    end if;
end process;

rd1 <= reg_file(conv_integer(ra1));
rd2 <= reg_file(conv_integer(ra2));

end Behavioral;
