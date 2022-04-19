addi s0, x0, 1919 # pc 4 --> 0000077f
lui  s0, 703710 # pc 8 --> abcde000

srai t0, s0, 30 # pc c --> fffffffe
srai t0, s0, 31 # pc 10 --> ffffffff

srai s0, t0, 16 # pc 14 --> ffffffff from ffffffff
srai s0, t0, 15 # pc 18 --> ffffffff from ffffffff
srai s0, t0, 8 # pc 1c --> ffffffff from ffffffff

srai s0, t0, 1 # pc 20 --> ffffffff from ffffffff

# pc 8, abcde000 = 0b1010 1011 1100 1101 1110 0000 0000 0000
# pc c, abcde000 >> 30 = 0b10 --> 0b1111 1111 1111 1111 1111 1111 1111 1110

# check ALU unit in cpu; connection to instruction in cpu

# 41f45293
# 41f45293

