-- Sreeramamurthy Tripuramallu 903057502
-- ROM_MEM array is expanded to support the jal state
-- RegDst and MemtoReg are expanded to 2-bits (reflected in port map and the microinstruction) 
-- The microinstruction length is expanded to support the two new additional bits to the signals
-- The opcodes are altered to reflect the changes of the additional bits to the microinstruction (with jal implemented as well)
-- A jal signal is created to recored the type of signal 
-- Dispatch table 1 is updated to support the new state of jal 
-- ECE 3055 Computer Architecture and Operating Systems
--
-- Multicycle MIPS Processor VHDL Behavioral Model
--		
-- control module (implements MIPS control unit)
--
-- School of Electrical & Computer Engineering
-- Georgia Institute of Technology
-- Atlanta, GA 30332
-- 
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY control IS
   PORT( 	-- INPUT SIGNALS
	SIGNAL Opcode 		: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
	SIGNAL clock, reset	: IN 	STD_LOGIC;
	 
	 -- OUTPUT SIGNALS
	SIGNAL PCWrite     : OUT STD_LOGIC;
   	SIGNAL PCWriteCond : OUT STD_LOGIC;
   	SIGNAL IorD        : OUT STD_LOGIC;
   	SIGNAL MemRead 	 : OUT STD_LOGIC;
  	SIGNAL MemWrite 	 : OUT STD_LOGIC;
   	SIGNAL IRWrite     : OUT STD_LOGIC;
   	SIGNAL MemtoReg    : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
   	SIGNAL PCSource    : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);			 
   	SIGNAL ALUOp       : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
   	SIGNAL ALUSrcB 	 : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
   	SIGNAL ALUSrcA     : OUT STD_LOGIC;
   	SIGNAL RegWrite 	 : OUT STD_LOGIC;
   	SIGNAL RegDst      : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
   	SIGNAL micropc	 : OUT integer);

END control;

ARCHITECTURE behavior OF control IS
    -- Implementation of the microcode ROM
TYPE ROM_MEM IS ARRAY (0 to 10) of STD_LOGIC_VECTOR (23 DOWNTO 0);
   SIGNAL   IROM : ROM_MEM := (
      X"094083",   -- fetch
      X"000181",   -- decode
      X"000142",   -- memory address
      X"030003",   -- memory load
      X"002020",   -- memory writeback
      X"028000",   -- memory store 
      X"000443",   -- rformat execution
      X"000030",   -- rformat writeback
      X"040a40",   -- BEQ 
      X"081000",    -- jump  
      X"381020"      -- jal
   );
    
    SIGNAL addr_control 		: std_logic_vector(3 downto 0); 
    SIGNAL microinstruction 		: std_logic_vector(23 downto 0);
    SIGNAL  R_format, Lw, Sw, Beq, jump, jal	: STD_LOGIC;
    SIGNAL dispatch_1, dispatch_2, next_micro : integer; 
BEGIN    

-- record the type of instruction
R_format 	  <=  '1'  WHEN  Opcode = "000000"  ELSE '0';
Lw            <=  '1'  WHEN  Opcode = "100011"  ELSE '0';
Sw            <=  '1'  WHEN  Opcode = "101011"  ELSE '0';
Beq           <=  '1'  WHEN  Opcode = "000100"  ELSE '0';
jump          <= '1'    WHEN Opcode = "000010" ELSE '0';
jal          <=  '1'    WHEN Opcode = "000011" ELSE '0'; 

-- Implementation of dispatch table 1
dispatch_1  <= 6 when R_format = '1' else
            8 when Beq = '1' else
            2 when (LW = '1') or (SW = '1') else
            9 when jump = '1' else
	         10 when jal = '1' else 
            0;

-- Implementation of dispatch table 2
dispatch_2 <= 3 when (LW = '1') else 5;


microinstruction <= IROM(next_micro) when next_micro >= 0 else X"012340";

PCWrite        <= microinstruction(19);
PCWriteCond    <= microinstruction(18);
IorD           <= microinstruction(17);
MemRead 	   <= microinstruction(16);
MemWrite 	   <= microinstruction(15);
IRWrite        <= microinstruction(14);
MemtoReg       <= microinstruction(21) & microinstruction(13);
PCSource       <= microinstruction(12 downto 11);
ALUOp          <= microinstruction(10 downto 9);
ALUSrcB 	   <= microinstruction(8 downto 7);
ALUSrcA        <= microinstruction(6);
RegWrite 	   <= microinstruction(5);
RegDst         <= microinstruction(20) & microinstruction(4);
addr_control   <= microinstruction(3 downto 0);

micropc <= next_micro;

process
    -- implement the microcode interpreter loop
    begin
        wait until (rising_edge(clock));
        if (reset = '1') then
            next_micro <= 0;
            else
    -- select the next microinstruction
            case addr_control is
            when "0000" => next_micro <= 0;
            when "0001" => next_micro <= dispatch_1;
            when "0010" => next_micro <= dispatch_2;
            when "0011" => next_micro <= (next_micro + 1);
            when others => next_micro <= 0;
        end case;
    end if;
    end process; 


   END behavior;


