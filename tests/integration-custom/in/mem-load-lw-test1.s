addi s0, x0, 200
lui  s1, 1200   # 0x15263748
addi s1, s1, 1234
sw   s1, 4(s0) # instruction = ???; opcode = 0x23, funct3 = 0x2
sw   s1, -8(s0)

lw   t0, 4(s0) # instruction = 0xff842283; opcode = 0x03, funct3 = 0x2
lw   t1, -8(s0)

# 0xfffffffc
# 2434 + -8