%{
    #include <stdlib.h> /* For malloc in symbol table */
    #include <string.h> /* For strcmp in symbol table */
    #include <stdio.h> /* For error messages */

    int errors = 0;

    //TODO: Implementar tabela de símbolos
    typedef struct symrec {
        char *name;             /* name of symbol */
        int offset;             /* data offset    */
        struct symrec *next;    /* link field     */
    } symrec;

    symrec *symtable = (symrec *)0;
    symrec *putsym(char *symname);
    symrec *getsym(char *symname);

    symrec *putsym(char *symname) {
        symrec *ptr;
        ptr = (symrec *)malloc(sizeof(symrec));
        ptr->name = (char *)malloc(strlen(symname) + 1);
        strcpy(ptr->name, symname);
        //ptr->offset = data_location(); adiciona essa linha quando faz o modulo de geração de código
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
    //-------------------------------------------------------------

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
%}

%union { 
    char *id; /* For returning identifiers */
}

%start program
%token LET INTEGER IN
%token NUMBER SKIP IF THEN ELSE FI END WHILE DO READ WRITE ASSGNOP
%token <id> IDENTIFIER

%left '-' '+'
%left '*' '/'
%right '^'

%%

program: LET declarations IN commands END  { printf ("Programa sintaticamente correto!\n"); }
;

declarations: /* empty */
|   INTEGER id_seq IDENTIFIER '.'               { install( $3 ); }
;

id_seq: /* empty */
|   id_seq IDENTIFIER ','                       { install( $2 );}
;

commands: /* empty */
|   commands command ';'
;

command: SKIP                                   
|   READ IDENTIFIER                             { context_check( $2 ); }
|   WRITE exp
|   IDENTIFIER ASSGNOP exp                      { context_check( $1 );}
|   IF exp THEN commands ELSE commands FI
|   WHILE exp DO commands END
;

exp: NUMBER
|   IDENTIFIER                                  { context_check( $1 ); }
|   exp '<' exp
|   exp '=' exp
|   exp '>' exp
|   exp '+' exp
|   exp '-' exp
|   exp '*' exp
|   exp '/' exp
|   exp '^' exp
|   '(' exp ')'
;

%%

int main() {

    /*
     *  # if YYDEBUG == 1
     *  extern int yydebug;
     *  yydebug = 1;
     *  # endif
     */

    yyparse();
    
    return 0;
}

int yyerror(char* s) { /* called by yyparse on error */
    printf("ERROR: %s\n", s);

    return 0;
}