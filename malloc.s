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
.globl iniciaAlocador, alocaMem,  finalizaAlocador, liberaMem, imprimeMapa, printaval

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

		movq $0, %r8
		movq $0, %r9				#min tam
		movq $0, %r15				#address
		movq $0, %r14				#check_disp

	movq inicioHeap, %rcx			#inicio -> 0
	movq topoHeap  , %rdx			#topo salvo em rdx 
									#não usamos mais o lim_brk a partir daqui

	check:
		cmpq %rcx, %rdx				#checa se o endereço atual esta no topo da heap
		je comp_slot				#caso sim, vai para comp_slot
		jmp compara					#caso não, vai para compara

	comp_slot:
		cmpq $10, %r14				#Checa se r14 =10
		je aloca_aqui				#Caso sim, há um espaço com valor > ou = ao solicitado, então aloca nesse valor em "aloca_aqui"
		jmp aloca 					#Caso não, há a necessidade alocar um novo espaço, por isso redireciona ao aloca

	compara:
		movq 0(%rcx), %r12  		#Move o valor de de disponibilidade do header para r12
		movq 8(%rcx), %r13			#Move o tamanho do espaço alocado (sem o offset de 16) para r13

		cmpq $OK, %r12  			#Compara %r12 com 0
		jne proximo_bloco 			#Caso seja 1 (ocupado), procura outro bloco de memória

		cmpq %rbx, %r13   			#Compara o valor de r13 com o valor desejado (rbx), se r13 for menor ou igual, procura outro bloco
	    jle proximo_bloco

	salva_menor:

		cmpq $0, %r9 				#Compara r9 (menor valor maior ou igual ao desejado) com 0, para caso seja a primeira vez da variavel r9 sendo utilizada
		je auto_save 				#Caso r9 seja 0, vai para autosave pra inicializar a variavel com o primeiro valor de r9 (menor do que rbx)

		cmpq %r13, %r9 				#Compara r9 com r13
		jl proximo_bloco 			#Caso r9, seja menor que r13, o valor disponivel não é o suficiente, então vai pro proximo bloco	

		

	auto_save:
		movq %r13, %r9     			#Atualiza valor de r9 com o valor disponivel
		movq $10, %r14 				#Atualiza r14 com o valor de 10, para informar que em algum lugar há um slot disponivel 
		movq %rcx, %r15 			#Salva o endereço do lugar disponivel para alocar

		jmp proximo_bloco 			#Passa para o proximo bloco

	aloca_aqui:
		movq $NOT_OK, 0(%r15) 		#Muda o valor de 0(%r15) para "ocupado"
		addq $16, %r15				#Adiciona 16 bytes no endereço de r15

		movq %r15, %rax				#Retorna o ponteiro com 16 bytes de offset no espaço disponível
		jmp saida

	proximo_bloco:
		addq %r13, %rcx  			#Adiciona o tamanho do espaço no endereço de rcx 
		addq  $16, %rcx 			#Adiciona 16 bytes no endereço de rcx para ir até o próximo bloco
		jmp check
	
	aloca:
		#movq , %r11		#aux

		return:							#Retorno do loop de alocação de 4k bytes
			movq lim_Brk, %rdi 			#Salva o limite atual da brk em rdi
			subq topoHeap, %rdi  		#Subtrai o topo da Heap de rdi
			movq %rdi, fr_spc    		#lim_brk - topo heap = espaço livre (disponível)

		cmpq %rbx, fr_spc 				#Checa se o espaço livre é menor do que o que precisamos
		jl brk_sol						#Pula pra função que atribui o valor Max de alocação de brk



		movq %rbx, %r10					#Salva o valor desejado em r10
		
		movq %r10, %r11					#Salva o valor desejado em r11
		addq  $16, %r11					#Adiciona 16(tamanho do header)
		addq topoHeap, %r11				#Soma o tamanho da Heap com o valor "alocado"

		
		movq %r11, topoHeap				#Atualiza valor do topo da heap com r11

		movq %rcx, %rdx					#Passa o endereço do espaço alocado pra rdx

		movq   $NOT_OK, (%rdx)			#Atualiza o Header pra "ocupado"
		addq   $8,  %rdx				#Move 8 bytes no endereço de rdx
		movq %r10, (%rdx)				#Atualiza o valor do espaço no header
		addq   $8,  %rdx				#Move 8 bytes no endereço de rdx

		movq %rdx, %rax					#Passa o ponteiro de 16 bytes do espaço pro rax (registrador de retorno da função)
		jmp saida

	brk_sol:
		addq $MAX_SIZE, %r8				#Adiciona o valor máximo alocável em r8
		cmpq %rbx, %r8					#Checa se r8 é menor que o valor maximo
		jg livre 						#Caso seja maior, ja aloca
		jle brk_sol						#Caso seja menor, retorna e aloca mais MAX_SIZE (4096)
	livre:

		pushq %rcx
		pushq %rbx

		movq $12, %rax					#Atualiza a brk com o novo valor de r8, para que caiba o valor pedido
		movq %r8, %rdi
		syscall


		movq $bug_avoid, %rdi 			#Chamada abençoada (e misteriosa) resolvedora de problemas
		call printf

		popq %rbx
		popq %rcx

		addq %r8, lim_Brk 				#Adiciona o valor de r8 (espaço novo alocado em brk) na variavel lim_BrK
		jmp return



	saida:
		popq %rbp
		ret

