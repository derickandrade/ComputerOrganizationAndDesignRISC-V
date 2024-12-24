.data

input: .space 30

.text

la a0, input
li a1, 30
li a7, 8
ecall

la t0, input 	#t0 = base address
li t1, 30	#t1 = size
li t2, 0	#t2 = index
li t3, 0	#t3 = char
li t4, 0	#t4 = actual address
li t5, 'a'
li t6, 'z'

LOOP:	beq t1, t2, END		#if index = size, print string
	add t4, t0, t2 		#actual address = base address + index
	addi t2, t2, 1		#t2++
	lb t3, 0(t4)		#t3 = char being read
	beq t3, zero, END	#if char = null, print string; the program works with either of the beq ENDs
	bge t3, t5, mayLowerCase
	
	mv a0, t3
	li a7, 11
	ecall
	
	j LOOP

mayLowerCase:	ble t3, t6, isLowerCase
		
		mv a0, t3
		li a7, 11
		ecall

		j LOOP

isLowerCase:	addi t3, t3, -32
		#sb t3, 0(t4) #I can change the original string and print it at the end of the program instead of printing chars while iterate 'em
		
		mv a0, t3
		li a7, 11
		ecall
		
		j LOOP

END:
#la a0, input
#li a7, 4
#ecall

li a7, 10 
ecall