#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct symrec {
    char *name;             /* name of symbol */
    int offset;             /* data offset    */
    struct symrec *next;    /* link field     */
} symrec;

symrec *putsym(char *symname);
symrec *getsym(char *symname);