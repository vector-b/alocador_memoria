
.section .data
	
	A: .quad 0
	B: .quad 0
	C: .quad 0
	#.local brk_atual
	.comm brk_atual, 8
	topo_heap: .long 0

	.equ VN, 0
	.equ NOT_OK, 1 
	.equ OK, 0 

.section .text 
.globl iniciaAlocador , finalizaAlocador , alocaMem , show , liberaMem , imprimeMapa , buscador , _start
finalizaAlocador:
	pushq %rbp
	movq %rsp, %rbp
	movq topo_heap, %rdi
	movq $12, %rax
	syscall
	popq %rbp
	ret

iniciaAlocador:
	pushq %rbp
	movq %rsp, %rbp

    movq $12, %rax  
    movq $0, %rdi   
    syscall

    #inc %rax
    movq %rax, brk_atual
    movq %rax, topo_heap

    movq %rbp, %rsp
    popq %rbp
    ret
alocaMem:
	pushq %rbp
	movq %rsp, %rbp								#altera o RA

	movq 16(%rbp), %rcx							#passa o novo valor desejado
	#movq (%rcx), %rdx

	movq topo_heap, %rax
	movq brk_atual, %rbx

	busca_entrada:
	 cmpq %rax, %rbx
	 je nem

	#hora de checar se o primeiro espaço esta disponivel
	movq 0(%rax), %rdx
	movq 8(%rax), %rsi

	cmpq $OK, %rdx
	jne pesquisa
	cmpq (%rcx), %rsi  #RCX <= RSI
	jl pesquisa

	aqui:
	 jmp nem

	 jmp saida
	pesquisa:
	 addq $16, %rax
	 addq %rsi, %rax

	 #movq %rdx, %rax
	 #jmp busca_entrada
	 #movq $66, brk_atual 
	 jmp busca_entrada
	nem:		#sigla pra not enough memory
	 #executa uma operação de memória para a primeira vez que essa função é utilizada
	 movq (%rcx), %rdx
	 addq $16, %rbx
	 addq %rdx, %rbx

	 pushq %rax

	 movq $12, %rax
	 movq %rbx, %rdi
	 syscall

	 popq %rax

	 movq $NOT_OK, 0(%rax)
	 movq %rdx, 8(%rax)
	 addq $16, %rax

	 movq %rbx, brk_atual

	 jmp saida
	 

    saida:
     popq %rbp 
     ret
liberaMem:
	pushq %rbp
	movq %rsp, %rbp
	movq 16(%rbp), %rax
	subq $16, %rax
	movq $OK, 0(%rax)
	popq %rbp
	ret
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
/*_start:
	call iniciaAlocador
	movq $24, B
	pushq $B
	call alocaMem

	pushq %rax
	call liberaMem

	movq %rax, %rdi
	movq $60, %rax
	syscall*/

	