finalizaAlocador:
	pushq %rbp
	movq %rsp, %rbp

	movq inicioHeap, %rdi 				#Passa o inicioHeap (usualmente 0) para o rdi
	movq $12, %rax						#Executa a syscall para retornar o valor  da brk ao inicio
	syscall

	popq %rbp
	ret

liberaMem:
	pushq %rbp
	movq %rsp, %rbp

	movq %rdi, %rcx 					#Recebe a variável a ser "desalocada"

	subq $16, %rcx 						#Remove o ponteiro 
	movq $OK, (%rcx) 					#Altera o valor de disponibilidade do header pra 0 (disponível)

	movq %rcx, %rax 					#Retorna o ponteiro pra um local do bloco

	popq %rbp
	ret

imprimeMapa:
	pushq %rbp
	movq %rsp, %rbp

	movq inicioHeap, %r13				#Move o início para r13
	movq topoHeap  , %r14				#Move o topo para r14

	cmpq %r13, %r14                     #Compara r14 com r13
	je saida_vazia                      #Caso sejam iguais, significam que não há valores armazenados na heap
	inicio_while:
		cmpq %r13, %r14                 #Compara r14 com r13
		je fim_while                    #Caso sejam iguais, termina o laço de repetição

		movq 0(%r13), %r12              #Armazena o valor disp do header
		movq 8(%r13), %r15              #Armazena o tamanho do bloco em r15

		movq $0, %rbx                   #Zera duas variáveis de auxilio
		movq $0, %rcx

		while_header:					#While utilizado para imprimir os valores do Header
			cmpq $HEADER, %rbx          
			je saida_while_header       #Caso tenha chegado ao número de bytes, pula pro fim do while

			pushq %rcx
			pushq %rbx

			mov $str4, %rdi             #Printa # para cada byte do header 
			call printf

			popq %rbx
			popq %rcx

			addq $1, %rbx               #Soma 1 no contador

			jmp while_header
		saida_while_header:

		cmpq $NOT_OK, %r12              #Compara o valor de disp do header
		je imprime_ocupado              #Caso seja 1, imprime o caracter de ocupado
		jne imprime_livre               #Caso não seja 1, imprime o caracter de livre

		imprime_ocupado:                #While para imprimir ocupado
			cmpq %r15, %rcx        		#Compara rcx com r15
			jge saida_padrao            #Se for maior ou igual, acabou o loop e pula pra saida

			pushq %rcx
			pushq %rbx

			mov $ocup, %rdi             #Printa valor de ocupado
			call printf

			popq %rbx
			popq %rcx



			addq $1, %rcx

			jmp imprime_ocupado

		imprime_livre:					#While para imprimir livre
			cmpq %r15, %rcx 			#Compara rcx com r15
			jge saida_padrao			#Se for maior ou igual, acabou o loop e pula pra saida

			pushq %rcx
			pushq %rbx

			mov $free, %rdi  			#Printa valor de livre
			call printf

			popq %rbx
			popq %rcx

			addq $1, %rcx

			jmp imprime_livre

		saida_padrao:
		
			pushq %rcx
			pushq %rbx

			mov $break_line, %rdi 		#Printa o \n no final
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

		mov $str5, %rdi  				#Printa se a heap estiver vazia
		call printf

		popq %rbx
		popq %rcx

	the_end:

	popq %rbp
	ret

