################# Cabeçalho da Resposta - Não altere ###########################
.data
# segmento de dados
ehpar: 	 .string "Eh par"
ehimpar: .string "Eh impar"

#segmento de codigo
.text
# seu codigo aqui...
li a7, 5
ecall

andi t0, a0, 1 #a0(0) = 1 ? odd(1) : even(0)
beq t0, zero, EVEN #if t0 = 0 go to EVEN label
la a0, ehimpar
li a7, 4
ecall
j END

EVEN:	la a0, ehpar
	li a7, 4
	ecall

END:	li a7, 10
	ecall