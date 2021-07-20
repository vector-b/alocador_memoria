AS = as malloc.s -o malloc.o
all:
	$(AS)
	ld malloc.o -o  run -dynamic-linker /lib/x86_64-linux-gnu/ld-linux-x86-64.so.2 /usr/lib/x86_64-linux-gnu/crt1.o /usr/lib/x86_64-linux-gnu/crti.o /usr/lib/x86_64-linux-gnu/crtn.o -lc

home:
	$(AS)	
	ld malloc.o -o run -dynamic-linker /lib/ld-linux-x86-64.so.2 /usr/lib/crt1.o /usr/lib/crti.o /usr/lib/crtn.o -lc

c:
	as malloc.s -o malloc.a
	gcc  prog.c malloc.a -o run -no-pie
clean:
	rm *.o
	rm run