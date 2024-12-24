############################# Cabeçalho da Resposta ############################
.data

rsp:  .space 30
size: .word 30

.text

#a1 tamanho maximo da string; s0 = end da string; s1 = indice; t2 = tamanho da string fornecida; t1 = o caractere sendo lido; t3 = ascii do a; t4 = ascii do z

la a0, rsp #espaço pra guardar a string
la a1, size #tamanho maximo da string
li a7, 8 #lê a string
ecall

la s0, rsp #endereco
li s1, 0 #i
li t2, 30 #tamanho

li t3, 97
li t4, 122


LOOP: 	bge s1, t2, DONE
	    slli t0, s1 , 0
	    add t0, s0, t0
	    lb t1, 0(t0) #le o primeiro char da string
	
	    blt t1, t3, PROXIMO 
	    bgt t1, t4, PROXIMO
	    addi t1, t1, -32 #subtrai o valor referente ao ascii
	    sb t1, 0(t0)
	    addi s1, s1,1
	    j LOOP
	
DONE: la a0, rsp #onde ta a string
li a7, 4 # printa a string
ecall


li a7, 10
ecall

PROXIMO:	addi s1, s1, 1
		j LOOP