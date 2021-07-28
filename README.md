# Alocador de Memória em Assembly
Este é um Alocador de Memória feito em assembly amd x86-64 com a variação de 64bits
Esse projeto foi desenvolvido para a matéria de Software Básico do Curso de BCC na UFPR.
A ideia principal é construir um alocador e um gerenciador de memória simples.

Nesse repositório você poderá encontrar 3 branches:

V3 (default) - Possui a versão comum do projeto com 2 implementações extras:
  -> Best-fit: Procura pelo menor espaço possível para alocação de um novo bloco
  -> Aloca4k: Diminui o acesso a brk realizando alocações de 4096 bytes
  
V2 - Possui a implementação comum do projeto com 1 implementação extra:
  -> Best-fit: Procura pelo menor espaço possível para alocação de um novo bloco

V1 - Possui a implementação simples de um alocador com gerenciador de memória

Até o momento só existe uma quantidade razoavel de comentários na V3, futuramente posso adicionar nas outras versões.
Pra quem tem curiosidade ou também cursa uma disciplina parecida, recomendo a leitura do livro **Programming from the ground up** de Jonathan Bartlett, onde o mesmo sugere uma forma de implementar um gerenciador de memória no Cap.9!

Obrigado, até mais! <br>
![char](https://user-images.githubusercontent.com/56267233/127407894-1082dfbb-042d-497a-badb-6f426734a8f9.gif)

