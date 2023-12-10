%{
    #include <stdio.h>
    #include <string.h>
    #include "parser.tab.h" /* the tokens */
%}

DIGIT [0-9]
ID [a-zA-Z_][a-zA-Z0-9_]*

%%

":="        { return (ASSGNOP); }
{DIGIT}+    { return (NUMBER); }  
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
{ID}        { yylval.id = (char *) strdup(yytext); return IDENTIFIER; }
[ \t\n]+	{;}
.		    {return yytext[0];}

%%

/* recomendavel declarar sempre
   funcao yywrap () */
int yywrap() {}