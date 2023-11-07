%{
    #include <stdio.h>
    #include <string.h>
    #include "parser.tab.h" /* the tokens */
%}

DIGIT [0-9]
ID [a-zA-Z_][a-zA-Z0-9_]*

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
.|\n		{return yytext[0];}

%%

int yywrap() {}