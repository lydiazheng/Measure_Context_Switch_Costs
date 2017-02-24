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
	.string	"Based on 1000 times of the measurement,"
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
	subq	$80, %rsp
	movq	$0, -56(%rbp)
	movb	$97, -69(%rbp)
	movq	$0, -48(%rbp)
	jmp	.L4
.L8:
	leaq	-64(%rbp), %rax
	movq	%rax, %rdi
	call	pipe
	testl	%eax, %eax
	jns	.L5
	movl	$.LC0, %edi
	call	puts
	movl	$1, %edi
	call	exit
.L5:
	call	fork
	movl	%eax, -68(%rbp)
	cmpl	$0, -68(%rbp)
	jns	.L6
	movl	$.LC1, %edi
	call	puts
	movl	$1, %edi
	call	exit
.L6:
	cmpl	$0, -68(%rbp)
	jne	.L7
	movl	-60(%rbp), %eax
	movl	%eax, %edi
	call	close
	leaq	-64(%rbp), %rax
	leaq	-69(%rbp), %rcx
	movl	$1, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	read
	movl	$1, %edi
	call	exit
.L7:
	movl	-64(%rbp), %eax
	movl	%eax, %edi
	call	close
	leaq	-32(%rbp), %rax
	movq	%rax, %rsi
	movl	$1, %edi
	call	clock_gettime
	leaq	-64(%rbp), %rax
	leaq	-69(%rbp), %rcx
	movl	$1, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write
	movl	$0, %eax
	movq	%rax, %rdi
	call	wait
	leaq	-16(%rbp), %rax
	movq	%rax, %rsi
	movl	$1, %edi
	call	clock_gettime
	movl	-60(%rbp), %eax
	movl	%eax, %edi
	call	close
	leaq	-32(%rbp), %rdx
	leaq	-16(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	timespecDiff
	movq	%rax, -40(%rbp)
	movq	-40(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC2, %edi
	movl	$0, %eax
	call	printf
	movq	-40(%rbp), %rax
	addq	%rax, -56(%rbp)
	addq	$1, -48(%rbp)
.L4:
	cmpq	$99, -48(%rbp)
	jbe	.L8
	movl	$.LC3, %edi
	call	puts
	movq	-56(%rbp), %rax
	shrq	$2, %rax
	movabsq	$2951479051793528259, %rdx
	mulq	%rdx
	movq	%rdx, %rax
	shrq	$2, %rax
	movq	%rax, %rsi
	movl	$.LC4, %edi
	movl	$0, %eax
	call	printf
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 4.8.4-2ubuntu1~14.04.3) 4.8.4"
	.section	.note.GNU-stack,"",@progbits
