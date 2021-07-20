#include "meuAlocador.h"
int main()
{
	void *a;
	iniciaAlocador();
	a = alocaMem(10);
	finalizaAlocador();
	return 0;
}