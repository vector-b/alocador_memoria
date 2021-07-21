.section .data	
	  topoHeap  : .quad 0
	  inicioHeap : .quad 0
	  str0	 : .string "Inicio: %ld Topo: %ld \n" 
	  str1	 : .string "Disp: %ld  Tamanho: %ld \n" 
	  str2	 : .string "Saida cursed: %ld \n"
	  str3	 : .string "Valor atual: %ld \n"
			A: .long 0 
	.equ NOT_OK, 1 
	.equ OK, 0 

.section .text 
.globl iniciaAlocador, alocaMem, main, finalizaAlocador, liberaMem, imprimeMapa, printaval

printaval:
	pushq %rbp
	movq %rsp, %rbp

	mov $str0, %rdi
	movq inicioHeap, %rsi
	movq topoHeap, %rdx
	call printf

	popq %rbp
	ret 	

iniciaAlocador:
	pushq %rbp	
	movq %rsp, %rbp

	movq $12, %rax
	movq $0, %rdi
	syscall

	#inc  %rax
	movq %rax, inicioHeap
	movq %rax, topoHeap

	popq %rbp
	ret

alocaMem:
	pushq %rbp
	movq %rsp, %rbp
	subq $0, %rsp

	movq %rdi, %rbx


	mov $str3, %rdi
	movq %rbx, %rsi
	call printf

	movq inicioHeap, %rcx
	movq topoHeap  , %rdx

	check:
		cmpq %rcx, %rdx
		je aloca

	compara:
		movq 0(%rcx), %r12
		movq 8(%rcx), %r13


		cmpq $0, %r12
		jne proximo_bloco

		cmpq (%rbx), %r13
	    jle proximo_bloco

	aloca_aqui:
		movq $1, 0(%rcx)
		addq $16, %rcx
		movq %rcx, %rax
		jmp saida

	proximo_bloco:
		addq %r13, %rcx
		addq  $16, %rcx
		jmp check
	
	aloca:
		#movq , %r11		#aux
		movq %rbx, %r10
		
		movq %r10, %r11
		addq  $16, %r11
		addq topoHeap, %r11

		
		movq %r11, topoHeap

		movq $12,  %rax
		movq %r11, %rdi
		syscall

		movq %rax, %rdx
		subq %r10, %rdx
		subq $16,  %rdx

		movq   $1, (%rdx)
		addq   $8,  %rdx
		movq %r10, (%rdx)
		addq   $8,  %rdx

		movq %rdx, %rax	

	saida:
		popq %rbp
		ret

finalizaAlocador:
	pushq %rbp
	movq %rsp, %rbp
	movq inicioHeap, %rdi
	movq $12, %rax
	syscall
	popq %rbp
	ret

liberaMem:
	pushq %rbp
	movq %rsp, %rbp

	movq %rdi, %rcx

	subq $16, %rcx
	movq $OK, 0(%rcx)

	popq %rbp
	ret

imprimeMapa:
	pushq %rbp
	movq %rsp, %rbp

	movq inicioHeap, %r13
	movq topoHeap  , %r14

	inicio_while:
		cmpq %r13, %r14
		je fim_while

		mov $str1, %rdi
		movq 0(%r13), %rsi
		movq 8(%r13), %rdx
		call printf

		movq 8(%r13), %r15

		addq %r15, %r13
		addq $16, %r13
		jmp inicio_while

	fim_while:



	popq %rbp
	ret

/*
main:
	call iniciaAlocador

	movq $24, A
	pushq $A
	call alocaMem

	movq $24, A
	pushq $A
	call alocaMem

	movq topoHeap, %rdi
	movq $60, %rax
	syscall
*/