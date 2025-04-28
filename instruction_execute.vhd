library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity instruction_execute is
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
end instruction_execute;

architecture Behavioral of instruction_execute is
component ALU_control is
    Port ( ALUOp : in STD_LOGIC_VECTOR (1 downto 0);
           func : in STD_LOGIC_VECTOR (2 downto 0);
           ALUCtrl : out STD_LOGIC_VECTOR (2 downto 0)
           );
end component;

signal A : STD_LOGIC_VECTOR(15 downto 0);
signal B : STD_LOGIC_VECTOR(15 downto 0);
signal C : STD_LOGIC_VECTOR(15 downto 0);
signal ALUCtrl: STD_LOGIC_VECTOR(2 downto 0);
signal ZeroDetectOut: STD_LOGIC;

begin

    process(ALUSrc, RD2, Ext_Imm)
    begin
        case ALUSrc is
            when '0' =>
                B <= RD2;
            when '1' =>
                B <= Ext_Imm;
            when others =>
                B <= (others => 'X');
        end case;
    end process;

    alu_control0: ALU_control port map(
        ALUOp => aluOP,
        func => func,
        ALUCtrl => ALUCtrl
    );
    
    A <= RD1;
    
    ALU: process(A, B, ALUCtrl, sa)
    begin
        case ALUCtrl is
            when "000" => C <= A + B;
            when "001" => C <= A - B;
            when "010" => C <= A and B;
            when "011" => C <= A or B;
            when "100" => C <= A xor B;
            when "101" => C <= B(14 downto 0) & "0"; 
            when "110" => C <= "0" & B(15 downto 1); 
            when "111" =>
                if A < B then
                    C <= x"0001";
                else
                    C <= x"0000";
                end if;
            when others => C <= (others => '0');
        end case;
    end process;
    ALURes <= C; 
    
    ZeroDetect: process(C)
    begin
        if C = x"0000" then
            ZeroDetectOut <= '1';
        else
            ZeroDetectOut <= '0';
        end if;
    end process;
    
    Zero <= ZeroDetectOut;
    
    GT <= not(ZeroDetectOut) and not(C(15));
    
    BranchAdress <= PCplus1 + Ext_Imm;
    
end Behavioral;