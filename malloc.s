.section .data	
	  topoHeap  : .quad 0
	  inicioHeap : .quad 0
	  str0	 : .string "Início da Heap: %ld topoHeap da Heap: %ld \n" 
	  str1	 : .string "topoHeap da Heap: %ld \n" 
	  str2	 : .string "Saida cursed: %ld \n"
			A: .long 0 
	.equ NOT_OK, 1 
	.equ OK, 0 

.section .text 
.globl iniciaAlocador, alocaMem, main

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

	movq 16(%rbp), %rbx

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
		jmp saida

	proximo_bloco:
		addq %r13, %rcx
		addq  $16, %rcx
		jmp check
	
	aloca:
		movq (%rbx), %r10		#aux

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

	movq 16(%rbp), %rax
	subq $16, %rax
	movq $OK, 0(%rax)

	popq %rbp
	ret

imprimeMapa:
	pushq %rbp
	movq %rsp, %rbp

	movq inicioHeap, %rax
	movq topoHeap  , %rbx

	movq %rax, %r12

	loop_ini:
	 cmpq %rax, %rbx
	 je fim

	 movq 0(%rax), %rcx
	 movq 8(%rax), %rdx

	 #movq %r13, %rsi 
	 #mov $str0, %rdi
	 #call printf
	 addq $16, %rax
	 addq %rdx, %rax
	 jmp loop_ini
	fim:
	

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