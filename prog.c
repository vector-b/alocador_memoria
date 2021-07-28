#include "meuAlocador.h"
#include <stdio.h>
#include <string.h>
int main()
{
	
	char *a, *b, *c, *d, *e;
	iniciaAlocador();
	
	a = alocaMem(400);
	strcpy(a, "VICTOR");

	b = alocaMem(500);
	strcpy(b, "GABRIEL");

	
	liberaMem(a);
	liberaMem(b);


	a = alocaMem(30);
	strcpy(a, "a");
	printf("%s\n",a );


	finalizaAlocador();

	return 0;
}