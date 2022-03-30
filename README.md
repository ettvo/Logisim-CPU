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

Task 4: CPU
> Need to break down input into components (opcode, instruction, register1, register2, destination_register, etc.) 

<000> indicates difference from R-Type Format

R-Type Format (regular)
    funct7 [31-25]
    rs2 [24-20]
    rs1 [19-15]
    funct3 [14-12]
    rd [11-7] --> destination
    opcode [6-0]
 ex: add t0, t1, t2

I-Type Format (immediate)
    imm [31-20] --> need to sign extend to 32-bit before arithmetic operation <000>
    rs1 [19-15]
    funct3 [14-12]
    rd [11-7] --> destination
    opcode [6-0]
ex: addi t0, t1, 3
    
S-Type Format (store)
    imm(11:5) [31-25] <000>
    rs2 [24-20] <000>
    rs1 [19-15]
    funct3 [14-12]
    imm(4:0) [11-7] --> destination <000>
    opcode [6-0]
ex: sw x7, 12(x5)

Branch-Type Format
Jump-Type Format
U-Format


 

