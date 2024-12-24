.data

espaco: .asciz " "
quebra_de_linha: .asciz "\n"
mensagem: .string "\nEscolha uma opção:\n1)Escrever em uma célula\n2)Ler uma célula\n3)Calcular matriz transposta\n4)Somar duas matrizes\n5)Multiplicar duas matrizes\n6)Imprimir a matriz resultado\n7)Encerrar o programa\n"
erro: .string "\nInsira um opção válida!\n"	
	
m1: 
	.word 	1, 2, 3,
		4, 5, 6,
		7, 8, 9

m2: 
	.word 	1, 4, 7,
		2, 5, 8,
		3, 6, 9


mr: 
	.word 	0, 0, 0,
		0, 0, 0,
		0, 0, 0

lado: .word 3

linha: .string "Linha: "

coluna: .string "Coluna: "

valor: .string "Valor: "

pergunta: .string "\nA ação vai ser feita em qual matriz?(digite 1 ou 2)\n"

.text

la s1, m1	#s1 = endereço base da matriz m1
la s2, m2	#s2 = endereço base da matriz m2
la s3, mr	#s3 = endereço base da matriz mr
la s4, lado	
lw s4, 0(s4) 	#s4 = tamanho do lado

slli s5, s4, 2 	#s5 = lado * 4 = tamanho do lado em bytes
mul s6, s4, s4
slli s6, s6, 2 	#s6 = tamanho da matriz em bytes

#os valores dos registradores S são os mesmos durante o programa

menu:

	la a0, mensagem
	li a7, 4
	ecall
	li a7, 5
	ecall
	li t0, 1 
	li t1, 2
	li t2, 3
	li t3, 4
	li t4, 5
	li t5, 6
	li t6, 7
	beq a0, t0, write_cel
	beq a0, t1, read_cel
	beq a0, t2, transposta_menu
	beq a0, t3, soma
	beq a0, t4, multiplica
	beq a0, t5, imprime
	beq a0, t6, fim
	la a0, erro
	li a7, 4
	ecall
	j menu
	
invalido:

	la a0, erro
	li a7, 4
	ecall
	j menu

pede_linha_coluna:

	la a0, linha
	li a7, 4
	ecall
		
	li a7, 5
	ecall
	mv t0, a0 #guardo linha no t0
		
	la a0, coluna
	li a7, 4
	ecall
		
	li a7, 5
	ecall
	mv t1, a0 #guardo coluna no t1

	ret

pergunta_matriz:

	la a0, pergunta
	li a7, 4
	ecall

	li a7, 5
	ecall
	
	li t1, 1
	li t2, 2
	beq a0, t1, matriz1
	bne a0, t2, invalido
	la t3, m2
	ret
	
matriz1:

	la t3, m1
	ret	

write_cel:

li t0, 0 #t0 = linha
li t1, 0 #t1 = coluna
li t2, 0 #t2 = valor 
li t3, 0 #t3 = endereço base da matriz
li t4, 0 #t4 = endereço específico da matriz que vou gravar

	jal pergunta_matriz
	jal pede_linha_coluna
		
	la a0, valor
	li a7, 4
	ecall
		
	li a7, 5
	ecall
	mv t2, a0 #guardo valor no t2

	addi t0, t0, -1 #indice vai começar em 0, então subtraio por 1
	addi t1, t1, -1 #msm coisa
		
	mul t4, t0, s4 #linha * numero de colunas (lado)
	add t4, t4, t1 # t0 = índice do elemento que vou escrever
	slli t4, t4, 2 #os endereços são múltiplos de 4
	add t4, t4, t3 #endereço base da matriz + deslocamento do índice * 4
		
	sw t2, 0(t4)
		
	j menu
		
read_cel: 

