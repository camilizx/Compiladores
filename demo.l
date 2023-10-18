%{
    #include <stdio.h>
%}

DIGITO [0-9]
INT {DIGITO}+
INTSIGNED -?{INT}
FLOATSIGNED -?(({INT}+([\.]|[\,]){INT}*))
VARIAVEL [a-zA-Z][a-zA-Z0-9\_]* 

%%

{INTSIGNED} {printf("Isso é um número inteiro!\n");}
{FLOATSIGNED} {printf("Isso é um ponto flutuante!\n");}
{VARIAVEL} {printf("Isso é um identificador!\n");}

[[:space:]]+ ; //caso encontre espaços, nao colocar nenhum espaço na saida
[[:^space:]]+ ; //caso encontre um ou mais caracteres que não seja espaço, não faz nada tbm

%%

int yywrap();

int main() {
    yylex();

    return 0;
};

int yywrap(){
    return 1;
}