.section .data	
	  brk_pos: .quad 0
	topo_heap: .quad 0
			A: .quad 0 
	.equ NOT_OK, 1 
	.equ OK, 0 

.section .text 
.globl iniciaAlocador, alocaMem, finalizaAlocador, imprimeMapa, liberaMem, _start
iniciaAlocador:
	pushq %rbp	
	movq %rsp, %rbp

	movq $12, %rax
	movq $0, %rdi
	syscall

	movq %rax, topo_heap
	movq %rax, brk_pos

	popq %rbp
	ret

alocaMem:

	pushq %rbp
	movq %rsp, %rbp

	#Recebe valor digitado:
	movq 16(%rbp), %rbx

	movq topo_heap, %rax
	movq brk_pos , %rcx 


	loop_alocador:			
	 cmpq %rax, %rcx
	 je alocador_extra


	pesquisa_blocos:		
	 movq 0(%rax), %r9
	 movq 8(%rax), %r10

	 cmpq $OK, %r9
	 jne proximo_bloco

	 cmpq (%rbx), %r10
	 jle proximo_bloco

	este_bloco:
	 movq $NOT_OK, 0(%rax)
	 #movq  (%rbx), %r11
	 #movq 	 %r11, 8(%rax)
	 addq 	  $16, %rax
	 jmp saida

	proximo_bloco:
	 addq $16, %rax
	 addq %r10, %rax
	 jmp loop_alocador


	alocador_extra:			
	 movq (%rbx), %r8
	 addq    $16, %r8
	 addq 	%rcx, %r8
	 
	 movq %rax, %r15

	 movq $12, %rax
	 movq %r8, %rdi
	 syscall

	 movq %r15, %rax

	 movq (%rbx), %r15

	 movq $NOT_OK , 0(%rax)
	 movq %r15    , 8(%rax)
	 addq $16, %rax

	 movq %r8, brk_pos
	 jmp saida

	saida:
	 popq %rbp
	 ret
	
finalizaAlocador:
	pushq %rbp
	movq %rsp, %rbp
	movq topo_heap, %rdi
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

	movq topo_heap, %rax
	movq brk_pos  , %rbx

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

/*_start:
	call iniciaAlocador
	
	movq $10, A
	pushq $A
	call alocaMem

	movq $20, A
	pushq $A
	call alocaMem

	movq $20, A
	pushq $A
	call alocaMem

	movq $20, A
	pushq $A
	call alocaMem
	
	call imprimeMapa

	movq (%rbx), %rdi
	movq $60, %rax
	syscall

*/

