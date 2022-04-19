# CS61CPU

Look ma, I made a CPU! Here's what I did:

-

Following are comments / pseudo-code on how to do the tasks:

Part A: addi

Task 1: ALU
ALU Sel Value	|	Instruction							|	Implemented?	|	Tested?
0			|	add: Result = A + B					|	Y			|	
1			|	sll: Result = A << B					|	Y			|
2			|	slt: Result = (A < B (signed)) ? 1 : 0		|	Y			|
3			|	Unused							|	N/A			|	N/A
4			|	xor: Result = A ^ B					|	Y			|
5			|	srl: Result = (unsigned) A >> B			|	Y			|
6			|	or: Result = A | B					|	Y			|
7			|	and: Result = A & B					|	Y			|
8			|	mul: Result = (signed) (A * B)[31:0]		|	Y			|
9			|	mulh: Result = (signed) (A * B)[63:32]	|	Y			|
10			|	Unused							|	N/A			|	N/A
11			|	mulhu: Result = (A * B)[63:32]			|	Y			|
12			|	sub: Result = A - B					|	Y			|
13			|	sra: Result = (signed) A >> B			|	Y			|
14			|	Unused							|	N/A			|	N/A
15			|	bsel: Result = B					|	Y			|


0 ADD
> given

1 SLL
> Result = A << B
> cut off top 27 bits of B --> use extender with left value 32, right 5 as bottom input for shifter 
> top input of shifter being A

2 SLT
>  Result = (A < B (signed)) ? 1 : 0
> Return 1 if A < B [signed values]
> Return 0 if A > B || A == B

4 XOR
> use buit-in

5 SRL
> Result = (unsigned) A >> B	
> Approaches:
> 1) same as dividing A by 2^B and rounding down
>>>> calculate 2^B with bit shifting --> use as input for divider
>>>> automatic rounding down due to restriction to 32 bits
> 2) works with bit extension / truncation
>>>> truncate last B - 32 bits of A
>>>>*>>>> can use the bit selector for this part
>>>> extend A by B - 32 bits to the left [keep sign]
>  3) use bit splitter and an AND for every 32 bit
> 4) shift right arithmetic and multiply by either -1 or 1 to make positive
>>>> use 13 SRA to get the value
>>>> use multiplexor to determine what is outputted
>>>>*>>>> negative --> multiply by -1
>>>>*>>>> positive --> output directly
> 5) Rotate Right
>>>>  R = A >> B | A << (16 - B) 
>>>> used this one


6 OR
> use built-in

7 AND
> use built-in

8 SIGNED MUL
> Result = (signed) (A * B)[31:0]	

9 SIGNED MULH
> Result = (signed) (A * B)[63:32]
> sign extend A and B to 64
> multiply with 64 bit width
> shift right logical 32 bits
> sign extend [truncate] top 32 bits

11 MULHU
> Result = (A * B)[63:32]	
> same as 9 SIGNED MULH, just change operators to being unsigned

12 SUB
> can add two's complement version of B --> shift accordingly

13 SRA 
> Result = (signed) A >> B	

15 BSEL
> just output only B


Use a multiplexor to decide which to output according to input [ALUSel]
---

Task 2: RegFile
> use a demultiplexer --> output 1 to RegWEn if RegWEn==1 AND WriteReg is the current register
>>>> input to multiplexor: WriteReg multiplied by RegWriteData --> determine whether or not any write at all
> used a multiplexer w/ the same overall format but different tunnels as the multiplexor for WriteReg to write output for ReadReg1, ReadReg2


Task 3: Immediate Generator
> used a bit splitter
> got each 4 bit segment that were part of the immediate in the I-Type Format
> bit extended each to 32 bits
> rotated right each one a certain number of places according to their placement relative to each other
> added them all together to get result
> (can also just put two splitters and feed the input immediate into the second one to get the merged value)

Task 4: CPU
> Need to break down input into components (opcode, instruction, register1, register2, destination_register, etc.) 

<000> indicates difference from R-Type Format

Since all opcode for this project ends in 11, truncate the 11 and use bits 6-2 instead of 6-0 for the calculations

R-Type Format (regular)
    funct7 [31-25] 
    rs2 [24-20]
    rs1 [19-15]
    funct3 [14-12]
    rd [11-7] --> destination
    opcode [6-0]
 ex: add t0, t1, t2
 --> opcode: 0110011 --> 01100 = 12

