.text

li a7, 5
ecall
mv t0, a0 #t0 = a

li a7, 5
ecall
mv t1, a0 #t1 = b

li a7, 5
ecall
mv t2, a0 #t2 = c

mul t1, t1, t2 #mul priority
add t0, t0, t1

mv a0, t0
li a7, 1
ecall

li a7, 10
ecall
