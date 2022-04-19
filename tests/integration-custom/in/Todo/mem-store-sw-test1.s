addi s0, x0, 356
lui  s1, 1000
add s1, s0, s1

sw   s1, 4(s0)
lw   a0, 4(s0)

sw   s1, -8(s0)
lw   a0, -8(s0)
