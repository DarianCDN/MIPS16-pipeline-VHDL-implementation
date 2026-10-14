----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/07/2026 10:34:30 PM
-- Design Name: 
-- Module Name: mpg - Behavioral
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
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mpg_4but is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0); --CULRD
           en : out STD_LOGIC_VECTOR (4 downto 0));
end mpg_4but;

architecture Behavioral of mpg_4but is
signal cnt: std_logic_vector(15 downto 0) := x"0000";
signal enr1: std_logic; 
signal q1, q2, q3: std_logic_vector(4 downto 0);
begin

counter: process(clk)
begin
    if rising_edge(clk) then
            cnt <= cnt + 1;
    end if;
end process;

enr1 <= '1' when cnt = x"FFFF" else '0';

reg1: process(clk, enr1, btn)
begin
    if rising_edge(clk) then
        if enr1 = '1' then
            q1 <= btn;
        end if;
    end if;
end process;

reg2: process(clk, q1)
begin
    if rising_edge(clk) then
        q2 <= q1;
    end if;
end process;

reg3: process(clk, q2)
begin
    if rising_edge(clk) then
        q3 <= q2;
    end if;
end process;

en <= q2 and (not q3);

end Behavioral;
