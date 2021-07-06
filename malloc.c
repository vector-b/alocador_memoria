#include <string.h>
#include <stdio.h>
void *a;
int main ( int argc , char ** argv ){
	long int y;
	long int x;
	__asm__("movq $10, -8(%rbp)");
	__asm__("movq $15, -16(%rbp)");

	printf("a=%ld\n",x );
	return(0);
	/*
 void *b;
 iniciaAlocador ();
 a = alocaMem (100) ;
 b = alocaMem (200) ;
 strcpy (a, " Preenchimento de Vetor ");
 strcpy (b, a);
 liberaMem (a);
 liberaMem (b);
 a = alocaMem (50) ;
 liberaMem (a);
 finalizaAlocador ();*/
}