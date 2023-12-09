#ifndef SYMTABLE_H
#define SYMTABLE_H

struct symrec {
    char *name;
    struct symrec *next;
};
typedef struct symrec symrec;

extern symrec *symtable;

symrec *putsym(char *symname);
symrec *getsym(char *symname);
void install(char *symname);
void context_check(char *symname);

#endif