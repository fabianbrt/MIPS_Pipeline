library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity test_env is
  Port (clk : in STD_LOGIC;
        btn : in STD_LOGIC_VECTOR (4 downto 0);
        sw : in STD_LOGIC_VECTOR (4 downto 0); 
        an : out STD_LOGIC_VECTOR (7 downto 0);
        cat : out STD_LOGIC_VECTOR (6 downto 0);
        led : out STD_LOGIC_VECTOR (8 downto 0)); 
end test_env;

architecture Behavioral of test_env is


component MPG
    port (enable : out STD_LOGIC;
           btn : in STD_LOGIC;
           clk : in STD_LOGIC);
end component;


component SSD
    Port ( digits : in STD_LOGIC_VECTOR (31 downto 0);
           clk : in STD_LOGIC;
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0));
end component;

component SSD_pali
    Port ( clk : in STD_LOGIC;
           palindrome : in STD_LOGIC_VECTOR (31 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0));
end component;

component IFETCH
 Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           en : in std_logic;
           jumpAddr : in STD_LOGIC_VECTOR (31 downto 0);
           branchAddr : in STD_LOGIC_VECTOR (31 downto 0);
           Jump : in STD_LOGIC;
           PCsrc : in STD_LOGIC;
           Instruction : out STD_LOGIC_VECTOR(31 downto 0);
           PCinc : out STD_LOGIC_VECTOR(31 downto 0));
end component;

component UC is
    Port ( op_code : in STD_LOGIC_VECTOR (5 downto 0);
           RegDst : out STD_LOGIC;
           ExtOp : out STD_LOGIC;
           ALUSrc : out STD_LOGIC;
           BranchEQ : out STD_LOGIC;
           BranchNEQ : out STD_LOGIC;
           Jump : out STD_LOGIC;
           ALUOp : out STD_LOGIC_VECTOR (2 downto 0);
           MemWrite : out STD_LOGIC;
           MemtoReg : out STD_LOGIC;
           RegWrite : out STD_LOGIC);
end component;

component ID is
    Port(clk: in std_logic;
    Instruction: in std_logic_vector(31 downto 0);
    WD: in std_logic_vector(31 downto 0);
    btn_en: in std_logic;
    rd_MEM_WD: in std_logic_vector(4 downto 0);
    RegWrite: in std_logic;
    RegDst: in std_logic;
    ExtOp: in std_logic;
    RD1: out std_logic_vector(31 downto 0);
    RD2: out std_logic_vector(31 downto 0);
    Ext_Imm: out std_logic_vector(31 downto 0);
    func: out std_logic_vector(5 downto 0);
    sa: out std_logic_vector(4 downto 0);
    rt: out std_logic_vector(4 downto 0);
    rd: out std_logic_vector(4 downto 0)
    );
end component;

component EX is
    Port ( RD1 : in STD_LOGIC_VECTOR (31 downto 0);
           RD2 : in STD_LOGIC_VECTOR (31 downto 0);
           Ext_Imm : in STD_LOGIC_VECTOR (31 downto 0);
           sa : in STD_LOGIC_VECTOR (4 downto 0);
           func : in STD_LOGIC_VECTOR (5 downto 0);
           PCnext : in STD_LOGIC_VECTOR (31 downto 0);
           rt : in STD_LOGIC_VECTOR (4 downto 0);
           rd : in STD_LOGIC_VECTOR (4 downto 0);
           RegDst : in STD_LOGIC;
           AluSrc : in STD_LOGIC;
           AluOp : in  STD_LOGIC_VECTOR (2 downto 0);
           Zero : out STD_LOGIC;
           AluRes : out STD_LOGIC_VECTOR (31 downto 0);
           BranchAddr : out STD_LOGIC_VECTOR (31 downto 0);
           rWA: out std_logic_vector(4 downto 0)
           );
end component EX;

component MEM is
    Port ( clk: in STD_LOGIC;
           ALUresIN : in STD_LOGIC_VECTOR (31 downto 0);
           RD2 : in STD_LOGIC_VECTOR (31 downto 0);
           MemWrite : in STD_LOGIC;
           en : in STD_LOGIC;
           MemData : out STD_LOGIC_VECTOR (31 downto 0);
           ALUresOUT : out STD_LOGIC_VECTOR (31 downto 0);
           isPalindrome: out STD_LOGIC_VECTOR(31 downto 0));
