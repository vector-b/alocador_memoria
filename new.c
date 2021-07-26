#include "meuAlocador.h" 

int main() {
  void *a, *b;
  iniciaAlocador();
  imprimeMapa();
  a=alocaMem(150);
  imprimeMapa();
  b=alocaMem(50);
  imprimeMapa();
  liberaMem(a);
  imprimeMapa();
  a=alocaMem(20);
  liberaMem(a);
  a=alocaMem(300);
  imprimeMapa();
  finalizaAlocador();

}
