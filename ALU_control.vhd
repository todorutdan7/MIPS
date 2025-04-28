
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ALU_control is
    Port ( ALUOp : in STD_LOGIC_VECTOR (1 downto 0);
           func : in STD_LOGIC_VECTOR (2 downto 0);
           ALUCtrl : out STD_LOGIC_VECTOR (2 downto 0)
           );
end ALU_control;

architecture Behavioral of ALU_control is
begin
    process(ALUOP, func)
        begin
        case ALUOp is 
        when "00" => ALUCtrl <= func;
        when "01" => ALUCtrl <= "000";
        when "10" => ALUCtrl <= "001";
        when others => ALUCtrl <= "---"; 
        end case;
    end process;
    
end Behavioral;