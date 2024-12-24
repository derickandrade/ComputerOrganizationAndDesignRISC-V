#include <stdio.h>
#include <stdint.h>
#include <string.h>

#define MEM_SIZE 16384

int8_t mem[MEM_SIZE];
const uint8_t mask = 0xFF;

int8_t byte;
uint32_t word;

int reg;
int kte;

void sb(int reg, int kte, int8_t byte){
    
    mem[reg + kte]  = byte;
    
    return;
}

int32_t lb(int reg, int kte){
    
    byte = mem[reg + kte];
    word = (int32_t)byte;
    
    return word;
}

uint32_t lbu(int reg, int kte){
    
    byte = mem[reg + kte];
    word = (uint8_t)byte;
        
    return (uint32_t)word;
}

uint32_t lw(int reg, int kte){
    
    if ((reg + kte)% 4 != 0){

        printf("Erro: endereco nao e multiplo de 4!");
        
        return -1;
    }

    else{
        
    word  = (uint8_t)mem[reg + kte];
    word |= (uint8_t)mem[reg + kte + 1] << 8;
    word |= (uint8_t)mem[reg + kte + 2] << 16;
    word |= (uint8_t)mem[reg + kte + 3] << 24;
    
    return word;

    }
    
}

void sw(int reg, int kte, int32_t word) {
    
    if ((reg + kte) % 4 != 0){
        
        printf("Erro: endereco nao e multiplo de 4!");
        
        return;
    }
    
    else{

	mem[reg + kte] = word & mask;

	word = word >> 8;
	mem[reg + kte + 1] = word & mask;

	word = word >> 8;
	mem[reg + kte + 2] = word & mask;

	word = word >> 8;
	mem[reg + kte + 3] = word & mask;
	
	return;
    }

}

int main()
{

    sw(0, 0, 0xABACADEF);
    sb(4, 0, 1);
    sb(4, 1, 2);
    sb(4, 2, 3);
    sb(4, 3, 4);

    printf("%X\n", lw(0, 0));
    printf("%X\n", lb(0, 0));
    printf("%X\n", lb(0, 1));
    printf("%X\n", lb(0, 2));
    printf("%X\n", lb(0, 3));
    printf("%X\n", lbu(0, 0));
    printf("%X\n", lbu(0, 1));
    printf("%X\n", lbu(0, 2));
    printf("%X\n", lbu(0, 3));
    
	return 0;
}
