.data
n: .space 4
x: .space 4
.text
li a7, 5
ecall
la a1, n
sw a0, 0(a1)
li t0, 0
addi sp, sp, -4
sw t0, 0(sp)
la a0, x
lw t0, 0(sp)
sw t0, (a0)
addi sp, sp, 4
if_0:
la t0, n
addi sp, sp, -4
lw t0, 0(t0)
sw t0, 0(sp)
li t0, 5
addi sp, sp, -4
sw t0, 0(sp)
lw t0, 4(sp)
lw t1, 0(sp)
slt t0, t1, t0
addi sp, sp, 4
sw t0, 0(sp)
beqz t0, else_if_0
la t0, n
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
j end_if_0
else_if_0:
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
end_if_0:
li a7, 10
ecall
