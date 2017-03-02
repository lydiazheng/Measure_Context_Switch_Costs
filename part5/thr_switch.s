	.file	"thr_switch.c"
	.globl	mutex
	.bss
	.align 32
	.type	mutex, @object
	.size	mutex, 40
mutex:
	.zero	40
	.globl	cond1
	.align 32
	.type	cond1, @object
	.size	cond1, 48
cond1:
	.zero	48
	.globl	cond2
	.align 32
	.type	cond2, @object
	.size	cond2, 48
cond2:
	.zero	48
	.globl	num
	.align 4
	.type	num, @object
	.size	num, 4
num:
	.zero	4
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
	.string	"result   %llu\n"
	.align 8
.LC1:
	.string	"Based on 100 times of the measurement,"
	.align 8
.LC2:
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
	subq	$48, %rsp
	movq	$0, -24(%rbp)
	leaq	-40(%rbp), %rax
	movl	$0, %ecx
	movl	$thread1, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	pthread_create
	leaq	-32(%rbp), %rax
	movl	$0, %ecx
	movl	$thread2, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	pthread_create
	movq	-40(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	pthread_join
	movq	-32(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	pthread_join
	movq	$0, -16(%rbp)
	jmp	.L4
.L5:
	movq	-8(%rbp), %rax
	addq	%rax, -24(%rbp)
	movq	-8(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC0, %edi
	movl	$0, %eax
	call	printf
	addq	$1, -16(%rbp)
.L4:
	cmpq	$99, -16(%rbp)
	jbe	.L5
	movl	$.LC1, %edi
	call	puts
	movq	-24(%rbp), %rax
	shrq	$2, %rax
	movabsq	$2951479051793528259, %rdx
	mulq	%rdx
	movq	%rdx, %rax
	shrq	$2, %rax
	movq	%rax, %rsi
	movl	$.LC2, %edi
	movl	$0, %eax
	call	printf
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3:
	.size	main, .-main
	.globl	thread1
	.type	thread1, @function
thread1:
.LFB4:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	$0, -40(%rbp)
	jmp	.L8
.L11:
	movl	$mutex, %edi
	call	pthread_mutex_lock
	jmp	.L9
.L10:
	movl	$mutex, %esi
	movl	$cond1, %edi
	call	pthread_cond_wait
	leaq	-16(%rbp), %rax
	movq	%rax, %rsi
	movl	$1, %edi
	call	clock_gettime
.L9:
	movl	num(%rip), %eax
	testl	%eax, %eax
	je	.L10
	movl	$0, num(%rip)
	leaq	-32(%rbp), %rax
	movq	%rax, %rsi
	movl	$1, %edi
	call	clock_gettime
	movl	$cond2, %edi
	call	pthread_cond_signal
	movl	$mutex, %edi
	call	pthread_mutex_unlock
	addq	$1, -40(%rbp)
.L8:
	cmpq	$99, -40(%rbp)
	jbe	.L11
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4:
	.size	thread1, .-thread1
	.globl	thread2
	.type	thread2, @function
thread2:
.LFB5:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	$0, -40(%rbp)
	jmp	.L13
.L16:
	movl	$mutex, %edi
	call	pthread_mutex_lock
	jmp	.L14
.L15:
	movl	$mutex, %esi
	movl	$cond2, %edi
	call	pthread_cond_wait
	leaq	-16(%rbp), %rax
	movq	%rax, %rsi
	movl	$1, %edi
	call	clock_gettime
.L14:
	movl	num(%rip), %eax
	testl	%eax, %eax
	je	.L15
	movl	$0, num(%rip)
	leaq	-32(%rbp), %rax
	movq	%rax, %rsi
	movl	$1, %edi
	call	clock_gettime
	movl	$cond1, %edi
	call	pthread_cond_signal
	movl	$mutex, %edi
	call	pthread_mutex_unlock
	addq	$1, -40(%rbp)
.L13:
	cmpq	$99, -40(%rbp)
	jbe	.L16
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE5:
	.size	thread2, .-thread2
	.ident	"GCC: (Ubuntu 4.8.4-2ubuntu1~14.04.3) 4.8.4"
	.section	.note.GNU-stack,"",@progbits
