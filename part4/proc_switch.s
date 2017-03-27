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
	.align 8
.LC2:
	.string	"Based on 1000 times of the measurement,"
	.align 8
.LC3:
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
	subq	$320, %rsp
	movq	$0, -264(%rbp)
	movb	$122, -309(%rbp)
	leaq	-304(%rbp), %rax
	movq	%rax, %rdi
	call	pipe
	leaq	-288(%rbp), %rax
	movq	%rax, %rdi
	call	pipe
	call	fork
	movl	%eax, -308(%rbp)
	cmpl	$0, -308(%rbp)
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
	movq	$2, -256(%rbp)
	cmpq	$1023, -256(%rbp)
	ja	.L6
	movq	-256(%rbp), %rax
	shrq	$6, %rax
	movq	-128(%rbp,%rax,8), %rdx
	movq	-256(%rbp), %rcx
	andl	$63, %ecx
	movl	$1, %esi
	salq	%cl, %rsi
	movq	%rsi, %rcx
	orq	%rcx, %rdx
	movq	%rdx, -128(%rbp,%rax,8)
.L6:
	leaq	-128(%rbp), %rdx
	movl	-308(%rbp), %eax
	movl	$128, %esi
	movl	%eax, %edi
	call	sched_setaffinity
	cmpl	$0, -308(%rbp)
	jns	.L7
	movl	$.LC1, %edi
	call	puts
	movl	$1, %edi
	call	exit
.L7:
	cmpl	$0, -308(%rbp)
	jne	.L8
	movl	-284(%rbp), %eax
	movl	%eax, %edi
	call	close
	movl	-304(%rbp), %eax
	movl	%eax, %edi
	call	close
	movq	$0, -272(%rbp)
	jmp	.L9
.L10:
	movl	-288(%rbp), %eax
	leaq	-309(%rbp), %rcx
	movl	$1, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	read
	movl	-300(%rbp), %eax
	leaq	-309(%rbp), %rcx
	movl	$1, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write
	addq	$1, -272(%rbp)
.L9:
	cmpq	$999, -272(%rbp)
	jbe	.L10
	movl	$1, %edi
	call	exit
.L8:
	movl	-300(%rbp), %eax
	movl	%eax, %edi
	call	close
	movl	-288(%rbp), %eax
	movl	%eax, %edi
	call	close
	leaq	-224(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	clock_gettime
	movq	$0, -272(%rbp)
	jmp	.L11
.L12:
	movl	-284(%rbp), %eax
	leaq	-309(%rbp), %rcx
	movl	$1, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write
	movl	-304(%rbp), %eax
	leaq	-309(%rbp), %rcx
	movl	$1, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	read
	addq	$1, -272(%rbp)
.L11:
	cmpq	$999, -272(%rbp)
	jbe	.L12
	leaq	-208(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	clock_gettime
	movl	$0, %eax
	movq	%rax, %rdi
	call	wait
	leaq	-224(%rbp), %rdx
	leaq	-208(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	timespecDiff
	movq	%rax, -248(%rbp)
	movq	-248(%rbp), %rax
	addq	%rax, -264(%rbp)
	leaq	-192(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	clock_gettime
	movq	$0, -272(%rbp)
	jmp	.L13
.L14:
	addq	$1, -272(%rbp)
.L13:
	cmpq	$999, -272(%rbp)
	jbe	.L14
	leaq	-176(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	clock_gettime
	leaq	-192(%rbp), %rdx
	leaq	-176(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	timespecDiff
	movq	%rax, -240(%rbp)
	movq	-240(%rbp), %rax
	subq	%rax, -264(%rbp)
	leaq	-160(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	clock_gettime
	leaq	-144(%rbp), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	clock_gettime
	leaq	-160(%rbp), %rdx
	leaq	-144(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	timespecDiff
	movq	%rax, -232(%rbp)
	movq	-232(%rbp), %rax
	imulq	$1000, %rax, %rax
	subq	%rax, -264(%rbp)
	movl	$.LC2, %edi
	call	puts
	movq	-264(%rbp), %rax
	shrq	$3, %rax
	movabsq	$2361183241434822607, %rdx
	mulq	%rdx
	movq	%rdx, %rax
	shrq	$4, %rax
	movq	%rax, %rsi
	movl	$.LC3, %edi
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
