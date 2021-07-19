#include "meuAlocador.h" 
#include <stdio.h>
#include <string.h>
int main(){
  void *a,*b,*c;
  iniciaAlocador ();
  a = alocaMem (200) ;
  b = alocaMem (200) ;
  c = alocaMem (200) ;
  //imprimeMapa();
  //strcpy (a, " Preenchimento de Vetor ");
  //strcpy (b, a);
  //liberaMem (a);
  //liberaMem (b);
  //a = alocaMem(50);
  //liberaMem(a);
  finalizaAlocador();
}
