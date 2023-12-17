#include "gencode.h"

int counter = -1;

void init_code(struct GC* gc) {
    for (int i = 0; i < MAX_CODE_LENGTH; i++) {
        gc->code[i] = NULL;
    }
}

void gen_code(struct GC* gc, const char* operacao, const char* id) {
    // Verificar se há espaço disponível no vetor de códigos
    if (gc == NULL || gc->code[MAX_CODE_LENGTH - 1] != NULL) {
        printf("Erro: Sem espaço para mais códigos.\n");
        return;
    }

    // Alocar memória para a operação e o identificador
    char* codigo = (char*)malloc(strlen(operacao) + strlen(id) + 1000);
    if (codigo == NULL) {
        printf("Erro de alocação de memória.\n");
        return;
    }

    // Construir o código concatenando operação e identificador
    if (strcmp(operacao, "data") == 0) {
        strcat(codigo, ".data\n");
    } 
    else if (strcmp(operacao, "text") == 0) {
        strcat(codigo, ".text\n");
    } 
    else if (strcmp(operacao, "end") == 0) {
        strcat(codigo, "li a7, 10\n");
        strcat(codigo, "ecall\n");
    } 
    else if (strcmp(operacao, "symbol") == 0) {
        sprintf(codigo, "%s: .space 4\n", id);
    } 
    else if (strcmp(operacao, "jump") == 0) {
        sprintf(codigo, "j %s\n", id);
    } 
    else if (strcmp(operacao, "assign") == 0) {
        sprintf(codigo, "la a0, %s\n", id);
        strcat(codigo, "lw t0, 0(sp)\n");
        strcat(codigo, "sw t0, (a0)\n");
        strcat(codigo, "addi sp, sp, 4\n");
    } 
    else if (strcmp(operacao, "check") == 0) {
        strcat(codigo, "lw t0, 0(sp)\n");
        strcat(codigo, "addi sp, sp, 4\n");
        sprintf(codigo, "beqz t0, %s\n", id);
    } 
    else if (strcmp(operacao, "label") == 0) {
        sprintf(codigo, "%s:\n", id);
    } 
    else if (strcmp(operacao, "read") == 0) {
        strcat(codigo, "li a7, 5\n");
        strcat(codigo, "ecall\n");
        strcat(codigo, "la a1, ");
        strcat(codigo, id);
        strcat(codigo, "\n");
        strcat(codigo, "sw a0, 0(a1)\n");
    } 
    else if (strcmp(operacao, "write") == 0) {
        strcat(codigo, "lw a0, 0(sp)\n");
        strcat(codigo, "li a7, 1\n");
        strcat(codigo, "ecall\n");
        strcat(codigo, "addi sp, sp, 4\n");
        strcat(codigo, "li a7, 11\n"); // Imprimir quebra de linha
        strcat(codigo, "li a0, 10\n");
        strcat(codigo, "ecall\n"); 
    } 
    else if (strcmp(operacao, "store_imm") == 0) {
        sprintf(codigo, "li t0, %s\n", id);
        strcat(codigo, "addi sp, sp, -4\n");
        strcat(codigo, "sw t0, 0(sp)\n");
    } 
    else if (strcmp(operacao, "store") == 0) {
        sprintf(codigo, "la t0, %s\n", id);
        strcat(codigo, "addi sp, sp, -4\n");
        strcat(codigo, "lw t0, 0(t0)\n");
        strcat(codigo, "sw t0, 0(sp)\n");
    } 
    else if (strcmp(operacao, "less") == 0) {
        strcat(codigo, "lw t0, 4(sp)\n");
        strcat(codigo, "lw t1, 0(sp)\n");
        strcat(codigo, "slt t0, t0, t1\n");
        strcat(codigo, "addi sp, sp, 4\n");
        strcat(codigo, "sw t0, 0(sp)\n");
    } 
    else if (strcmp(operacao, "equal") == 0) {
        strcat(codigo, "lw t0, 4(sp)\n");
        strcat(codigo, "lw t1, 0(sp)\n");
        strcat(codigo, "sub t0, t0, t1\n");
        strcat(codigo, "seqz t0, t0\n");
        strcat(codigo, "sw t0, 0(sp)\n");
    } 
    else if (strcmp(operacao, "greater") == 0) {
        strcat(codigo, "lw t0, 4(sp)\n");
        strcat(codigo, "lw t1, 0(sp)\n");
        strcat(codigo, "slt t0, t1, t0\n");
        strcat(codigo, "addi sp, sp, 4\n");
        strcat(codigo, "sw t0, 0(sp)\n");
    } 
    else if (strcmp(operacao, "add") == 0) {
        strcat(codigo, "lw t0, 4(sp)\n");
        strcat(codigo, "lw t1, 0(sp)\n");
        strcat(codigo, "add t0, t0, t1\n");
        strcat(codigo, "addi sp, sp, 4\n");
        strcat(codigo, "sw t0, 0(sp)\n");
    } 
    else if (strcmp(operacao, "sub") == 0) {
        strcat(codigo, "lw t0, 4(sp)\n");
        strcat(codigo, "lw t1, 0(sp)\n");
        strcat(codigo, "sub t0, t0, t1\n");
        strcat(codigo, "addi sp, sp, 4\n");
        strcat(codigo, "sw t0, 0(sp)\n");
    } 
    else if (strcmp(operacao, "mul") == 0) {
        strcat(codigo, "lw t0, 4(sp)\n");
        strcat(codigo, "lw t1, 0(sp)\n");
        strcat(codigo, "mul t0, t0, t1\n");
        strcat(codigo, "addi sp, sp, 4\n");
        strcat(codigo, "sw t0, 0(sp)\n");
    } 
    else if (strcmp(operacao, "div") == 0) {
        strcat(codigo, "lw t0, 4(sp)\n");
        strcat(codigo, "lw t1, 0(sp)\n");
        strcat(codigo, "div t0, t0, t1\n");
        strcat(codigo, "addi sp, sp, 4\n");
        strcat(codigo, "sw t0, 0(sp)\n");
    }
    
    // Armazenar o código no vetor
    gc->code[counter+=1] = codigo;
}