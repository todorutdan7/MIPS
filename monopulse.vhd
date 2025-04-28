library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity monopulse is
    Port ( clk : in STD_LOGIC;
           input : in STD_LOGIC;
           output : out STD_LOGIC);
end monopulse;

architecture Behavioral of monopulse is

signal aux: std_logic_vector(15 downto 0) := x"0000";
signal Q1: std_logic;
signal count_out: std_logic;
signal Q2: std_logic;
signal Q3: std_logic;

begin

process (clk)
begin
    if (clk'event and clk='1') then
        aux <= aux + 1;
    end if;
end process;

count_out <= '1' when aux = x"FFFF" else '0';
            
process(clk)
begin
    if rising_edge(clk) then
        if(count_out = '1') then
           Q1 <= input;
        end if;
    end if;
end process;

process(clk)
begin
    if rising_edge(clk) then
        Q2 <= Q1;
    end if;
end process;

process(clk)
begin
    if rising_edge(clk) then
        Q3 <= Q2;
    end if;
end process;

output <= (NOT Q3) AND Q2;

end Behavioral;