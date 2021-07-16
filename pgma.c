#include "meuAlocador.h" 
#include <stdio.h>
int main(){
  long int *a;
  printf("Inicializando ALocador\n");
  iniciaAlocador();
  printf("Alocando Exemplo\n");
  a=alocaMem(8);
  *a = 1;
  printf("Variavel na memoria: %ld\n",*a );
  printf("Finalizando Alocador\n");
  finalizaAlocador();
}
