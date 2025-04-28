library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity instruction_decode is
    Port ( RegWrite : in STD_LOGIC;
           Instr : in STD_LOGIC_VECTOR (15 downto 0);
           RegDst : in STD_LOGIC;
           CLK : in STD_LOGIC;
           EN : in STD_LOGIC;
           ExtOp : in STD_LOGIC;
           RD1 : out STD_LOGIC_VECTOR (15 downto 0);
           RD2 : out STD_LOGIC_VECTOR (15 downto 0);
           WD : in STD_LOGIC_VECTOR (15 downto 0);
           Ext_imm : out STD_LOGIC_VECTOR (15 downto 0);
           func : out STD_LOGIC_VECTOR (2 downto 0);
           sa : out STD_LOGIC);
end instruction_decode;

architecture Behavioral of instruction_decode is

    component REG_FILE is
        Port ( RA1 : in STD_LOGIC_VECTOR (2 downto 0);
               RA2 : in STD_LOGIC_VECTOR (2 downto 0);
               WA : in STD_LOGIC_VECTOR (2 downto 0);
               WD : in STD_LOGIC_VECTOR (15 downto 0);
               EN : in STD_LOGIC;
               clk : in STD_LOGIC;
               RegWr : in STD_LOGIC;
               RD1 : out STD_LOGIC_VECTOR (15 downto 0);
               RD2 : out STD_LOGIC_VECTOR (15 downto 0));
    end component;

    signal WA : STD_LOGIC_VECTOR(2 downto 0); 

begin

    process(RegDst, Instr)
    begin
        if RegDst = '0' then
            WA <= Instr(9 downto 7);
        else  
            WA <= Instr(6 downto 4);
        end if;
    end process;
    
    reg_file0: REG_FILE port map (
        RA1 => Instr(12 downto 10),
        RA2 => Instr(9 downto 7),
        WA => WA,
        WD => WD,
        EN => EN,
        clk => CLK,
        RegWr => RegWrite,
        RD1 => RD1,
        RD2 => RD2
    );
    
    process(ExtOp, Instr)
    begin
        if ExtOp = '0' then
            Ext_imm <= "000000000" & Instr(6 downto 0);
        elsif ExtOp = '1' then
            Ext_imm <= (15 downto 7 => Instr(6)) & Instr(6 downto 0);
        else
            Ext_imm <= (others => 'X');
        end if;
    end process;
    
    func <= Instr(2 downto 0);
    sa <= Instr(3);

end Behavioral;