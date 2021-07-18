
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

	movq 16(%rbp), %rcx							#passa o novo valor desejado em rcx
	#movq (%rcx), %rdx

	movq topo_heap, %rax						#move o atual topo da heap para rax
	movq brk_atual, %rbx						#move a brk_atual(último valor) pra rbx

	cmpq $0, topo_heap
	je nem

#----------------------------------------------------------------------------------------------------------------------------------------------------
	busca_entrada:	
	 cmpq %rax, %rbx							#compara o valor da brk atual com o valor do topo, se forem iguais precisamos de mais memória
	 je nem										#caso a comparação seja igual, pula pra função nem

	 #Salva os inteiros do header do bloco, que possuem 8 bytes cada
	 movq 0(%rax), %rdx							#move o indice 0 ou 1 do bloco atual de memória pra rdx
	 movq 8(%rax), %rsi 							#move o tamanho do bloco de memoria para rsi

	 cmpq $OK, %rdx								#compara rdx com OK = 0
	 jne pesquisa								#caso não seja OK, pula para pesquisar um novo bloco
	
	 cmpq (%rcx), %rsi  #RCX <= RSI 				#compara o valor desejado com o valor disponivel
	 jl pesquisa 								#caso o valor disponivel seja menor do que o necessario, pula pra um novo block

	 jmp bloco_atual
#-----------------------------------------------------------------------------------------------------------------------------------------------------
	pesquisa:
	 addq $16, %rax
	 addq %rsi, %rax

	 jmp busca_entrada
#-----------------------------------------------------------------------------------------------------------------------------------------------------
	bloco_atual:
	 movq $NOT_OK, 0(%rax)
	 movq (%rcx), %rdx
	 movq %rdx, 8(%rax)
	 addq $16, %rax
	 addq $1, %r9
	 jmp saida
#-----------------------------------------------------------------------------------------------------------------------------------------------------
	nem:										#sigla pra not enough memory  #essa função é designada para cada vez que for necessãrio alocar mais memória
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
	 addq $1, %r8

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
_start:
	call iniciaAlocador

	movq $0, %r8
	movq $0, %r9

	movq $24, A
	pushq $A
	call alocaMem

	movq $24, B
	pushq $B
	call alocaMem

	movq $24, C
	pushq $C
	call alocaMem
	#pushq %rax
	#call liberaMem

	movq %r9, %rdi
	movq $60, %rax
	syscall

	

