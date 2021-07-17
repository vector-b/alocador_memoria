#include "meuAlocador.h" 
#include <stdio.h>
int main(){
  long int *a,*b;
  //printf("Inicializando ALocador\n");
  iniciaAlocador();
  //printf("Alocando Exemplo\n");
  a=alocaMem(100);
  *a = 1;
  liberaMem(a);
  printf("%ld\n",*a );
  //printf("Variavel na memoria: %ld\n",*a );
  //printf("Finalizando Alocador\n");
  finalizaAlocador();
}
