# Compiladores

Para testar o programa utilize os seguintes comandos:

1 - flex scanner.l

2 - bison -d -t parser.y

3 - gcc lex.yy.c parser.tab.c (compila e gera o arquivo a.out)

4 - ./a.out <programa.txt (rodar o programa com o arquivo desejado)