li t0, 0 #t0 = linha
li t1, 0 #t1 = coluna
li t3, 0 #t3 = endereço da matriz
li t4, 0 #t4 = endereço específico da matriz que vou ler

	jal pergunta_matriz
	jal pede_linha_coluna	
		
	addi t0, t0, -1
	addi t1, t1, -1
		
	mul t0, t0, s4
	add t0, t0, t1
	slli t0, t0, 2

	add t0, t0, t3
	lw t0, 0(t0)
	
	mv a0, t0 #retorna o número a0
	li a7, 1
	ecall
	
	j menu

transposta_menu:

	la a0, m1	#se a transposta foi chamada pelo menu, a matriz a ser transposta é a m1
			#senão, a matriz a ser transposta é a m2
transposta:

	li t0, 0 	#X
	li t1, 0 	#Y
	li t2, 0 	#a
	li t3, 0 	#b
	li t4, 0 	#indice do byte que vou guardar * 4
	li t5, 0 	#t5 = endereço que vou pegar o número
	li t6, 0 	#t6 = numero que eu peguei
	li a1, 0 	#endereço atual da mr que vou guardar
	
	#o endereço do elemento que vou pegar é (X*4) + (Y * lado * 4), Y cresce a cada elemento até (lado - 1), X cresce quando Y reseta
	
faz_linha:

	beq t1, s4, aumenta_x
	beq t4, s6, retorna
	slli t2, t0, 2 #a = X * 4
	slli t3, t1, 2 #b = Y * 4
	mul t3, t3, s4 #b = (Y*4) * lado
	add t2, t2, t3 #t2 = a+b
	add t5, a0, t2 #t5 = endeço base da matriz original + deslocamento
	lw t6, 0(t5)
	add a1, s3, t4 #endereço atual da 
	addi t4, t4, 4 #aumenta o número do byte da mr
	sw t6, 0(a1)
	addi t1, t1, 1		
	j faz_linha			
																							
aumenta_x:

	addi t0, t0, 1	
	li t1, 0
	j faz_linha
		
retorna:

	beqz a5, imprime #a5 é uma flag, se for 0 então não foi a multiplica que chamou, então quero que a matriz resultado seja impressa
	ret

soma:

li t0, 0 #t0 = deslocamento de bytes
li t1, 0 #t1 = endereço atual da m1
li t2, 0 #t2 = endereço atual da m2
li t3, 0 #t3 = endereço atual da mr
li t4, 0 #t4 = número
li t5, 0 #t5 = acumulador

soma_elemento:

	li t5, 0		#zera acumulador
	beq t0, s6, imprime	#se o deslocamento de bytes é igual o num de bytes que a matriz ocupa, começa a imprimir os resultados
	add t1, s1, t0 		#endereço base + deslocamento do indice; eu estava colocando a0, a0, t1 então da proxima e incrementando o contador, então da proxima vez que eu ia ler o endereço, tinha o endereço antigo mais 4, mais de 4 novo do contador, então eu pulava mais 4 duas vezes e dava errado
	add t2, s2, t0 		#mesma coisa
	add t3, s3, t0 		#mesma coisa
	
	lw t4, 0(t1) 		#elemento da matriz 1
	add t5, t5, t4
	lw t4, 0(t2) 		#elemento da matriz 2
	add t5, t5, t4 		#soma os elementos de cada matriz indice t1"
	sw t5, 0(t3)		#guarda o resultado da soma no endereço matriz resultado + deslocamento
	addi t0, t0, 4		#aumenta o deslocamento
	j soma_elemento

multiplica:

li a5, 1	#flag que foi a multiplica que chamou a transposta
la a0, m2	#a matriz a ser transposta é a m2
jal transposta
li a5, 0	#reseta a flag pra caso transposta for chamada depois no menu
	
copia_matriz:

li t0, 0 #t0 = índice da matriz em bytes
li t1, 0 #t1 = endereço atual da mr
li t2, 0 #t2 = endereço atual da m2
li t3, 0 #t3 = número sendo copiado da mr

