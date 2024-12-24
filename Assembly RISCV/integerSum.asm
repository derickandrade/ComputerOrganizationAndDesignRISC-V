.text

li a7, 5 #read int syscall
ecall
#a0 = the integer
mv t0, a0 #t0 has the first integer

li a7, 5
ecall
mv t1, a0

add t0, t0, t1
mv a0, t0

li a7, 1
ecall

li a7, 10 #exit program syscall
ecall