%{
    #include <stdio.h>
    #include <string.h>
    #include <stdlib.h>
    #include "parser.tab.h" /* the tokens */
    #include "Simple.tab.h" /* for token definitions and yylval */

    #define YYDEBUG 1 /* For debugging */
    install ( char *sym name )
    { symrec *s;
    s = getsym (sym name);
    if (s == 0)
    s = putsym (sym name);
    else { errors++;
    printf( ”%s is already defined\n”, sym name ); } }
    context check( char *sym name )
    { if ( getsym( sym name ) == 0 )
    printf( ”%s is an undeclared identifier\n”, sym name ); }
%}

DIGIT [0-9]
ID [a-zA-Z_][a-zA-Z0-9_]*

%union { /* SEMANTIC RECORD */
char *id; /* For returning identifiers */}
%token INT SKIP IF THEN ELSE FI WHILE DO END
%token <id> IDENT /* Simple identifier */
%left ’-’ ’+’
%left ’*’ ’/’
%right ’ˆ’


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
| INTEGER id seq IDENTIFIER ’.’ { install( $3 ); }
;
id seq : /* empty */
| id seq IDENTIFIER ’,’ { install( $2 ); }
;
command : SKIP
| READ IDENTIFIER { context check( $2 ); }
| IDENT ASSGNOP exp { context check( $2 ); }
exp : INT
| IDENT { context check( $2 ); }

%%

int yywrap() {}