#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symtable.h"

symrec *symtable = (symrec *)0;

symrec *putsym(char *symname) {
    symrec *ptr;
    ptr = (symrec *)malloc(sizeof(symrec));
    ptr->name = (char *)malloc(strlen(symname) + 1);
    strcpy(ptr->name, symname);
    ptr->next = (struct symrec *)symtable;
    symtable = ptr;
    return ptr;
}

symrec *getsym(char *symname) {
    symrec *ptr;
    for (ptr = symtable; ptr != (symrec *)0; ptr = (symrec *)ptr->next)
        if (strcmp(ptr->name, symname) == 0)
            return ptr;
    return 0;
}

void install(char *symname) {
    symrec *s;
    s = getsym(symname);
    if (s == 0)
        s = putsym(symname);
    else {
        errors++;
        printf("%s is already defined\n", symname);
    }
}

void context_check(char *symname) {
    if (getsym(symname) == 0)
        printf("%s is an undeclared identifier\n", symname);
}