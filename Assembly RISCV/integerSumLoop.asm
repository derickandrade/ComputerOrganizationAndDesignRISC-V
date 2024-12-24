.text

li a7, 5 #read int syscall
ecall
#a0 = the integer
mv t0, a0 #t0 = how many times I'll sum

LOOP:
beq t1, t0, END_PRINTING #t1 = index
addi t1, t1, 1

li a7, 5
ecall
mv t2, a0 

add t3, t2, t3 #t3 = sum accumulator
j LOOP

END_PRINTING:
mv a0, t3
li a7, 1
ecall

li a7, 10 #exit program syscall
ecall