#include "meuAlocador.h"
#include <stdio.h>
#include <string.h>
int main()
{
	char *a, *b, *c;
	iniciaAlocador();
	a = alocaMem(200);
	strcpy(a, "FODASE");

	printf("%s\n",a );
	
	//b = alocaMem(200);
	//printf("%s\n",a );

	return 0;
}