%{
    #include <stdio.h>
%}

/* floatsigned: -?{number}*\.{number}+([eE]{intsigned})? */
 
digit [0-9]
number {digit}+
intsigned -?{number}
floatsigned -?(({number}+([\.]|[\,]){number}*))
identifier [a-zA-Z_][a-zA-Z0-9_]*


/* rules section */
%%

[6-9][0-9]{9} {printf("Mobile number\n");}
{intsigned} {printf("Integer\n");}
{floatsigned} {printf("Float\n");}
{identifier} {printf("Identifier\n");}
.+ {printf("Invalid\n");}

%%

int yywrap();

int main() {
    yylex();

    return 0;
};

int yywrap(){
    return 1;
}