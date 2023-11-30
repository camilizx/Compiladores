# Compiladores

Compilador implementado utilizando flex e bison

# Instruções

Clone este repositório. Você precisa que o flex, bison, e gcc já estejam instalados na sua máquina.

Para instalar o flex e bison: 

```
sudo apt-get update 
sudo apt-get upgrade 
sudo apt-get install flex bison

which flex  /*Para verificar que o flex esteja instalado*/
which bison /*Para verificar que o bison esteja instalado*/
```

## Para testar o programa utilize os seguintes comandos:

1. flex scanner.l
2. bison -d -t parser.y
3. gcc lex.yy.c parser.tab.c (compila e gera o arquivo a.out)
4. ./a.out <programa.txt (rodar o programa com o arquivo desejado)
