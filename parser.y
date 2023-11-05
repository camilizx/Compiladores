%{
    #include <stdio.h>
%}

%token LET INTEGER IN
%token INT SKIP IF THEN ELSE FI END WHILE DO READ WRITE ASSGNOP
%token IDENTIFIER
%left '-' '+'
%left '*' '/'
%right '^'

%%

input:
|   input line
;

line:     '\n'			{;}
| program '\n'  { printf ("Programa sintaticamente correto!\n"); }
;

program: LET declarations IN commands END ;

declarations: /* empty */
|   INTEGER id_seq IDENTIFIER '.' 
;

id_seq: /* empty */
|   id_seq IDENTIFIER ',' 
;

commands: /* empty */
|   commands command ';'
;

command: SKIP
|   READ IDENTIFIER 
|   WRITE exp
|   IDENTIFIER ASSGNOP exp 
|   IF exp THEN commands ELSE commands FI
|   WHILE exp DO commands END
;

exp: INT
|   IDENTIFIER
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
    yyparse();

    return 0;
}

int yyerror(char* s) { /* called by yyparse on error */
    printf("ERROR: %s\n", s);

    return 0;
}