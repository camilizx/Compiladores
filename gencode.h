#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define MAX_CODE_LENGTH 100

struct GC {
    char* code[MAX_CODE_LENGTH];
};

void gen_code(struct GC* gc, const char* operacao, const char* id);
void init_code(struct GC* gc);
