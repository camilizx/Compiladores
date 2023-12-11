%{
    #include <stdlib.h> /* For malloc in symbol table */
    #include <string.h> /* For strcmp in symbol table */
    #include <stdio.h> /* For error messages */
    #include "symtable.h"

    int errors = 0;

    //TODO: Modulo de geração de código
    /*
    int data_offset = 0;
    int data_location() { return data_offset++; }

    int code_offset = 0;
    int reserve_loc() { return code_offset++; }
    int gen_label() { return code_offset; }

    void gen_code( enum code_ops operation, int arg ) { 
        code[code_offset].op = operation;
        code[code_offset++].arg = arg;
    }

    void back_patch( int addr, enum code_ops operation, int arg ) {
        code[addr].op = operation;
        code[addr].arg = arg;
    }
    */

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