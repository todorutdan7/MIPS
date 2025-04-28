
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity REG_FILE is
    Port ( RA1 : in STD_LOGIC_VECTOR (2 downto 0);
           RA2 : in STD_LOGIC_VECTOR (2 downto 0);
           WA : in STD_LOGIC_VECTOR (2 downto 0);
           WD : in STD_LOGIC_VECTOR (15 downto 0);
           EN : in STD_LOGIC;
           clk : in STD_LOGIC;
           RegWr : in STD_LOGIC;
           RD1 : out STD_LOGIC_VECTOR (15 downto 0);
           RD2 : out STD_LOGIC_VECTOR (15 downto 0));
end REG_FILE;

architecture Behavioral of REG_FILE is

type t_mem is array(0 to 7) of std_logic_vector(15 downto 0);

signal mem: t_mem := (x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000");

begin

process(clk)
begin
    if(clk'event and clk = '1') then
        if(RegWr = '1') then
            if(EN = '1') then
                mem(conv_integer(WA)) <= WD;
            end if;
        end if;
    end if;
end process;

RD1 <= mem(conv_integer(RA1));
RD2 <= mem(conv_integer(RA2));

end Behavioral;