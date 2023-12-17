%{
    #include <stdlib.h>         /* For malloc in symbol table */
    #include <string.h>         /* For strcmp in symbol table */
    #include <stdio.h>          /* For error messages */
    #include "symtable.h"       /* Symbol Table */
    #include "gencode.h"        /* Code Generation */
    //#include "stackmachine.h"   /* Stack Machine */
    #define YYDEBUG 1           /* For Debugging */

    int errors = 0;
    int yylex();
    int yyerror(char* s);

    // Criar uma instância de GC
    struct GC gc;

    /* Install identifier & check if previously defined. */
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

    /* If identifier is defined, generate code */
    void context_check(char *symname) {
        if (getsym(symname) == 0)
            printf("%s is an undeclared identifier\n", symname);
    }
%}

%union { 
    char *id;   /* For returning identifiers */
    int intval; /* For returning integers */
}

/* Tokens */
%start program
%token <id> IDENTIFIER
%token <intval> NUMBER
%token IF WHILE
%token LET INTEGER IN
%token SKIP THEN ELSE FI END DO READ WRITE ASSGNOP

/* Precedencia dos operadores */
%left '-' '+'
%left '*' '/'
%right '^'

%%

program: LET { gen_code(&gc, "data", ""); }
            declarations
         IN  { gen_code(&gc, "text", "");}
            commands 
         END { gen_code(&gc, "end", ""); }
;

declarations: /* empty */
|   INTEGER id_seq IDENTIFIER '.'               { install( $3 ); }
;

id_seq: /* empty */
|   id_seq IDENTIFIER ','                       { install( $2 ); }
;

commands: /* empty */
|   commands command ';'
;

command: SKIP                                   
|   READ IDENTIFIER                             { context_check( $2 ); gen_code(&gc, "read", $2); }
|   WRITE exp                                   { gen_code(&gc, "write", ""); }
|   IDENTIFIER ASSGNOP exp                      { context_check( $1 ); gen_code(&gc, "assign", $1); }
|   IF exp THEN commands ELSE commands FI
|   WHILE exp DO commands END
;
exp: NUMBER                                     { char num_str[20]; // Tamanho arbitrário, ajuste conforme necessário
                                                  sprintf(num_str, "%d", $1);
                                                  gen_code(&gc, "store_imm", num_str); }
|   IDENTIFIER                                  { context_check( $1 ); gen_code(&gc, "store", $1); }
|   exp '<' exp                                 { gen_code(&gc, "less", ""); }
|   exp '=' exp                                 { gen_code(&gc, "equal", "");}
|   exp '>' exp                                 { gen_code(&gc, "greater", ""); }
|   exp '+' exp                                 { gen_code(&gc, "add", ""); }
|   exp '-' exp                                 { gen_code(&gc, "sub", "");}
|   exp '*' exp                                 { gen_code(&gc, "mul", ""); }
|   exp '/' exp                                 { gen_code(&gc, "div", ""); }
|   exp '^' exp
|   '(' exp ')'
;

%%

int main( int argc, char *argv[] ) {
    
    extern FILE *yyin;
    ++argv; --argc;
    yyin = fopen( argv[0], "r" );
    /*yydebug = 1;*/
    errors = 0;

    // Inicializar o vetor de códigos com NULL
    init_code(&gc);
    yyparse();
    printf("Parse Completed\n");

    if (errors == 0) {
        // Imprimir códigos
        for (int i = 0; i < MAX_CODE_LENGTH; i++) {
            printf("%2d: %s\n", i + 1, gc.code[i]);
        }
    }
    
    return 0;
}

int yyerror(char* s) { /* called by yyparse on error */
    printf("ERROR: %s\n", s);

    return 0;
}