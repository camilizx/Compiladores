file = bin

all: build run

run: 
	./a.out <programa2.lux

build: 
	flex scanner.l
	bison -d -t parser.y
	gcc lex.yy.c parser.tab.c symtable.c gencode.c