end component MEM;



signal Instruction : std_logic_vector(31 downto 0) := (others => '0');
signal PCinc : std_logic_vector(31 downto 0) := (others => '0');
signal digits: std_logic_vector(31 downto 0) := (others => '0');
signal en, rst: std_logic;
signal WriteData : std_logic_vector(31 downto 0) := (others => '0');
signal rd1:  std_logic_vector(31 downto 0) := (others => '0');
signal rd2:  std_logic_vector(31 downto 0) := (others => '0');
signal RegDst: STD_LOGIC;
signal ExtOp :  STD_LOGIC;
signal ALUSrc :STD_LOGIC;
signal BranchEQ :  STD_LOGIC;
signal BranchNEQ :  STD_LOGIC;
signal Jump :  STD_LOGIC;
signal ALUOp : STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
signal MemWrite :  STD_LOGIC;
signal  MemtoReg :  STD_LOGIC;
signal RegWrite :  STD_LOGIC;
signal Zero :  STD_LOGIC;
signal PCsrc :  STD_LOGIC;
signal Ext_Imm: std_logic_vector(31 downto 0) := (others => '0');
signal func: std_logic_vector(5 downto 0) := (others => '0');
signal sa: std_logic_vector(4 downto 0) := (others => '0');
signal BranchAddr: std_logic_vector(31 downto 0) := (others => '0');
signal JumpAddr: std_logic_vector(31 downto 0) := (others => '0');
signal ALUresIN: std_logic_vector(31 downto 0) := (others => '0');
signal ALUresOUT: std_logic_vector(31 downto 0) := (others => '0');
signal MemData: std_logic_vector(31 downto 0) := (others => '0');
signal isPali: std_logic_vector(31 downto 0) := (others => '0');
signal rt, rd, rWA: std_logic_vector(4 downto 0) := (others => '0');

--pipeline
--IF_ID
signal PCinc_IF_ID, Instruction_IF_ID : std_logic_vector(31 downto 0);

--ID_EX
signal PCinc_ID_EX, RD1_ID_EX, RD2_ID_EX, Ext_imm_ID_EX: std_logic_vector(31 downto 0);
signal rt_ID_EX, rd_ID_EX, sa_ID_EX : std_logic_vector(4 downto 0);
signal ALUOp_ID_EX: std_logic_vector(2 downto 0);
signal func_ID_EX: std_logic_vector(5 downto 0);
signal MemToReg_ID_EX, RegWrite_ID_EX, MemWrite_ID_EX, BranchEQ_ID_EX, BranchNEQ_ID_EX ,ALUSrc_ID_EX, RegDst_ID_EX: std_logic;

-- EX/MEM
signal ALURes_EX_MEM, RD2_EX_MEM, BranchAddress_EX_MEM : STD_LOGIC_VECTOR(31 downto 0);
signal rd_EX_MEM : STD_LOGIC_VECTOR(4 downto 0);
signal zero_EX_MEM, MemtoReg_EX_MEM, RegWrite_EX_MEM, MemWrite_EX_MEM, BranchEQ_EX_MEM, BranchNEQ_EX_MEM : STD_LOGIC;

-- MEM/WB
signal MemData_MEM_WB, ALURes_MEM_WB : STD_LOGIC_VECTOR(31 downto 0);
signal rd_MEM_WB : STD_LOGIC_VECTOR(4 downto 0);
signal MemtoReg_MEM_WB, RegWrite_MEM_WB : STD_LOGIC;




begin

monopulse1: MPG port map(enable => en, btn => btn(0), clk => clk);
monopulse2: MPG port map(enable => rst, btn => btn(1), clk => clk);

