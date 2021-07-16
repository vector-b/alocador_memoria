# Makefile
all: program1 program2 program3

program1: pgma.c
    gcc -c pgma.c


program2: ass_malloc.s
    as ass_malloc.s -o malloc.o 

program3: 
	gcc pgma.o malloc.o -o full
