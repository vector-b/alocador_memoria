#include "meuAlocador.h"
#include <stdio.h>
#include <string.h>
int main()
{
	
	char *a, *b, *c, *d, *e;
	iniciaAlocador();
	
	a = alocaMem(5);
	strcpy(a, "VICTOR");

	b = alocaMem(75);
	strcpy(b, "GABRIEL");

	c = alocaMem(100);
	strcpy(c, "SOUZA");

	d = alocaMem(75);
	strcpy(d, "DE OLIVEIRA");

	e = alocaMem(50);
	strcpy(e, "BARBOSA");
	
	liberaMem(a);
	liberaMem(b);
	liberaMem(c);
	liberaMem(d);
	liberaMem(e);

	a = alocaMem(30);
	strcpy(a, "a");
	printf("%s\n",a );

	b = alocaMem(40);
	strcpy(b, "b");
	printf("%s\n",b );
	imprimeMapa();

	finalizaAlocador();

	return 0;
}