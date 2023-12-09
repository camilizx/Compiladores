%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "parser.tab.h" /* os tokens */
#include "Simple.tab.h" /* para definições de tokens e yylval */

#define YYDEBUG 1 /* Para depuração */

// Definições do módulo de símbolos
struct symrec {
    char *name;
    struct symrec *next;
};
typedef struct symrec symrec;

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

install(char *symname) {
    symrec *s;
    s = getsym(symname);
    if (s == 0)
        s = putsym(symname);
    else {
        errors++;
        printf("%s is already defined\n", symname);
    }
}

context check(char *symname) {
    if (getsym(symname) == 0)
        printf("%s is an undeclared identifier\n", symname);
}

%}

DIGIT [0-9]
ID [a-zA-Z_][a-zA-Z0-9_]*

%union { /* SEMANTIC RECORD */
    char *id; /* For returning identifiers */
}

%token INT SKIP IF THEN ELSE FI WHILE DO END
%token <id> IDENT /* Simple identifier */
%left '-' '+'
%left '*' '/'
%right '^'

%%

":="        { return (ASSGNOP); }
{DIGIT}+    { return (INT); }  
do          { return (DO); }
else        { return (ELSE); }
end         { return (END); }
fi          { return (FI); }
if          { return (IF); }
in          { return (IN); }
integer     { return (INTEGER); }
let         { return (LET); }
read        { return (READ); }
skip        { return (SKIP); }
then        { return (THEN); }
while       { return (WHILE); }
write       { return (WRITE); }
{ID}        { return IDENTIFIER; }
[ \t\n]+	{;}
.		    {return yytext[0];}

declarations : /* empty */
    | INTEGER id seq IDENTIFIER '.' { install( $3 ); }
    ;
id seq : /* empty */
    | id seq IDENTIFIER ',' { install( $2 ); }
    ;
command : SKIP
    | READ IDENTIFIER { context check( $2 ); }
    | IDENT ASSGNOP exp { context check( $2 ); }
exp : INT
    | IDENT { context check( $2 ); }

%%

int yywrap() {}