I-Type Format (immediate)
    imm [31-20] --> need to sign extend to 32-bit before arithmetic operation <000>
    rs1 [19-15]
    funct3 [14-12]
    rd [11-7] --> destination
    opcode [6-0]
ex: addi t0, t1, 3
note: includes load instructions
--> immediate logical arithmetic opcode: 0x13 = 0010011 --> 00100 = 4
--> load opcode: 0000011 --> 00000 = 0
--> jalr opcode: 1100111 --> 11001 = 25
    
S-Type Format (store)
    imm(11:5) [31-25]
    rs2 [24-20]
    rs1 [19-15]
    funct3 [14-12]
    imm(4:0) [11-7]
    opcode [6-0]
ex: sw x7, 12(x5)
--> opcode: 0100011 --> 01000 = 8

Branch-Type Format (store)
    imm(12) [31]
    imm(10:5) [30-25]
    rs2 [24-20]
    rs1 [19-15]
    funct3 [14-12]
    imm(4:1) [11-8]
    imm(11) [7]
    opcode [6-0]
ex: sw x7, 12(x5)
--> opcode: 1100011 --> 11000 = 24

J-Format (jump)
    imm(20) [31]
    imm(10:1) [30-21]
    imm(11) [20]
    imm(19:12) [19-12]
    rd [11-7]
    opcode [6-0]
ex: jal
--> jal opcode: 1101111 --> 11011 = 27

U-Format
    imm(31:12) [31:12]
    rd [11-7]
    opcode [6-0]
--> lui opcode = 0110111 --> 01101 = 13
--> auipc opcode = 0010111 --> 00101 = 5

R, S, Branch use register 2
R, I, J, U use rd
(still need to determine return register for S, branch)

> create an "if" using A --> B meaning (!A OR B = result)
> will use multiplexor to determine value since different types of commands use different opcode and all use opcode --> determine what to use 
> set everything to 0 that is not for current instruction format, leave things for current instruction format as-is, OR together at end?
> can omit last 2 characters in opcode due to all opcode ending in 2 one's 

The only values for funct7 are 0 (0b000000), 5 (0b000101), and 32 (0b100000)
--> can use only 2 bits for selecting values (due to limitations on multiplexor data bits)
--> take first bit and last bit --> concatenate with bit splitter
--> 0 == 0b00
--> 1 == 0b01
--> 32 == 0b10

Work that should be in control logic is actually in cpu because I tried to work ahead and Logism doesn't let me control paste things

Default ImmSel:
I --> 0
S --> 1
B --> 2
U --> 3
J --> 4
(R should not have one)

TODO: 
* use opcode values to determine how to use multiplexor to choose which format to use
* use tunnels to create input for each format (focus on I-format [immediates] for addi)
* fix load instructions for I-format in imm-gen specifics not implemented
* fix shift immediate for I-format in imm-gen specifics not implemented
* complete signed / unsigned operations for R format in CPU
* store instructions for S-format in imm-gen specifics not fully implemented
* branch instructions for B-format in imm-gen specifics not fully implemented
* jump instructions for B-format in imm-gen specifics not fully implemented
* immediate format currently sign extends even for unsigned operations (FIX)
* make it pass imm_gen tests (fix B, J, S, U formats)
* TODO: add OR for jump instructions to do_branch on CPU

Seem to have accidentally bypassed:
> Execute: What two data values (A and B) should an B-type instruction input to the ALU?

Note:
> need to check ALU is implemented for current format before running tests

Currently:
* Pause on 7.3
>> bash test.sh test_integration_jump
>> bash test.sh test_integration_mem
* most likely SRA one of biggest contributors to things not working
* code currently doesn't do correct functions for negative shifts
* operation doesn't properly work for Store

>> changed wiring for jal, hjalr 
>> need to change jal, jalr wiring; one of them is I-format and accidentally miswired them throughout because jalr is op25, jal op27, not other way around
>> currently no tests available for auipc


introduce more programs for integration testing

still need:
> bash test.sh test_integration_mem
> my own test files (12)

Note:
> jal is I-type --> need to go into ALU to fix
>> jal is I-type, which would mean different processing of instruction