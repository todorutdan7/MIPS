library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MEM is
    Port ( MemWrite : in STD_LOGIC;
           ALUResIn : in STD_LOGIC_VECTOR (15 downto 0);
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           CLK : in STD_LOGIC;
           EN : in STD_LOGIC;
           MemData : out STD_LOGIC_VECTOR (15 downto 0);
           ALUResOut : out STD_LOGIC_VECTOR (15 downto 0));
end MEM;

architecture Behavioral of MEM is
type t_mem is array(0 to 15) of std_logic_vector(15 downto 0);

signal mem: t_mem := (0 => x"0000", others => x"0000");

begin
    process(clk)
    begin
    if(clk'event and clk = '1') then
        if EN = '1' then
            if(MemWrite = '1') then
                mem(conv_integer(ALUResIn(3 downto 0))) <= RD2;
            end if;
        end if;
    end if;
    end process;
    
    ALUResOut <= ALUResIn;
    MemData <= mem(conv_integer(ALUResIn(3 downto 0)));
end Behavioral;