instr_fetch: IFETCH port map(clk, rst, en, JumpAddr, BranchAddress_EX_MEM, Jump, PCsrc, Instruction, PCinc);
instr_ID: ID port map(clk, Instruction_IF_ID, WriteData, en, rd_MEM_WB,  RegWrite_MEM_WB, RegDst, ExtOp, rd1, rd2, Ext_imm, func, sa, rt, rd);
instr_UC: UC port map(Instruction_IF_ID(31 downto 26), RegDst, ExtOp, ALUSrc, BranchEQ, BranchNEQ, Jump, ALUOp, MemWrite, MemtoReg, RegWrite);
instr_EX: EX port map(RD1_ID_EX, RD2_ID_EX, Ext_imm_ID_EX, sa_ID_EX, func_ID_EX, PCinc_ID_EX, rt_ID_EX, rd_ID_EX, RegDst_ID_EX
,ALUsrc_ID_EX, ALUop_ID_EX, Zero, ALUresIN, BranchAddr, rWA); 
instr_MEM: MEM port map(clk, ALUres_EX_MEM, RD2_EX_MEM, MemWrite_EX_MEM, en, MemData, ALUresOUT, isPali); 

WriteData <= MemData_MEM_WB when MemToReg_MEM_WB = '1' else ALUres_MEM_WB;
PCsrc <= (BranchEQ_EX_MEM and Zero_EX_MEM) or (BranchNEQ_EX_MEM and not Zero_EX_MEM);
JumpAddr <= "0000" & Instruction_IF_ID(25 downto 0) & "00";

process(clk)
begin
    if rising_edge(clk) then
        if en = '1' then

            -- IF_ID
            PCinc_IF_ID        <= PCinc;
            Instruction_IF_ID  <= Instruction;

            -- ID_EX
            PCinc_ID_EX        <= PCinc_IF_ID;
            RD1_ID_EX          <= RD1;
            RD2_ID_EX          <= RD2;
            Ext_imm_ID_EX      <= Ext_imm;
            sa_ID_EX           <= sa;
            func_ID_EX         <= func;
            rt_ID_EX           <= rt;
            rd_ID_EX           <= rd;
            MemtoReg_ID_EX     <= MemtoReg;
            RegWrite_ID_EX     <= RegWrite;
            MemWrite_ID_EX     <= MemWrite;
            BranchEQ_ID_EX       <= BranchEQ;
            BranchNEQ_ID_EX       <= BranchNEQ;
            ALUSrc_ID_EX       <= ALUSrc;
            ALUOp_ID_EX        <= ALUOp;
            RegDst_ID_EX       <= RegDst;

            -- EX_MEM
            BranchAddress_EX_MEM <= BranchAddr;
            Zero_EX_MEM          <= Zero;
            ALURes_EX_MEM        <= ALUResIN;
            RD2_EX_MEM           <= RD2_ID_EX;
            rd_EX_MEM            <= rWA;
            MemtoReg_EX_MEM      <= MemtoReg_ID_EX;
            RegWrite_EX_MEM      <= RegWrite_ID_EX;
            MemWrite_EX_MEM      <= MemWrite_ID_EX;
            BranchEQ_EX_MEM        <= BranchEQ_ID_EX;
            BranchNEQ_EX_MEM        <= BranchNEQ_ID_EX;

            -- MEM_WB
            MemData_MEM_WB   <= MemData;
            ALURes_MEM_WB    <= ALUResOUT;
            rd_MEM_WB        <= rd_EX_MEM;
            MemtoReg_MEM_WB  <= MemtoReg_EX_MEM;
            RegWrite_MEM_WB  <= RegWrite_EX_MEM;

        end if;
    end if;
end process;

            

with sw(4 downto 0) select
 digits <= Instruction when "00000",
           PCinc when "00001",
           rd1_ID_EX when "00010",
           rd2_ID_EX when "00011",
           WriteData when "00100",
           Ext_imm_ID_EX when "00101",
           ALUresIN when "00110",
           MemData when "00111",
           isPali when "01000",
           (others => 'X') when others;

--display: SSD port map(digits => digits, clk => clk, cat => cat, an => an);
led <= Zero & Jump & BranchEQ & BranchNEQ & MemWrite & RegWrite & MemtoReg & ALUSrc & RegDst;

display: SSD_pali port map(clk => clk, palindrome => isPali ,cat => cat, an => an);
end Behavioral;