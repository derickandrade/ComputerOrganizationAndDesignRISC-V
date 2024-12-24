.text

li a7, 5
ecall
mv t0, a0 #carrega o A no t0

li a7, 5
ecall
mv t1, a0 #carrega o B no t1

li a7, 5
ecall
mv t2, a0 #carrega o C no t2

mul t2, t2, t1
add t0, t2, t0

mv a0,t0
li a7, 1
ecall

li a7, 10
ecall