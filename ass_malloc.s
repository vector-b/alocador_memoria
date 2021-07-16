.section .data
	topoInicialHeap: .quad 0
	A: .quad 0
	B: .quad 0
.section .text 
.globl iniciaAlocador,finalizaAlocador,alocaMem, show, liberaMem,imprimeMapa,buscador, _start
iniciaAlocador:
	pushq %rbp			
	movq %rsp, %rbp
	movq $12, %rax
	movq $0, %rdi
	movq %rdi, topoInicialHeap
	syscall							#executa a syscall da brk(), retorna o valor do topo em rax
	popq %rbp
	ret
finalizaAlocador:
	pushq %rbp
	movq %rsp, %rbp
	movq topoInicialHeap, %rdi
	movq $12, %rax
	syscall
	popq %rbp
	ret
alocaMem:
	pushq %rbp
	movq %rsp, %rbp

	movq 16(%rbp), %rbx				#rbx recebe valor de bytes do malloc
	#busca pelo espaço apropriado
	addq $16, %rbx
	movq %rbx, %rdi			 		#soma o topo + deslocamento solicitado
	movq $12, %rax					#invoca a brk com o novo valor de alocação recebido por 16(%rbp)
	syscall

	movq 16(%rbp), %rax
	popq %rbp
	ret
show:
	pushq %rbp
	movq %rsp, %rbp

	movq $0, %rdi
	movq $12, %rax
	syscall

	popq %rbp
	ret
liberaMem:
imprimeMapa:
buscador:
	call iniciaAlocador
	pushq %rbp
	movq %rsp, %rbp

	movq 16(%rbp), %rbx
	movq (%rbx), %rcx
	
	movq $0, %rdi
	movq $12, %rax
	syscall 

	movq %rax, %rsi	#backup do ponteiro


	movq $0, %rdx
	while:
		cmpq $1, %rdx
		je fim_while
						#inicio do while
	fim_while:
	#a terminar

	#movq $0, %rdi
	#movq $12, %rax
	#syscall

	#movq %rax, %rcx
	#movq %rcx, (%rbx) 

	popq %rbp
	ret


