#include "meuAlocador.h"
#include <stdio.h>
#include <string.h>
int main()
{
	char *a, *b, *c;
	iniciaAlocador();
	
	a = alocaMem(100);
	strcpy(a, "JESUS");

	b = alocaMem(200);
	strcpy(b, "EU TE AMO");

	c = alocaMem(100);
	strcpy(c, "AMO");
	
	printaval();
	imprimeMapa();
	printf("%s\n",a );
	printf("%s\n",b );
	printf("%s\n",c );
	printaval();
	
	liberaMem(a);
	liberaMem(b);
	liberaMem(c);

	finalizaAlocador();

	
	
	//printf("%s\n",a );

	return 0;
}