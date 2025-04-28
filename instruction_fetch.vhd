library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity instruction_fetch is
    Port ( Jump : in STD_LOGIC;
           JumpAddress : in STD_LOGIC_VECTOR (15 downto 0);
           PCSrc : in STD_LOGIC;
           BranchAddress : in STD_LOGIC_VECTOR (15 downto 0);
           JmpR : in STD_LOGIC;
           JRAddress : in STD_LOGIC_VECTOR(15 downto 0);
           CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           EN : in STD_LOGIC;
           Instruction : out STD_LOGIC_VECTOR(15 downto 0);
           PCPlus1 : out STD_LOGIC_VECTOR(15 downto 0)
    );
end instruction_fetch;

architecture Behavioral of instruction_fetch is
type t_mem is array(0 to 31) of std_logic_vector(15 downto 0);

signal ROM: t_mem := (

B"0010_0000_1000_0000",--0  x2010 ADDI $1, $zero, 0 |$1 = 0
B"0010_0001_0000_0001",--1  x2101 ADDI $2, $zero, 1 |$2 = 1
B"0010_0001_1000_0110",--2  x2186 ADDI $3, $zero, 6 |$3 = 6 (limit)
B"0000_0101_0001_0000",--3  x0510 ADD $1, $1, $2    |$1 = $1 + $2 ($1 += count)
B"0010_1001_0000_0001",--4  x2901 ADDI $2, $2, 1    |(count++)
B"0100_1001_1000_0001",--5  x4981 BEQ $2,$3,1       |$(check if 6 reached)
B"1100_0000_0000_0011",--6  xC003 J 3               |loop back 
B"0000_0000_1001_1101",--7  x009D SLL $1, $1, 1     |$1 = $1 << 1 
B"0010_0010_1000_0000",--8  x2280 ADDI $5, $zero, 0 |$5 = 0
B"0010_0010_1000_1111",--9  x228F ADDI $5, $zero, 15|$5 = 15
B"0000_0110_1100_0010",--10 x06C2 AND $4, $1, $5    |$4 = $1 & $5 (get lower 4 bits) $4 = 15
B"0000_0000_1001_1110",--11 x009E SLR $1, $1, 1     |$1 = $1 >> 1 
B"0010_0011_0000_1110",--12 x230E ADDI $6, $zero, 14
B"1111_1000_0000_0000",--13 xF800 JR $6
B"1001_1100_1000_0001",--14 x9C81 SW $1, 1[$7]      |store $1 at address $7+1
B"0011_1111_1000_0001",--15 x3F81 ADDI $7, $7, 1    |$7++ (stackpointer++)
B"1011_1101_0000_0000",--16 xBD00 LW $2, 0[$7]      |$2 = *$7 (load from memory)
B"0011_1111_1111_1111",--17 x3FFF ADDI $7, $7, -1   |$7-- (stackpointer--)
B"0000_1000_0100_0000",--18 0840 ADD $4, $2, $zero  |$4 = $2 (copy loaded value)
B"0000_0101_0100_0000",--19 0440 ADD $4, $1, $2     |$4 = $1 + $2 ($4 = 30)
B"1100_0000_0001_0100",--20 xC012 J 20              |jump to itself 
    others=> B"0010_0000_1000_0000");  --default x2010 ADDI $1, $zero, 0 |$1 = 0 


signal IP: std_logic_vector(15 downto 0):= x"0000";

begin
Instruction <= ROM(conv_integer(IP));

PCPlus1 <= IP + 1;

PC: process(CLK)
begin
    if CLK'event and CLK = '1' then
        if RST = '1' then
            IP<=x"0000";
        elsif EN = '1' then
            if JmpR = '1' then
                IP <= JRAddress;
            elsif jump = '1' then
                IP <= JumpAddress;
            elsif PCSrc = '1' then
                IP <= BranchAddress;
            else
                IP <= IP+1;
            end if;
        end if;
    end if;
end process;

end Behavioral;