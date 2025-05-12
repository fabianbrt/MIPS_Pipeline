----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/24/2025 03:18:59 PM
-- Design Name: 
-- Module Name: IFETCH - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IFETCH is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           en : in std_logic;
           jumpAddr : in STD_LOGIC_VECTOR (31 downto 0);
           branchAddr : in STD_LOGIC_VECTOR (31 downto 0);
           Jump : in STD_LOGIC;
           PCsrc : in STD_LOGIC;
           Instruction : out STD_LOGIC_VECTOR(31 downto 0);
           PCinc : out STD_LOGIC_VECTOR(31 downto 0));
end IFETCH;

architecture Behavioral of IFETCH is
type rom_type is array(0 to 255) of std_logic_vector(31 downto 0);
signal ROM: rom_type := (
    B"100011_00000_00001_0000000000000000",   -- X"8C010000" -- LW $1, 0($0) -$1 - no_digits - 1
    X"00000000",  -- NoOp(ADD $0, $0, $0)                                                    - 2
    X"00000000",  -- NoOp(ADD $0, $0, $0)                                                    - 3    
    B"000000_00000_00001_00010_00001_000010", -- X"00011042" -- SRL $2, $1, 1                - 4
     X"00000000",  -- NoOp(ADD $0, $0, $0)                                                   - 5
      X"00000000",  -- NoOp(ADD $0, $0, $0)                                                  - 6
    B"001000_00010_00010_0000000000000001",   -- X"20000001" -- ADDI $2, $2, 1               - 7
    B"001000_00000_00000_0000000000000001",   -- X"20000001" -- ADDI $0, $0, 1               - 8
    X"00000000",  -- NoOp(ADD $0, $0, $0)                                                    - 9
    X"00000000",  -- NoOp(ADD $0, $0, $0)                                                    - 10   
    B"000100_00000_00010_0000000000010001",   -- X"14650007" -- BEQ $0, $2, 17(PALINDROME)   - 11
    X"00000000",  -- NoOp(ADD $0, $0, $0)                                                    - 12
    X"00000000",  -- NoOp(ADD $0, $0, $0)                                                    - 13
    X"00000000",  -- NoOp(ADD $0, $0, $0)                                                    - 14
    B"100011_00000_00011_0000000000000000",   -- X"8C030000" -- LW $3, 0($0)                 - 15
    B"000000_00001_00000_00100_00000_100010", -- X"00602022" -- SUB $4, $1, $0               - 16
    X"00000000",  -- NoOp(ADD $0, $0, $0)                                                    - 17   
    X"00000000",  -- NoOp(ADD $0, $0, $0)                                                    - 18
    B"100011_00100_00101_0000000000000001",   -- X"8C850001" -- LW $5, 1($4)                 - 19
    X"00000000",  -- NoOp(ADD $0, $0, $0)                                                    - 20
    X"00000000",  -- NoOp(ADD $0, $0, $0)                                                    - 21
    B"000101_00011_00101_0000000000001100",   -- X"14650007" -- BNE $3, $5, 12 (NOT PALINDROME)- 22
    X"00000000",  -- NoOp(ADD $0, $0, $0)                                                    - 23       
    X"00000000",  -- NoOp(ADD $0, $0, $0)                                                    - 24   
    X"00000000",  -- NoOp(ADD $0, $0, $0)                                                    - 25   
    B"001000_00000_00000_0000000000000001",   -- X"20000001" -- ADDI $0, $0, 1               - 26
    B"000010_00000000000000000000001010",       -- X"08000010" -- JUMP 10                    - 27
    X"00000000",  -- NoOp(ADD $0, $0, $0)                                                    - 28
    B"001000_00110_00110_0000000000000001",   -- X"20260001" -- ADDI $6, $6, 1               - 29 -- PALINDROM
    X"00000000",  -- NoOp(ADD $0, $0, $0)                                                    - 30
    X"00000000",  -- NoOp(ADD $0, $0, $0)                                                    - 31   
    B"101011_00001_00111_0000000000000000",   -- X"ACC2E001" -- SW $6, 1($1)                 - 32
    B"000010_00000000000000000000010000",       -- X"08000010" -- J 16  -- END               - 33 
    X"00000000",  -- NoOp(ADD $0, $0, $0)                                                    - 34
    B"001000_00110_00110_0000000000000010",   -- X"20260001" -- ADDI $6, $6, 2               - 35 -- NOT PALINDROM
    X"00000000",  -- NoOp(ADD $0, $0, $0)                                                    - 36
    X"00000000",  -- NoOp(ADD $0, $0, $0)                                                    - 37   
    B"101011_00001_00111_0000000000000001",   -- X"ACC2E001" -- SW $6, 1($1)                 - 38
    --END :
    others => X"00000000" -- NoOp(ADD $0, $0, $0)                                            - 39
);

signal PC : std_logic_vector(31 downto 0) := (others => '0');
begin

process(clk, rst)
 begin  
    if rst = '1' then
        PC <= (others => '0');
    elsif rising_edge(clk) and en = '1' then
        if Jump = '1' then
            PC <= jumpAddr;
        elsif PCsrc = '1' then
            PC <= branchAddr;
        else
            PC <= PC + 4;
end if;

    end if;
end process;

Instruction <= ROM(to_integer(unsigned(PC(9 downto 2))));
PCinc <= PC + 4;

end Behavioral;