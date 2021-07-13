.section .data
	A: .quad 0
	B: .quad 0
.section .text 
.globl iniciaAlocador,finalizaAlocador,alocaMem,liberaMem,imprimeMapa, _start
iniciaAlocador:
	pushq %rbp			
	movq %rsp, %rbp
	movq $12, %rax
	movq $0, %rdi
	syscall							#executa a syscall da brk(), retorna o valor do topo em rax


	popq %rbp
	ret
finalizaAlocador:
alocaMem:
	pushq %rbp
	movq %rsp, %rbp

	movq 16(%rbp), %rbx				#rax recebe valor de bytes do malloc


	addq %rax, %rbx
	movq %rbx, %rdi			 		#soma o topo + deslocamento solicitado
	movq $12, %rax					#invoca a brk com o novo valor de alocação recebido por 16(%rbp)
	syscall
	
	popq %rbp
	ret
liberaMem:
imprimeMapa:
_start:
	call iniciaAlocador				#inicia alocador - ainda n faz nada
	
	movq $24, A
	pushq A
	call alocaMem					#executa alocaMem, resultado em rax
	
	movq $48, B
	pushq B
	call alocaMem

	movq %rax, %rbx
	movq $60, %rax
	movq %rbx, %rdi
	syscall

