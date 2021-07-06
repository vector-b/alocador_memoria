.section .data
	A: .quad 0
	B: .quad 0
.section .text 
.globl _start
task:
	pushq %rbp
	movq %rsp,%rbp
	
	popq %rbp
_start:
	
	movq $60, %rax
	movq %rbx, %rdi
	syscall