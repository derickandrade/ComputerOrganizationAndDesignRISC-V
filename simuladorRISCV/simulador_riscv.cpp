// Compilador: não consegui encontrar, o compilador do VS Code 2022 dos pcs do linf
// SO: Windows
// IDE: VS Code 2022


#include <iostream>
#include <fstream>
#include <cstdlib>

#define MEM_SIZE 16384

int8_t mem[MEM_SIZE];

const uint8_t mask = 0xFF;
bool stop = false;
bool flag = false;



// Registradores
uint32_t pc = 0x00000000;
uint32_t ri = 0x00000000;
uint32_t sp = 0x00003ffc;
uint32_t gp = 0x00001800;
int32_t R[32] = { 0 };

struct instruction_context_st {
    uint32_t opcode;
    uint32_t rd, rs1, rs2;
    uint32_t shamt;
    uint32_t funct3, funct7;
    int32_t imm12_i, imm12_s, imm13, imm20_u, imm21;
};

instruction_context_st ic;

int32_t sign_extend(int32_t value, int bits) {
    int32_t mask = 1 << (bits - 1);
    return (value ^ mask) - mask;
}

// Funções acesso à de memória:
int32_t lw(int reg, int kte) {
    if ((reg + kte) % 4 != 0) {
        std::cout << "Erro: endereço não é múltiplo de 4!\n";
        return 0;
    }
    int32_t word1 = 0;

    word1 = (uint8_t)mem[reg + kte];
    word1 |= (uint8_t)mem[reg + kte + 1] << 8;
    word1 |= (uint8_t)mem[reg + kte + 2] << 16;
    word1 |= (uint8_t)mem[reg + kte + 3] << 24;

    return word1;
}
void sw(int reg, int kte, int32_t word) {

    if ((reg + kte) % 4 != 0) {
        std::cout << "Erro: endereço não é múltiplo de 4!\n";
    }

    else {
        mem[reg + kte] = word & mask;

        word = word >> 8;
        mem[reg + kte + 1] = word & mask;

        word = word >> 8;
        mem[reg + kte + 2] = word & mask;

        word = word >> 8;
        mem[reg + kte + 3] = word & mask;
    }

}
void sb(int reg, int kte, int8_t byte) {
    mem[reg + kte] = byte;
}

int32_t lb(int reg, int kte) {
    int8_t byte;
    int32_t word;

    byte = mem[reg + kte];
    word = (int32_t)byte;

    return word;
}

uint32_t lbu(int reg, int kte) {
    int8_t byte;
    uint32_t word;

    byte = mem[reg + kte];
    word = (uint8_t)byte;

    return (uint32_t)word;
}

void fetch() {
    if (pc > MEM_SIZE) {
        std::cout << "\n-- program is finished running (dropped off bottom) --\n";
        stop = true; // Encerra o programa se o pc está fora do intervalo
    }
    ri = lw(pc, 0); // Busca a instrução com base no pc
    pc += 4; //como faço o incremento do pc aqui, vou subtrair 4 nas instruções que usam o pc
}

void decode(instruction_context_st& ic) {
    ic.opcode = ri & 0x7F;
    ic.rd = (ri >> 7) & 0x1F;
    ic.funct3 = (ri >> 12) & 0b0111;

    ic.rs1 = (ri >> 15) & 0x1F;
    ic.rs2 = (ri >> 20) & 0x1F;
    ic.shamt = (ri >> 20) & 0x1F;
    ic.funct7 = (ri >> 25);

    ic.imm12_i = sign_extend(ri >> 20, 12);
    ic.imm12_s = sign_extend(((ri >> 25) << 5) | ((ri >> 7) & 0x1F), 12);
    ic.imm13 = sign_extend(((ri >> 31) << 12) | (((ri >> 7) & 0x1) << 11) |
        (((ri >> 25) & 0x3F) << 5) | ((ri >> 8) & 0xF), 13) & (~1);
    ic.imm20_u = (ri & (~0xFFF));
    ic.imm21 = sign_extend(((ri >> 31) << 20) | ((ri >> 12) & 0xFF) << 12 |
        ((ri >> 20) & 0x1) << 11 | ((ri >> 21) & 0x3FF) << 1, 21) & (~1);
}

void add(instruction_context_st& ic) {
    R[ic.rd] = R[ic.rs1] + R[ic.rs2];
}

void sub(instruction_context_st& ic) {
    R[ic.rd] = R[ic.rs1] - R[ic.rs2];
}

void slt(instruction_context_st& ic) {
    R[ic.rd] = (R[ic.rs1] < R[ic.rs2]) ? 1 : 0;
}

void sltu(instruction_context_st& ic) {
    R[ic.rd] = ((uint32_t)R[ic.rs1] < (uint32_t)R[ic.rs2]) ? 1 : 0;
}

