%{
    #include <stdlib.h>         /* For malloc */
    #include <string.h>         /* For string manipulation */
    #include <stdio.h>          /* For error messages */
    #include "symtable.h"       /* Symbol Table */
    #include "gencode.h"        /* Code Generation */
    #include "stack.h"          /* Stack */
    #define YYDEBUG 1           /* For Debugging */

    int yylex();
    int yyerror(char* s);
    int errors = 0;
    int while_counter = 0;
    int if_counter = 0;

    /* Criar uma instância de Stack */
    struct Stack context;

    /* Criar uma instância de GC */ 
    struct GC gc;

    // Função para definir o contexto
    void set_context(struct Stack *context, char f) {
        char s[MAX_STRING_SIZE] = "";

        switch (f) {
            case 'w':
                snprintf(s, sizeof(s), "while_%d", while_counter++);
                break;
            case 'i':
                snprintf(s, sizeof(s), "if_%d", if_counter++);
                break;
        }
       
        gen_code(&gc, "label", s);
        push(context, s);
    }

    // Função para encerrar o contexto
    void end_context(struct Stack *context, char f) {
        char s[MAX_STRING_SIZE*2] = "";
        
        snprintf(s, MAX_STRING_SIZE*2, "end_%s", top(context));

        if (f == 'w') {
            gen_code(&gc, "jump", top(context));
        }

        gen_code(&gc, "label", s);
        pop(context);
    }

    /* Install identifier & check if previously defined. */
    void install(char *symname) {
        symrec *s;
        s = getsym(symname);
        if (s == 0) {
            s = putsym(symname);
            gen_code(&gc, "symbol", symname);
        }
        else {
            errors++;
            printf("%s is already defined\n", symname);
        }
    }

    /* If identifier is defined*/
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
|   WHILE { set_context(&context, 'w'); } exp DO { char s[MAX_STRING_SIZE*2] = ""; snprintf(s, MAX_STRING_SIZE*2, "end_%s", top(&context)); gen_code(&gc, "check", s); } commands END { end_context(&context, 'w'); }
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

    // Inicializar a pilha de contexto
    init_stack(&context);

    yyparse();
    printf("Parse Completed\n");

    if (errors == 0) {
        // Imprimir códigos
        for (int i = 0; i < 40; i++) {
            printf("%s", gc.code[i]);
        }
    }
    
    return 0;
}

int yyerror(char* s) { /* called by yyparse on error */
    printf("ERROR: %s\n", s);

    return 0;
}