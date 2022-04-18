addi s0, x0, 1919
lui  s0, 703710

srai t0, s0, 30 # issues here with sra
srai t0, s0, 31

srai s0, t0, 16
srai s0, t0, 15
srai s0, t0, 8

srai s0, t0, 1


