addi s0, x0, 200
lui  s1, 1200   # 0x15263748
addi s1, s1, 1234
sw   s1, 4(s0)
sw   s1, -8(s0)

lw   t0, 4(s0)

lw   t0, -32(s0)