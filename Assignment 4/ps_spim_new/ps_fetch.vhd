-- ECE 3056: Architecture, Concurrency and Energy in Computation
-- Sudhakar Yalamanchili
-- Pipelined MIPS Processor VHDL Behavioral Mode--
--
--
-- Instruction fetch behavioral model. Instruction memory is
-- provided within this model. IF increments the PC,  
-- and writes the appropriate output signals. 

Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.Std_logic_arith.all;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;


entity fetch is 
--

port(instruction  : out std_logic_vector(31 downto 0);
	  PC_out       : out std_logic_vector (31 downto 0);
	  Branch_PC    : in std_logic_vector(31 downto 0);
	  clock, reset, PCSource:  in std_logic);
end fetch;

architecture behavioral of fetch is 
TYPE INST_MEM IS ARRAY (0 to 22) of STD_LOGIC_VECTOR (31 DOWNTO 0);
   SIGNAL iram : INST_MEM := (
      X"00853820",   --  lw $7, 4($0)
      X"00e43020",   --  lw $8, 8($0) 
      X"00000000",   --  add $9, $7, $8
      X"00000000",   --  sw $9, 12($0)
      X"00000000",   --  beq $0, $0, -5 (branch back 5 words)
      X"00000000",   --  nop
      X"00000000",   --  nop
      X"8c02000c",     --	 nop
      X"8c030010",   --  add $9, $7, $8
      X"00430820",   --  sw $9, 12($0)
      X"00000000",   --  beq $0, $0, -5 (branch back 5 words)
      X"00000000",   --  nop
      X"00000000",
      X"00000000",   --  add $9, $7, $8
      X"00000000",   --  sw $9, 12($0)
      X"00001020",   --  beq $0, $0, -5 (branch back 5 words)
      X"00001820",   --  nop
      X"00430820",
      X"00000000",   --  beq $0, $0, -5 (branch back 5 words)
      X"00000000",   --  nop
      X"00000000",
      X"00000000",   --  add $9, $7, $8
      X"00000000"
 
 
 
                     
   );
   
   SIGNAL PC, Next_PC : STD_LOGIC_VECTOR( 31 DOWNTO 0 );

BEGIN 						
-- access instruction pointed to by current PC
-- and increment PC by 4. This is combinational
		             
Instruction <=  iram(CONV_INTEGER(PC(7 downto 2)));  -- since the instruction
                                                     -- memory is indexed by integer
PC_out<= (PC + 4);			
   
-- compute value of next PC

Next_PC <=  (PC + 4)    when PCSource = '0' else
            Branch_PC    when PCSource = '1' else
            X"CCCCCCCC";
			   
-- update the PC on the next clock			   
	PROCESS
		BEGIN
			WAIT UNTIL (rising_edge(clock));
			IF (reset = '1') THEN
				PC<= X"00000000" ;
			ELSE 
				PC <= Next_PC;    -- cannot read/write a port hence need to duplicate info
			 end if; 
			 
	END PROCESS; 
   
   end behavioral;


	
