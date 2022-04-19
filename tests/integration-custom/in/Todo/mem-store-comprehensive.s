addi s0, x0, 356
lui  s1, 1000
add s1, s0, s1

sw   s1, 4(s0)
lw   a0, 4(s0)

sh   s1, 4(s0)
lw   a0, 4(s0)
sh   s1, 6(s0)
lw   a0, 4(s0)

sb   s1, 4(s0)
lw   a0, 4(s0)
sb   s1, 5(s0)
lw   a0, 4(s0)
sb   s1, 6(s0)
lw   a0, 4(s0)
sb   s1, 5(s0)
lw   a0, 4(s0)

sw   s1, -8(s0)
lw   a0, -8(s0)

sh   s1, -8(s0)
lw   a0, -8(s0)
sh   s1, -6(s0)
lw   a0, -8(s0)

sb   s1, -8(s0)
lw   a0, -8(s0)
sb   s1, -5(s0)
lw   a0, -8(s0)
sb   s1, -6(s0)
lw   a0, -8(s0)
sb   s1, -3(s0)
lw   a0, -8(s0)
