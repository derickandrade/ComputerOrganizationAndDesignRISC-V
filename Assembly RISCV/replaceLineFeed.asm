######################## Cabeçalho da resposta - não alterar ###################
.data 
str:	.space 32
nl:	    .word 10

.text
	li a7, 8
	la a0, str
	li a1, 30
	ecall
	
	lw  a1, nl
	jal limpa
	
	li a7, 4
	la a0, str
	ecall
	
	li a7, 10
	ecall
	
######################## Escreva a função limpa a seguir #######################	

limpa:		add t0, ra, zero		#t0 = return address to main
		la t1, nl
		lw t1, 0(t1)
		li t3, 0 #t3 = index
		li t4, 0 #t4 = actual address
		la t5, str
		
		LOOP:	beq t2, t1, REPLACE
			add t4, t5, t3
			addi t3, t3, 1
			lb t2, 0(t4)
			beq t2, t1, REPLACE
			j LOOP
			
			
		REPLACE:	sb zero, 0(t4)
				jalr t0	
	
	