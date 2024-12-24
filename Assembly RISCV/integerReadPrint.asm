.text

li a7, 5 #read int syscall
ecall
#a0 = the integer

li a7, 1 #print int syscall
ecall

li a7, 10 #exit program syscall
ecall