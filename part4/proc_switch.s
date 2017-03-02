	.file	"proc_switch.c"
	.text
	.globl	timespecDiff
	.type	timespecDiff, @function
timespecDiff:
.LFB2:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	imulq	$1000000000, %rax, %rdx
	movq	-8(%rbp), %rax
	movq	8(%rax), %rax
	leaq	(%rdx,%rax), %rcx
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	imulq	$-1000000000, %rax, %rdx
	movq	-16(%rbp), %rax
	movq	8(%rax), %rax
	subq	%rax, %rdx
	movq	%rdx, %rax
	addq	%rcx, %rax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	timespecDiff, .-timespecDiff
	.section	.rodata
.LC0:
	.string	"***ERROR: pipe creat failed!"
	.align 8
.LC1:
	.string	"***ERROR: forking child process failed."
.LC2:
	.string	"result   %llu\n"
	.align 8
.LC3:
	.string	"Based on 100 times of the measurement,"
	.align 8
.LC4:
	.string	"The average time of a process switching measured: %llu\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB3:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$240, %rsp
	movq	$0, -184(%rbp)
	movb	$122, -229(%rbp)
	leaq	-224(%rbp), %rax
	movq	%rax, %rdi
	call	pipe
	leaq	-208(%rbp), %rax
	movq	%rax, %rdi
	call	pipe
	call	fork
	movl	%eax, -228(%rbp)
	cmpl	$0, -228(%rbp)
	jns	.L4
	movl	$.LC0, %edi
	call	puts
	movl	$1, %edi
	call	exit
.L4:
	leaq	-128(%rbp), %rax
	movq	%rax, %rsi
	movl	$0, %eax
	movl	$16, %edx
	movq	%rsi, %rdi
	movq	%rdx, %rcx
	rep stosq
	movq	$2, -176(%rbp)
	cmpq	$1023, -176(%rbp)
	ja	.L6
	movq	-176(%rbp), %rax
	shrq	$6, %rax
	movq	-128(%rbp,%rax,8), %rdx
	movq	-176(%rbp), %rcx
	andl	$63, %ecx
	movl	$1, %esi
	salq	%cl, %rsi
	movq	%rsi, %rcx
	orq	%rcx, %rdx
	movq	%rdx, -128(%rbp,%rax,8)
.L6:
	leaq	-128(%rbp), %rdx
	movl	-228(%rbp), %eax
	movl	$128, %esi
	movl	%eax, %edi
	call	sched_setaffinity
	cmpl	$0, -228(%rbp)
	jns	.L7
	movl	$.LC1, %edi
	call	puts
	movl	$1, %edi
	call	exit
.L7:
	cmpl	$0, -228(%rbp)
	jne	.L8
	movl	-204(%rbp), %eax
	movl	%eax, %edi
	call	close
	movl	-224(%rbp), %eax
	movl	%eax, %edi
	call	close
	movq	$0, -192(%rbp)
	jmp	.L9
.L10:
	movl	-208(%rbp), %eax
	leaq	-229(%rbp), %rcx
	movl	$1, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	read
	movl	-220(%rbp), %eax
	leaq	-229(%rbp), %rcx
	movl	$1, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write
	addq	$1, -192(%rbp)
.L9:
	cmpq	$99, -192(%rbp)
	jbe	.L10
	movl	$1, %edi
	call	exit
.L8:
	movl	-220(%rbp), %eax
	movl	%eax, %edi
	call	close
	movl	-208(%rbp), %eax
	movl	%eax, %edi
	call	close
	leaq	-160(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	clock_gettime
	movq	$0, -192(%rbp)
	jmp	.L11
.L12:
	movl	-204(%rbp), %eax
	leaq	-229(%rbp), %rcx
	movl	$1, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write
	movl	-208(%rbp), %eax
	leaq	-229(%rbp), %rcx
	movl	$1, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	read
	addq	$1, -192(%rbp)
.L11:
	cmpq	$99, -192(%rbp)
	jbe	.L12
	leaq	-144(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	clock_gettime
	movl	$0, %eax
	movq	%rax, %rdi
	call	wait
	leaq	-160(%rbp), %rdx
	leaq	-144(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	timespecDiff
	movq	%rax, -168(%rbp)
	movq	-168(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC2, %edi
	movl	$0, %eax
	call	printf
	movq	-168(%rbp), %rax
	addq	%rax, -184(%rbp)
	movl	$.LC3, %edi
	call	puts
	movq	-184(%rbp), %rax
	shrq	$2, %rax
	movabsq	$2951479051793528259, %rdx
	mulq	%rdx
	movq	%rdx, %rax
	shrq	$2, %rax
	movq	%rax, %rsi
	movl	$.LC4, %edi
	movl	$0, %eax
	call	printf
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 4.8.4-2ubuntu1~14.04.3) 4.8.4"
	.section	.note.GNU-stack,"",@progbits
