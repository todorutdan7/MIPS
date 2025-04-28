
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;


architecture testenv of test_env is
component SSD1 is
    Port ( d1 : in STD_LOGIC_VECTOR (3 downto 0);
           d2 : in STD_LOGIC_VECTOR (3 downto 0);
           d3 : in STD_LOGIC_VECTOR (3 downto 0);
           d4 : in STD_LOGIC_VECTOR (3 downto 0);
           clk: in STD_LOGIC;
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0)
           );
end component;

component monopulse is
    Port ( clk : in STD_LOGIC;
           input : in STD_LOGIC;
           output : out STD_LOGIC);
end component;

component instruction_fetch is
    Port ( Jump : in STD_LOGIC;
           JumpAddress : in STD_LOGIC_VECTOR (15 downto 0);
           PCSrc : in STD_LOGIC;
           BranchAddress : in STD_LOGIC_VECTOR (15 downto 0);
           JmpR : in STD_LOGIC;
           JRAddress : in STD_LOGIC_VECTOR(15 downto 0);
           CLK : in STD_LOGIC;
           RST: in STD_LOGIC;
           EN : in STD_LOGIC;
           Instruction : out STD_LOGIC_VECTOR(15 downto 0);
           PCPlus1 : out STD_LOGIC_VECTOR(15 downto 0)
    );
end component;

component instruction_decode is
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
end component;

component main_control is
    Port ( instr : in STD_LOGIC_VECTOR (2 downto 0);
           RegDst : out STD_LOGIC;
           ExtOp : out STD_LOGIC;
           ALUSrc : out STD_LOGIC;
           BranchEQ : out STD_LOGIC;
           BranchGTZ : out STD_LOGIC;
           Jump : out STD_LOGIC;
           JumpR : out STD_LOGIC;
           MemWrite : out STD_LOGIC;
           MemToReg : out STD_LOGIC;
           RegWrite : out STD_LOGIC;
           ALUOp : out STD_LOGIC_VECTOR(1 downto 0));
end component;

component instruction_execute is
    Port ( RD1 : in STD_LOGIC_VECTOR (15 downto 0);
           ALUSrc : in STD_LOGIC;
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           Ext_Imm : in STD_LOGIC_VECTOR (15 downto 0);
           sa : in STD_LOGIC;
           func : in STD_LOGIC_VECTOR (2 downto 0);
           AluOP : in STD_LOGIC_VECTOR(1 downto 0);
           PCplus1 : in STD_LOGIC_VECTOR (15 downto 0);
           GT : out STD_LOGIC;
           Zero: out STD_LOGIC;
           ALURes: out STD_LOGIC_VECTOR(15 downto 0);
           BranchAdress: out STD_LOGIC_VECTOR(15 downto 0)
           );
end component;

component MEM is
    Port ( MemWrite : in STD_LOGIC;
           ALUResIn : in STD_LOGIC_VECTOR (15 downto 0);
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           CLK : in STD_LOGIC;
           EN : in STD_LOGIC;
           MemData : out STD_LOGIC_VECTOR (15 downto 0);
           ALUResOut : out STD_LOGIC_VECTOR (15 downto 0));
end component;

signal clkSimulation, clkSimulation1: STD_LOGIC;
signal RegDst, ExtOp, ALUSrc, BranchEQ, BranchGTZ, Jump, JumpR, MemWrite, MemToReg, RegWrite : STD_LOGIC;
signal ALUOp : STD_LOGIC_VECTOR(1 downto 0);
signal PCSrc : STD_LOGIC;
signal JumpAddress, BranchAddress, JRAddress, Instruction, PCplus1 : STD_LOGIC_VECTOR(15 downto 0);
signal zeroFlag, GtFlag: STD_LOGIC;
signal RD1, RD2: STD_LOGIC_VECTOR(15 downto 0);
signal Ext_Imm: STD_LOGIC_VECTOR(15 downto 0);
signal func: STD_LOGIC_VECTOR(2 downto 0);
signal sa: STD_LOGIC;
signal ALURes : STD_LOGIC_VECTOR(15 downto 0);
signal MEMAluResOut, MEMData : STD_LOGIC_VECTOR(15 downto 0);
signal WriteBackOut: STD_LOGIC_VECTOR(15 downto 0);
signal val : STD_LOGIC_VECTOR(15 downto 0);

