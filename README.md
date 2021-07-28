# Alocador de Memória em Assembly
Este é um Alocador de Memória feito em assembly amd x86-64 com a variação de 64bits.<br>
Esse projeto foi desenvolvido para a matéria de Software Básico do Curso de BCC na UFPR.<br>
A ideia principal é construir um alocador e um gerenciador de memória simples.<br>

Neste repositório você poderá encontrar 3 branches:

V3 (default) - Possui a versão comum do projeto com 2 implementações extras:<br>
  -> Best-fit: Procura pelo menor espaço possível para alocação de um novo bloco<br>
  -> Aloca4k: Diminui o acesso a brk realizando alocações de 4096 bytes<br>
  
V2 - Possui a implementação comum do projeto com 1 implementação extra:<br>
  -> Best-fit: Procura pelo menor espaço possível para alocação de um novo bloco<br>

V1 - Possui a implementação simples de um alocador com gerenciador de memória<br>

Até o momento só existe uma quantidade razoavel de comentários na V3, futuramente posso adicionar nas outras versões.<br>
Pra quem tem curiosidade ou também cursa uma disciplina parecida, recomendo a leitura do livro **Programming from the ground up** de Jonathan Bartlett, onde o mesmo sugere uma forma de implementar um gerenciador de memória no Cap.9!<br>

Obrigado, até mais! <br>
![char](https://user-images.githubusercontent.com/56267233/127407894-1082dfbb-042d-497a-badb-6f426734a8f9.gif)

