
.section .data
	
	A: .quad 0
	B: .quad 0

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
liberaMem:
iniciaAlocador:
	pushq %rbp
	movq %rsp, %rbp

    movq $12, %rax  
    movq $0, %rdi   
    syscall

    inc %rax
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
	 je fim 

	first_time:
	 #executa uma operação de memória para a primeira vez que essa função é utilizada
	 
/*	 
	movq 0(%rax), %rdx
	cmpq $1, %rdx
	 jne aqui

	aqui:

	aqui:
	 movq $1, 0(%rax)
	 movq %rbx, 8(%rax)
	 addq $16, %rax

	fim:
*/


	/*movq %rdx, %rdi								#adiciona o valor externo em rdi

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
    */
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
	/*movq $30, B
	pushq $B
	call alocaMem*/

	movq %rax, %rdi
	movq $60, %rax
	syscall

	

