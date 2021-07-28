all:
	as malloc.s -o malloc.a
	gcc  avalia.c malloc.a -o run -no-pie -g
clean:
	rm *.o
	rm run