copia_loop:

	beq t0, s6, zera_matriz
	add t1, s3, t0
	lw t3, 0(t1)
	add t2, s2, t0
	sw t3, 0(t2)
	addi t0, t0, 4
	j copia_loop

zera_matriz:

li t0, 0 #t0 = índice da matriz em bytes
li t1, 0 #t1 = endereço atual da mr

zera_loop:

	beq t0, s6, terminou_zerar
	add t1, s3, t0
	sw zero, 0(t1)
	addi t0, t0, 4
	j zera_loop

terminou_zerar:

li t0, 0 #t0 = número da m1 sendo lido
li t1, 0 #t1 = número da m2 sendo lido
li t2, 0 #t2 = multiplicação entre t0 e t1
li t3, 0 #t3 = endereço do número da m1
li t4, 0 #t4 = endereço do número da m2
li t5, 0 #t5 = contador de bytes
li a0, 0 #a0 = índice do elemento na primeira matriz
li a1, 0 #a1 = índice do elemento na segunda matriz
li a2, 0 #a2 = resultado
li a3, 0 #a3 = endereço que vai gravar na mr

calcula_elemento: 

	beq t5, s6, imprime 	#se o contador de bytes = tamanho da matriz já calculei tudo
	add t3, s1, a0		#endereço do elemento índice a0 da m1
	lw t0, 0(t3)
	add t4, s2, a1		#endereço do elemento índice a1 da m2
	lw t1, 0(t4)
	mul t2, t0, t1		#t2 = numM1 * numM2
	add a2, a2, t2		#acumular em a2
	
	addi a0, a0, 4		#aumenta o índice
	add t3, s1, a0
	lw t0, 0(t3)
	addi a1, a1, 4		#aumenta o índice
	add t4, s2, a1
	lw t1, 0(t4)
	mul t2, t0, t1
	add a2, a2, t2		#coloca no acumulador
	
	addi a0, a0, 4
	add t3, s1, a0
	lw t0, 0(t3)
	addi a1, a1 4
	add t4, s2, a1
	lw t1, 0(t4)
	mul t2, t0, t1
	add a2, a2, t2
	
	add a3, s3, t5		#enderenço na mr indíce t5
	sw a2, 0(a3)	
	addi t5, t5, 4		#incrementa o contador de bytes da mr
	addi a0, a0, -8		#reseta o contador da m1
	addi a1, a1, 4		#incrementa o contador da m2
	li a2, 0		#apaga o número encontrado
	
	rem a4, t5, s5		#se o contador de bytes é múltiplo do tamanho do lado, significa que acabou a linha
	beqz a4, proxima_linha
	j calcula_elemento
	
proxima_linha:

	add a0, a0, s5		#se a linha acabou, o índice da m1 vai começar em tamanho do lado * índice da linha
	li a1, 0		#reseta o índice da m2
	j calcula_elemento
	
imprime:
	
li t0, 0 #t0 = índice do elemento na linha
li t1, 0 #t1 = índice do elemento na matriz (em bytes)
li t2, 0 #t2 = endereço atual da matriz mr
li t3, 0 #t3 = número a ser impresso

imprime_linha:
	
	beq t1, s6, menu		#se já imprimiu toda a matriz, volta pro menu
	beq t0, s4, quebra_linha	#vê se chegou ao fim da linha pra quebrar ela
	
	add t2, s3, t1		#t2 é o endereço na posição s3(base) + t1(bytes)
	
	lw t3, 0(t2)		#busca o valor na memória
	mv a0, t3
	li a7, 1	
	ecall
	
	addi t1, t1, 4 		#incrementa o contador de bytes
	addi t0, t0, 1		#aumenta o índice do elemento na linha
	
	la a0, espaco
	li a7, 4
	ecall
	
	j imprime_linha
			
			
quebra_linha:
	
	la a0, quebra_de_linha
	li a7, 4
	ecall
	li t0, 0 #reseta o numero de elementos na linha

	j imprime_linha
		
fim:
	li a7, 10
	ecall
	