void funcao_xor(instruction_context_st& ic) {
    R[ic.rd] = R[ic.rs1] ^ R[ic.rs2];
}

void funcao_or(instruction_context_st& ic) {
    R[ic.rd] = R[ic.rs1] | R[ic.rs2];
}

void funcao_and(instruction_context_st& ic) {
    R[ic.rd] = R[ic.rs1] & R[ic.rs2];
}

void addi(instruction_context_st& ic) {
    R[ic.rd] = R[ic.rs1] + ic.imm12_i;
}

void slli(instruction_context_st& ic) {
    R[ic.rd] = R[ic.rs1] << ic.imm12_i;
}

void srli(instruction_context_st& ic) {
    R[ic.rd] = (uint32_t)R[ic.rs1] >> ic.imm12_i; //só dá certo se forçar o valor do registrador a ser unsigned
}

void srai(instruction_context_st& ic) {
    R[ic.rd] = R[ic.rs1] >> ic.imm12_i;
}

void ori(instruction_context_st& ic) {
    R[ic.rd] = R[ic.rs1] | ic.imm12_i;
}

void andi(instruction_context_st& ic) {
    R[ic.rd] = R[ic.rs1] & ic.imm12_i;
}

void auipc(instruction_context_st& ic) {
    R[ic.rd] = pc + (ic.imm20_u) - 4;
}

void lui(instruction_context_st& ic) {
    R[ic.rd] = (ic.imm20_u);
}

void beq(instruction_context_st& ic) {
    if ((R[ic.rs1]) == (R[ic.rs2])) {
        pc = pc + (ic.imm13 << 1) - 4;
    }
}

void bne(instruction_context_st& ic) {
    if (R[ic.rs1] != R[ic.rs2]) {
        pc = (pc + (ic.imm13 << 1) - 4);
    }
}

void blt(instruction_context_st& ic) {
    if (R[ic.rs1] < R[ic.rs2]) {
        pc = (pc + (ic.imm13 << 1) - 4); 
    }
}

void bge(instruction_context_st& ic) {
    if (R[ic.rs1] >= R[ic.rs2]) {
        pc = pc + (ic.imm13 << 1) - 4;
    }
}

void bgeu(instruction_context_st& ic) {
    if ((uint32_t)R[ic.rs1] >= (uint32_t)R[ic.rs2]) { //deu errado quando tentei criar uma função pra tirar o valor absoluto
        pc = (pc + (ic.imm13 << 1) - 4);
    }
}

void bltu(instruction_context_st& ic) {  
    if ((uint32_t)R[ic.rs1] < (uint32_t)R[ic.rs2]) {
        pc = (pc + (ic.imm13 << 1) - 4);
    }
}

void jalr(instruction_context_st& ic) {
    R[ic.rd] = pc + 4;
    pc = (R[ic.rs1] + (ic.imm12_i) - 4) & (~1);
}

void jal(instruction_context_st& ic) {
    R[ic.rd] = pc + 4;
    pc = pc + (ic.imm21) - 4;
}

void ecall() {
    if (R[17] == 1) { //li a7, 1\ ecall p/ imprimir inteiros
        std::cout << R[10];
    }
    else if (R[17] == 4) { //li a7, 4 ecall p/ imprimir strings terminadas em caractere nulo
        int i = 0;
        while (static_cast<char>(lb(R[10], i) != '\0')) { //verifica se o caractere que vai ser impresso é o caractere nulo pra parar de imprimir
            std::cout << static_cast<char>(lb(R[10], i));
            i++;
        }
    }
    else if (R[17] == 10) { //li a17, 10 ecall encerra o programa
        std::cout << "\n-- program is finished running (0) --\n";
        stop = true;
    }
}

