.text

li a7, 5
ecall 
mv t0, a0

LOOP: 	li a7, 5
	ecall
	add t2, t2, a0
	
	addi t1, t1, 1
	
	blt t1, t0, LOOP

mv a0,t2
li a7,1
ecall

li a7,10
ecall