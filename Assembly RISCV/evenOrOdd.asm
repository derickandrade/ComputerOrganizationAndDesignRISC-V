.data
itsEven:	.string "It's even."
itsOdd: 	.string "It's odd."

.text

li a7, 5
ecall

andi t0, a0, 1 #a0(0) = 1 ? odd(1) : even(0)
beq t0, zero, EVEN #if t0 = 0 go to EVEN label
la a0, itsOdd
li a7, 4
ecall
j END

EVEN:	la a0, itsEven
	li a7, 4
	ecall

END:	li a7, 10
	ecall