	.file	"system_call.c"
	.text
	.globl	timespecDiff
	.type	timespecDiff, @function
timespecDiff:
.LFB0:
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
.LFE0:
	.size	timespecDiff, .-timespecDiff
	.section	.rodata
.LC0:
	.string	"result     %llu\n"
	.align 8
.LC1:
	.string	"Based on 1000 times of the measurement,"
	.align 8
.LC2:
	.string	"The average time of a getpid() system call measured: %llu\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB1:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movq	$0, -56(%rbp)
	movq	$0, -48(%rbp)
	jmp	.L4
.L5:
	leaq	-32(%rbp), %rax
	movq	%rax, %rsi
	movl	$1, %edi
	call	clock_gettime
	movl	$0, %eax
	call	getpid
	leaq	-16(%rbp), %rax
	movq	%rax, %rsi
	movl	$1, %edi
	call	clock_gettime
	leaq	-32(%rbp), %rdx
	leaq	-16(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	timespecDiff
	movq	%rax, -40(%rbp)
	movq	-40(%rbp), %rax
	addq	%rax, -56(%rbp)
	movq	-40(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC0, %edi
	movl	$0, %eax
	call	printf
	addq	$1, -48(%rbp)
.L4:
	cmpq	$999, -48(%rbp)
	jbe	.L5
	movl	$.LC1, %edi
	call	puts
	movq	-56(%rbp), %rax
	shrq	$3, %rax
	movabsq	$2361183241434822607, %rdx
	mulq	%rdx
	movq	%rdx, %rax
	shrq	$4, %rax
	movq	%rax, %rsi
	movl	$.LC2, %edi
	movl	$0, %eax
	call	printf
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 4.8.4-2ubuntu1~14.04.3) 4.8.4"
	.section	.note.GNU-stack,"",@progbits
