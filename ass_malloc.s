
.section .data
	topoInicialHeap: .quad 0
	A: .quad 0
	B: .quad 0
	.local brk_atual
	.comm brk_atual, 8, 8
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
	movq %rsp, %rbp
	movq 16(%rbp), %rcx
	movq (%rcx), %rdx
	movq %rdx, %rdi
    movq brk_atual, %rdx 
    addq %rdx, %rdi 
    movq $12, %rax  
    syscall         
    movq %rax, brk_atual
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
	movq $10, A
	pushq $A
	call alocaMem
	movq $27, B
	pushq $B
	call alocaMem
	movq brk_atual, %rdi
	movq $60, %rax
	syscall

	

