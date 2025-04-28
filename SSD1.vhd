library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SSD1 is
    Port ( d1 : in STD_LOGIC_VECTOR (3 downto 0);
           d2 : in STD_LOGIC_VECTOR (3 downto 0);
           d3 : in STD_LOGIC_VECTOR (3 downto 0);
           d4 : in STD_LOGIC_VECTOR (3 downto 0);
           clk: in STD_LOGIC;
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0)
           );
end SSD1;

architecture Behavioral of SSD1 is
signal selected_digit: STD_LOGIC_VECTOR(3 downto 0);
signal count: STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
begin

mux_process: process(count, d1, d2, d3, d4)
begin
    case count(15 downto 14) is
        when "00" => selected_digit <= d1;
        when "01" => selected_digit <= d2;
        when "10" => selected_digit <= d3;
        when "11" => selected_digit <= d4;
        when others => selected_digit <= "0000"; 
    end case;
end process;

cat <= "1111001" when selected_digit="0001" else   
       "0100100" when selected_digit="0010" else   
       "0110000" when selected_digit="0011" else   
       "0011001" when selected_digit="0100" else   
       "0010010" when selected_digit="0101" else   
       "0000010" when selected_digit="0110" else   
       "1111000" when selected_digit="0111" else   
       "0000000" when selected_digit="1000" else   
       "0010000" when selected_digit="1001" else   
       "0001000" when selected_digit="1010" else   
       "0000011" when selected_digit="1011" else   
       "1000110" when selected_digit="1100" else   
       "0100001" when selected_digit="1101" else   
       "0000110" when selected_digit="1110" else   
       "0001110" when selected_digit="1111" else
       "1000000" when selected_digit="0000";

counter: process (clk)
begin
    if (CLK'event and CLK='1') then
        count <= count + 1;
    end if;
end process;
        
an <= "0111" when count(15 downto 14) = "00" else
      "1011" when count(15 downto 14) = "01" else
      "1101" when count(15 downto 14) = "10" else
      "1110" when count(15 downto 14) = "11";

end Behavioral;