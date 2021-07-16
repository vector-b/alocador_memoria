
.section .data
	
	A: .quad 0
	B: .quad 0
	

	topoInicialHeap: .quad 0
	#.local brk_atual
	.comm brk_atual, 8

	.equ NOT_OK, 0 
	.equ OK, 1 

.section .text 
.globl iniciaAlocador , finalizaAlocador , alocaMem , show , liberaMem , imprimeMapa , buscador , _start
finalizaAlocador:
	pushq %rbp
	movq %rsp, %rbp
	movq topoInicialHeap, %rdi
	movq $12, %rax
	syscall
	popq %rbp
	ret
liberaMem:
iniciaAlocador:
    movq $12, %rax  
    movq $0, %rdi   
    syscall
    movq %rax, brk_atual
    movq %rax, topoInicialHeap
    ret

alocaMem:
	pushq %rbp
	movq %rsp, %rbp								#altera o RA


	#faz a busca

	movq 16(%rbp), %rcx							#passa o novo valor desejado
	movq (%rcx), %rdx
	movq %rdx, %rdi								#adiciona o valor externo em rdi

	addq $16, %rdi								#soma 16 bytes ao valor alocado - 8 pra cada long int da estrutura

    movq brk_atual, %rdx 						#passa o atual index de brk

    addq %rdx, %rdi 							#syscall brk
    movq $12, %rax  
    syscall

    #movq   (%rax), %rdi 						#load the pointer from memory, if you didn't already have it in a register
    #movq   $1, %rdi 
	#mov   byte [rdi], 'A'            			#a char at it's first byte
	#mov   [rdi+1], ecx               			#a 32-bit value in the last 4 bytes.

    movq %rax, brk_atual						#move o valor pra variavel atual de brk

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
_start:
	call iniciaAlocador
	movq $30, B
	pushq $B
	call alocaMem
	movq brk_atual, %rdi
	movq $60, %rax
	syscall

	

