library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity main_control is
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
end main_control;

architecture Behavioral of main_control is

    type control_signals is record
        RegDst    : STD_LOGIC;
        ExtOp     : STD_LOGIC;
        ALUSrc    : STD_LOGIC;
        BranchEQ  : STD_LOGIC;
        BranchGTZ : STD_LOGIC;
        Jump      : STD_LOGIC;
        JumpR     : STD_LOGIC;
        MemWrite  : STD_LOGIC;
        MemToReg  : STD_LOGIC;
        RegWrite  : STD_LOGIC;
        ALUOp     : STD_LOGIC_VECTOR(1 downto 0);
    end record;
    
    constant R_TYPE   : control_signals := ('1', '-', '0', '0', '0', '0', '0', '0', '0', '1', "00");
    constant I_TYPE   : control_signals := ('0', '1', '1', '0', '0', '0', '0', '0', '0', '1', "01");
    constant BEQ      : control_signals := ('-', '1', '0', '1', '0', '0', '0', '0', '-', '0', "10");
    constant BGTZ     : control_signals := ('-', '1', '0', '0', '1', '0', '0', '0', '-', '0', "10"); 
    constant SW       : control_signals := ('-', '1', '1', '0', '0', '0', '0', '1', '-', '0', "01");
    constant LW       : control_signals := ('0', '1', '1', '0', '0', '0', '0', '0', '1', '1', "01");
    constant JUMP1     : control_signals := ('-', '-', '-', '-', '-', '1', '0', '0', '-', '0', "--");
    constant JUMPR1    : control_signals := ('-', '-', '-', '-', '-', '-', '1', '0', '-', '0', "--");
    constant INVALID  : control_signals := ('-', '-', '-', '-', '-', '-', '-', '-', '-', '-', "--");
    
    signal ctrl : control_signals;
    
begin
    process(instr)
    begin
        case instr is
            when "000"  => ctrl <= R_TYPE;
            when "001"  => ctrl <= I_TYPE;
            when "010"  => ctrl <= BEQ;
            when "011"  => ctrl <= BGTZ;
            when "100"  => ctrl <= SW;
            when "101"  => ctrl <= LW;
            when "110"  => ctrl <= JUMP1;
            when "111"  => ctrl <= JUMPR1;
            when others => ctrl <= INVALID;
        end case;
    end process;
    
    RegDst    <= ctrl.RegDst;
    ExtOp     <= ctrl.ExtOp;
    ALUSrc    <= ctrl.ALUSrc;
    BranchEQ  <= ctrl.BranchEQ;
    BranchGTZ <= ctrl.BranchGTZ;
    Jump      <= ctrl.Jump;
    JumpR     <= ctrl.JumpR;
    MemWrite  <= ctrl.MemWrite;
    MemToReg  <= ctrl.MemToReg;
    RegWrite  <= ctrl.RegWrite;
    ALUOp     <= ctrl.ALUOp;
    
end Behavioral;
