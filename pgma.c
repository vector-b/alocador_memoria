#include "meuAlocador.h" 
#include <stdio.h>
#include <string.h>
int main(){
  void *a,*b;
  iniciaAlocador ();
  a = alocaMem (10) ;
  //c = alocaMem (150);
  //imprimeMapa();
  strcpy (a, " Preenchimento de Vetor ");
  //strcpy (b, a);
  liberaMem (a);
  //liberaMem (b);
  a = alocaMem(50);
  //liberaMem(a);
  finalizaAlocador();
}
