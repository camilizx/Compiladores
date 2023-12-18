.data
p: .space 4
x: .space 4
.text
li a7, 5
ecall
la a1, p
sw a0, 0(a1)
li t0, 1
addi sp, sp, -4
sw t0, 0(sp)
la a0, x
lw t0, 0(sp)
sw t0, (a0)
addi sp, sp, 4
while_0:
la t0, p
addi sp, sp, -4
lw t0, 0(t0)
sw t0, 0(sp)
li t0, 1
addi sp, sp, -4
sw t0, 0(sp)
lw t0, 4(sp)
lw t1, 0(sp)
slt t0, t1, t0
addi sp, sp, 4
sw t0, 0(sp)
beqz t0, end_while_0
la t0, p
addi sp, sp, -4
lw t0, 0(t0)
sw t0, 0(sp)
la t0, x
addi sp, sp, -4
lw t0, 0(t0)
sw t0, 0(sp)
lw t0, 4(sp)
lw t1, 0(sp)
mul t0, t0, t1
addi sp, sp, 4
sw t0, 0(sp)
la a0, x
lw t0, 0(sp)
sw t0, (a0)
addi sp, sp, 4
la t0, p
addi sp, sp, -4
lw t0, 0(t0)
sw t0, 0(sp)
li t0, 1
addi sp, sp, -4
sw t0, 0(sp)
lw t0, 4(sp)
lw t1, 0(sp)
sub t0, t0, t1
addi sp, sp, 4
sw t0, 0(sp)
la a0, p
lw t0, 0(sp)
sw t0, (a0)
addi sp, sp, 4
j while_0
end_while_0:
la t0, x
addi sp, sp, -4
lw t0, 0(t0)
sw t0, 0(sp)
lw a0, 0(sp)
li a7, 1
ecall
addi sp, sp, 4
li a7, 11
li a0, 10
ecall
li a7, 10
ecall