begin

mpg0: monopulse port map (clk=>clk, input=>btn(0), output=> clkSimulation);
mpg1: monopulse port map (clk=>clk, input=>btn(1), output=> clkSimulation1);

if0: instruction_fetch port map(
    Jump => Jump,
    JumpAddress => JumpAddress, 
    PCSrc => PCSrc,
    BranchAddress => BranchAddress, 
    JmpR => JumpR, 
    JRAddress => RD1, 
    CLK => clk, 
    RST => clkSimulation1,
    EN => clkSimulation,
    Instruction => Instruction, 
    PCPlus1 => PCPlus1); 
JumpAddress <= PCplus1(15 downto 13) & Instruction(12 downto 0);

mainControl0: main_control port map(
    instr => Instruction(15 downto 13), 
    RegDst => RegDst, 
    ExtOp => ExtOp,
    ALUSrc => ALUSrc,
    BranchEQ => BranchEQ,
    BranchGTZ => BranchGTZ,
    Jump => Jump,
    JumpR =>  JumpR,
    MemWrite => MemWrite,
    MemToReg => MemToReg,
    RegWrite => RegWrite,
    ALUOp => ALUOp);    
 
 id: instruction_decode port map(
    RegWrite => RegWrite, 
    Instr => Instruction(15 downto 0), 
    RegDst => RegDst, 
    CLK => clk,
    EN => clkSimulation,
    ExtOp => ExtOp, 
    RD1 => RD1, 
    RD2 => RD2, 
    WD => WriteBackOut,
    Ext_Imm => Ext_Imm, 
    func => func, 
    sa => sa); 
JRAddress <= RD1;
    
 ie: instruction_execute port map(
	RD1 => RD1, 
	ALUSrc => ALUSrc, 
	RD2 => RD2, 
	Ext_Imm => Ext_Imm,
	sa => sa, 
	func => func, 
	AluOP => AluOP, 
	PCplus1 => PCplus1, 
	GT => GTFlag, 
	Zero => ZeroFlag, 
	ALURes => ALURes, 
	BranchAdress => BranchAddress 
 );
 
 PCSrc <= (BranchEQ and ZeroFlag) or (BranchGTZ and GTFlag);
 
 MEM0: MEM port map(
	MemWrite => MemWrite, 
	ALUResIn => ALURes, 
	RD2 => RD2, 
	CLK => clk,
	EN => clkSimulation,
	MemData => MEMData, 
	ALUResOut => MEMALUResOut 
 );
 
process(MemToReg, MEMAluResOut, MEMData)
 begin
     case MemToReg is
         when '0' =>
             WriteBackOut <= MEMAluResOut;
         when '1' =>
             WriteBackOut <= MEMData;
         when others =>
             WriteBackOut <= (others => '0');
     end case;
 end process;
 
process(sw, Instruction, Pcplus1, RD1, RD2, Ext_Imm, ALURes, MemData, WriteBackOut)
 begin
     case sw(7 downto 5) is
         when "000" =>
             val <= Instruction;
         when "001" =>
             val <= Pcplus1;
         when "010" =>
             val <= RD1;
         when "011" =>
             val <= RD2;
         when "100" =>
             val <= Ext_Imm;
         when "101" =>
             val <= ALURes;
         when "110" =>
             val <= MemData;
         when "111" =>
             val <= WriteBackOut;
         when others =>
             val <= x"FFFF";
     end case;
 end process;
    
SSD0: SSD1 port map(
    d1 => val(15 downto 12),
    d2 => val(11 downto 8),
    d3 => val(7 downto 4),
    d4 => val(3 downto 0),
    clk => clk,
    cat => cat,
    an => an
);

    Led(0) <= RegWrite;
    Led(1) <= MemtoReg;
    Led(2) <= MemWrite;
    Led(3) <= Jump;
    Led(4) <= JumpR;
    Led(5) <= BranchEQ;
    Led(6) <= BranchGTZ;
    Led(7) <= AluSrc;
    Led(8) <= ExtOp;
    Led(9) <= RegDst;
    Led(11 downto 10) <= AluOp;

end testenv;