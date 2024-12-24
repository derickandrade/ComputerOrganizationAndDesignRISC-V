.text 

li a7, 5
ecall
mv t0, a0

li t1, 32			#t1 = for range = 32 bits

LOOP:	beq t1, t2, END		#t2 = for index
	addi t2, t2, 1		#t2++
	andi t3, t0, 1		#t3 = (number AND 1) ? LSB=1 : LSB=0
	add t4, t3, t4		#t4 = accumulator
	srai t0, t0, 1		#next bit	
	j LOOP
	
END:	mv a0, t4
	li a7, 1
	ecall
	
	li a7, 10
	ecall