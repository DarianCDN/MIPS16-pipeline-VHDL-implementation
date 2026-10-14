library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity ssd is
    Port ( 
          digit0: in std_logic_vector(3 downto 0);
          digit1: in std_logic_vector(3 downto 0);
          digit2: in std_logic_vector(3 downto 0);
          digit3: in std_logic_vector(3 downto 0);
          cat: out std_logic_vector(6 downto 0);
          an: out std_logic_vector(3 downto 0);
           clk : in STD_LOGIC);
end ssd;

architecture Behavioral of ssd is

signal cnt: std_logic_vector(15 downto 0) := x"0000";
signal sel: std_logic_vector(1 downto 0);
signal digit: std_logic_vector(3 downto 0);

begin

counter: process(clk)
begin
    if rising_edge(clk) then
            cnt <= cnt + 1;
    end if;
end process;

sel <= cnt(15 downto 14);

mux_an: process(sel)
begin
   case sel is
        when "00" => an <="1110";
        when "01" => an <="1101";
        when "10" => an <="1011";
        when others => an <="0111";
    end case;
end process;

mux_cat: process(sel)
begin
    case sel is
        when "00" => digit <= digit0;
        when "01" => digit <= digit1;
        when "10" => digit <= digit2;
        when others => digit <= digit3; 
    end case;
end process;    
   
hex2ssd: process(digit)
begin
    case digit is
            when x"0" => cat <= "1000000"; -- 0
            when x"1" => cat <= "1111001"; -- 1
            when x"2" => cat <= "0100100"; -- 2
            when x"3" => cat <= "0110000"; -- 3
            when x"4" => cat <= "0011001"; -- 4
            when x"5" => cat <= "0010010"; -- 5
            when x"6" => cat <= "0000010"; -- 6
            when x"7" => cat <= "1111000"; -- 7
            when x"8" => cat <= "0000000"; -- 8
            when x"9" => cat <= "0010000"; -- 9
            when x"A" => cat <= "0001000"; -- A
            when x"B" => cat <= "0000011"; -- b
            when x"C" => cat <= "1000110"; -- C
            when x"D" => cat <= "0100001"; -- d
            when x"E" => cat <= "0000110"; --E
            when others => cat <= "0001110"; --F
    end case;
end process;


end Behavioral;