%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "parser.tab.h" /* os tokens */
#include "symtable.h" /* para definições de tokens e yylval */

#define YYDEBUG 1
%}

%union {
    char *id;
}

%token INT SKIP IF THEN ELSE FI WHILE DO END
%token <id> IDENT
%left '-' '+'
%left '*' '/'
%right '^'

%%

":="        { return (ASSGNOP); }
[0-9]+      { yylval.id = strdup(yytext); return INT; }
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
[a-zA-Z_][a-zA-Z0-9_]*   {
                yylval.id = strdup(yytext);
                return IDENT;
            }
[ \t\n]+    { /* Ignora espaços em branco e novas linhas */ }
.           { return yytext[0]; }

declarations : /* empty */
    | INTEGER id seq IDENTIFIER '.' { install($3); }
    ;
id seq : /* empty */
    | id seq IDENTIFIER ',' { install($2); }
    ;
command : SKIP
    | READ IDENTIFIER { context_check($2); }
    | IDENT ASSGNOP exp { context_check($2); }
exp : INT
    | IDENT { context_check($2); }
    ;

%%

int yywrap() {}