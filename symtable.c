#include "symtable.h"

symrec *identifier;
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