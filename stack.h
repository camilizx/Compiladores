#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define MAX_STRING_SIZE 100

// Estrutura para representar a pilha
struct Stack {
    char strings[MAX_STRING_SIZE][MAX_STRING_SIZE];
    int top;
};

// Função para inicializar a pilha
void init_stack(struct Stack *stack) {
    stack->top = -1;
}

// Função para empilhar uma string na pilha
void push(struct Stack *stack, const char *str) {
    if (stack->top < MAX_STRING_SIZE - 1) {
        stack->top++;
        strncpy(stack->strings[stack->top], str, MAX_STRING_SIZE - 1);
        stack->strings[stack->top][MAX_STRING_SIZE - 1] = '\0';  // Garante que a string seja terminada corretamente
    } else {
        printf("Erro: pilha cheia\n");
        exit(EXIT_FAILURE);
    }
}

// Função para desempilhar uma string da pilha
void pop(struct Stack *stack) {
    if (stack->top >= 0) {
        stack->top--;
    } else {
        printf("Erro: pilha vazia\n");
        exit(EXIT_FAILURE);
    }
}

// Função para retornar o topo da pilha
const char *top(const struct Stack *stack) {
    if (stack->top >= 0) {
        return stack->strings[stack->top];
    } else {
        printf("Erro: pilha vazia\n");
        exit(EXIT_FAILURE);
    }
}