void execute(instruction_context_st& ic) {

    if (ic.opcode == 0b0110011) { //instruções tipo R
        if (ic.funct3 == 0b000) {
            if (ic.funct7 == 0b000) {
                add(ic);
            }
            else if (ic.funct7 == 0b0100000) {
                sub(ic);
            }
        }
        else if (ic.funct3 == 0b010) {
            if (ic.funct7 == 0b0000000) {
                slt(ic);
            }
        }
        else if (ic.funct3 == 0b011) {
            if (ic.funct7 == 0b0000000) {
                sltu(ic);
            }
        }
        else if (ic.funct3 == 0b100) {
            if (ic.funct7 == 0b0000000) {
                funcao_xor(ic);
            }
        }
        else if (ic.funct3 == 0b110) {
            if (ic.funct7 == 0b000) {
                funcao_or(ic);
            }
        }
        else if (ic.funct3 == 0b111) {
            if (ic.funct7 == 0b0000000) {
                funcao_and(ic);
            }
        }
    }
    else if (ic.opcode == 0b0000011) { //instruções tipo I de load
        if (ic.funct3 == 0b000) {
            R[ic.rd] = lb(R[ic.rs1], ic.imm12_i);
        }
        else if (ic.funct3 == 0b010) {
            R[ic.rd] = lw(R[ic.rs1], ic.imm12_i);
        }
        else if (ic.funct3 == 0b100) {
            R[ic.rd] = lbu(R[ic.rs1], ic.imm12_i);
        }
    }
    else if (ic.opcode == 0b0010011) { //instruções tipo I lógicas e aritméticas
        if (ic.funct3 == 0b000) {
            addi(ic);
        }
        else if (ic.funct3 == 0b001) {
            if (ic.funct7 == 0b0000000) {
                slli(ic);
            }
        }
        else if (ic.funct3 == 0b101) {
            if (ic.funct7 == 0b0000000) {
                srli(ic);
            }
            else if (ic.funct7 == 0b0100000) {
                srai(ic);
            }
        }
        else if (ic.funct3 == 0b110) {
            ori(ic);
        }
        else if (ic.funct3 == 0b111) {
            andi(ic);
        }
    }
    else if (ic.opcode == 0b0010111) {
        auipc(ic);
    }
    else if (ic.opcode == 0b0100011) { //instruções tipo S
        if (ic.funct3 == 0b000) {
            sb(R[ic.rs1], ic.imm12_s, R[ic.rs2]);
        }
        else if (ic.funct3 == 0b010) {
            sw(R[ic.rs1], ic.imm12_s, R[ic.rs2]);
        }
    }
    else if (ic.opcode == 0b0110111) {
        lui(ic);
    }
    else if (ic.opcode == 0b1100011) { //instruções tipo SB
        if (ic.funct3 == 0b000) {
            beq(ic);
        }
        else if (ic.funct3 == 0b001) {
            bne(ic);
        }
        else if (ic.funct3 == 0b100) {
            blt(ic);
        }
        else if (ic.funct3 == 0b101) {
            bge(ic);
        }
        else if (ic.funct3 == 0b110) {
            bltu(ic);
        }
        else if (ic.funct3 == 0b111) {
            bgeu(ic);
        }
    }
    else if (ic.opcode == 0b1100111) {
        jalr(ic);
    }
    else if (ic.opcode == 0b1101111) {
        jal(ic);
    }
    else if (ic.opcode == 0b1110011) {
        ecall();
    }
    R[0] = 0; //sempre que uma instrução é executada, eu garanto que o registrador zero vai ser 0
}

void run() {
    while (stop == false) {
        fetch();
        decode(ic);
        execute(ic);
    }
}

void load_mem(const std::string& filename, size_t start_address) {
    if (start_address >= MEM_SIZE) {
        std::cerr << "Erro: Endereço inicial fora dos limites da memória!" << std::endl;
        stop = true;
    }

    std::ifstream file(filename, std::ios::binary | std::ios::in);

    if (!file.is_open()) {
        std::cerr << "Erro ao abrir o arquivo: " << filename << std::endl;
        stop = true;
    }

    size_t max_size = MEM_SIZE - start_address;

    file.read(reinterpret_cast<char*>(&mem[start_address]), max_size);

    file.close();
}

void step() {
    fetch();
    decode(ic);
    execute(ic);
    std::cout << std::dec << "PC: " << pc << "\nri: " << std::hex << ri << std::endl;
}
void reset() {
    system("cls");
    stop = false;
    for (int i = 0; i < 32; i++) {
        R[i] = 0;
    }
    for (int i = 0; i < MEM_SIZE; i++) {
        mem[i] = 0;
    }
    pc = 0;
    sp = 0x00003ffc;
    gp = 0x00001800;
}

int main() {
    R[0] = 0;
    R[2] = sp;
    R[3] = gp;
    stop = false;
    int opcao = 0;
    char entrada;
    while (true) {
        std::cout << "Escolha uma opção\n1)Rodar o código testador.asm\n2)Rodar o código testador.asm passo a passo\n3)Rodar o código primos.asm\n4)Rodar o código primos.asm passo a passo\n";
        std::cin >> opcao;
        switch (opcao) {
        case 1:
            load_mem("code.bin", 0x0000);
            load_mem("data.bin", 0x2000);
            run();
            break;
        case 2:
            load_mem("code.bin", 0x0000);
            load_mem("data.bin", 0x2000);
            while (stop == false) {
                step();
                std::cin.get();
            }
            break;
        case 3:
            load_mem("code1.bin", 0x0000);
            load_mem("data1.bin", 0x2000);
            run();
            break;
        case 4:
            load_mem("code1.bin", 0x0000);
            load_mem("data1.bin", 0x2000);
            while (stop == false) {
                step();
                std::cin.get();
            }
            break;
        }
        
        std::cout << "Digite C para continuar, X para sair\n";
        std::cin >> entrada;
        if (entrada == 'x') {
            exit(0);
        }
        else if (entrada == 'c') {
            reset();
        }   
    }
    return 0;
}