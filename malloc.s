.section .data	
	  topoHeap  : .quad 0
	  inicioHeap : .quad 0
	  lim_Brk: .quad 0
	  fr_spc: .quad 0
	  str0	 : .string "Inicio: %ld Topo: %ld \n" 
	  str1	 : .string "Disp: %ld  Tamanho: %ld \n" 
	  str2	 : .string "Saida diferenciada: %ld \n"
	  str3	 : .string "Valor atual: %ld \n"
	  str4	 : .string "#"
	  str5	 : .string "Heap vazia!\n"
	  ocup	 : .string "+"
	  free	 : .string "-"
	  teste	 : .string "TESTE!  \n"
	  bug_avoid	 : .string "\b"
	  break_line	 : .string "\n"

			A: .long 0 
	.equ NOT_OK, 1 
	.equ OK, 0 
	.equ HEADER, 16
	.equ MAX_SIZE, 4096

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



	movq $12, %rax					#Faz a syscall inicial para pegar o valor inicial da brk
	movq $0, %rdi
	syscall

	#inc  %rax
	movq %rax, lim_Brk				#Salva o valor atual da brk nas variaveis globais
	movq %rax, inicioHeap
	movq %rax, topoHeap

	popq %rbp
	ret

alocaMem:
	pushq %rbp
	movq %rsp, %rbp
	subq $0, %rsp


	movq %rdi, %rbx					#Captura o parametro recebido e coloca em rbx


		#movq 0(%r13), %rsi
		#movq 8(%r13), %rdx
		#call printf



		movq $0, %r8
		movq $0, %r9				#min tam
		movq $0, %r15				#address
		movq $0, %r14				#check_disp

	movq inicioHeap, %rcx			#inicio -> 0
	movq topoHeap  , %rdx			#topo salvo em rdx 
									#não usamos mais o lim_brk a partir daqui

	check:
		cmpq %rcx, %rdx
		je comp_slot

		jmp compara

	comp_slot:
		cmpq $10, %r14
		je aloca_aqui
		jmp aloca

	compara:
		movq 0(%rcx), %r12
		movq 8(%rcx), %r13

		cmpq $OK, %r12
		jne proximo_bloco

		cmpq %rbx, %r13
	    jle proximo_bloco

	salva_menor:

		cmpq $0, %r9
		je auto_save

		cmpq %r13, %r9
		jl proximo_bloco

		

	auto_save:
		movq %r13, %r9
		movq $10, %r14
		movq %rcx, %r15

		jmp proximo_bloco

	aloca_aqui:
		movq $1, 0(%r15)
		addq $16, %r15

		movq %r15, %rax
		jmp saida

	proximo_bloco:
		addq %r13, %rcx
		addq  $16, %rcx
		jmp check
	
	aloca:
		#movq , %r11		#aux

		return:							#Retorno do loop de alocação de 4k bytes
			movq lim_Brk, %rdi 				#Salva o limite atual da brk em rdi
			subq topoHeap, %rdi  			#Subtrai o topo da Heap de rdi
			movq %rdi, fr_spc    			#lim_brk - topo heap = espaço livre (disponível)

		cmpq %rbx, fr_spc 				#Checa se o espaço livre é menor do que o que precisamos
		jl brk_sol



		movq %rbx, %r10
		
		movq %r10, %r11
		addq  $16, %r11
		addq topoHeap, %r11

		
		movq %r11, topoHeap

		/*movq $12,  %rax
		movq %r11, %rdi
		syscall*/

		movq %rcx, %rdx

		movq   $1, (%rdx)
		addq   $8,  %rdx
		movq %r10, (%rdx)
		addq   $8,  %rdx

		movq %rdx, %rax
		jmp saida

	brk_sol:
		addq $MAX_SIZE, %r8
		cmpq %rbx, %r8
		jg livre
		jle brk_sol
	livre:

		pushq %rcx
		pushq %rbx

		movq $12, %rax
		movq %r8, %rdi
		syscall


		movq $bug_avoid, %rdi
		call printf

		popq %rbx
		popq %rcx
		
		addq %r8, lim_Brk
		jmp return



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
	movq $OK, (%rcx)

	popq %rbp
	ret

imprimeMapa:
	pushq %rbp
	movq %rsp, %rbp

	movq inicioHeap, %r13
	movq topoHeap  , %r14

	cmpq %r13, %r14
	je saida_vazia
	inicio_while:
		cmpq %r13, %r14
		je fim_while

		#mov $str1, %rdi
		#movq 0(%r13), %rsi
		#movq 8(%r13), %rdx
		#call printf
		movq 0(%r13), %r12
		movq 8(%r13), %r15

		movq $0, %rbx
		movq $0, %rcx

		while_header:
			cmpq $HEADER, %rbx
			je saida_while_header

			pushq %rcx
			pushq %rbx

			mov $str4, %rdi
			call printf

			popq %rbx
			popq %rcx

			addq $1, %rbx

			jmp while_header
		saida_while_header:

		cmpq $NOT_OK, %r12
		je imprime_ocupado
		jne imprime_livre

		imprime_ocupado:
			cmpq %r15, %rcx
			jge saida_padrao

			pushq %rcx
			pushq %rbx

			mov $ocup, %rdi
			call printf

			popq %rbx
			popq %rcx



			addq $1, %rcx

			jmp imprime_ocupado

		imprime_livre:
			cmpq %r15, %rcx
			jge saida_padrao

			pushq %rcx
			pushq %rbx

			mov $free, %rdi
			call printf

			popq %rbx
			popq %rcx

			addq $1, %rcx

			jmp imprime_livre

		saida_padrao:
		
			pushq %rcx
			pushq %rbx
			mov $break_line, %rdi
			call printf
			popq %rbx
			popq %rcx

			addq %r15, %r13
			addq $16, %r13
			jmp inicio_while

	fim_while:
	jmp the_end
	saida_vazia:
		pushq %rcx
		pushq %rbx

		mov $str5, %rdi
		call printf

		popq %rbx
		popq %rcx

	the_end:

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