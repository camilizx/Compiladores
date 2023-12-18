#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char* arquivoSaida(const char *nome_do_arquivo_original) {
    // Copiar o nome do arquivo original para evitar modificar o original
    char *nome_do_arquivo_modificado = strdup(nome_do_arquivo_original);

    // Remover a extensão do nome do arquivo
    char *ponto = strrchr(nome_do_arquivo_modificado, '.');
    if (ponto != NULL) {
        *ponto = '\0';
    }

    // Adicionar a nova extensão ".asm"
    strcat(nome_do_arquivo_modificado, ".asm");

    return nome_do_arquivo_modificado;
}