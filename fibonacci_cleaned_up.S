	.set	argc, -24
	.set	argv, -28
	.set	n, -16
	.set 	i, -8
	.set	c, -12

	.set	fib_n, -16

	.file	"fibonacci.S"
	.align	2

.format:
	.ascii	"%d\n\0"
	
	.text
	.align	2
	
	.global	main
main:
	nop
	@ save caller context
	push	{fp, lr}	@ push frame pointer and link register on the stack

	@ set up the stack frame
	add	fp, sp, #4	@ fp now points to original fp
	sub	sp, sp, #24	@ add room for local variables on stacki
	
	@ store parameters in stack frame 
	str	r0, [fp, #argc]	
	str	r1, [fp, #argv]	

	@ get the command-line parameter
	ldr	r3, [fp, #argv]
	add	r3, r3, #4
	ldr	r3, [r3]

	@ call atoi, puting result in n
	mov	r0, r3
	bl	atoi
	str	r0, [fp, #n]

	@ initialize i
	mov	r3, #0
	str	r3, [fp, #i]

	@ beginning of loop
	mov	r3, #1
	str	r3, [fp, #c]
	b	.LOOP_TEST

.LOOP:
	@ call Fibonacci, passing i as argument
	ldr	r0, [fp, #i]
	bl	Fibonacci
	mov	r3, r0

	@ print the result	
	ldr	r0, .format_ref
	mov	r1, r3
	bl	printf

	@ add 1 to n
	ldr	r3, [fp, #i]
	add	r3, r3, #1
	str	r3, [fp, #i]

	@ add 1 to c
	ldr	r3, [fp, #-12]
	add	r3, r3, #1
	str	r3, [fp, #-12]

.LOOP_TEST:
	ldr	r2, [fp, #c]
	ldr	r3, [fp, #n]
	cmp	r2, r3
	ble	.LOOP

	@ return with exit code 0
	mov	r3, #0
	mov	r0, r3

	# restore the context from caller
	sub	sp, fp, #4
	@ sp needed
	ldmfd	sp!, {fp, pc}

.END_OF_MAIN:

.format_ref:
	.align	2
	.word	.format

	@ tell the linker how big main is
	.size	main, .-main

	@ declare Fibonacci 
	.align	2
	.global	Fibonacci
	.type	Fibonacci, %function

Fibonacci:
	@ save caller context
	stmfd	sp!, {r4, fp, lr}

	@ setup the stack frame
	add	fp, sp, #8
	sub	sp, sp, #12

	@ save n
	str	r0, [fp, #fib_n]

.test_0:
	@ if n is not 0, continue 
	ldr	r3, [fp, #fib_n]
	cmp	r3, #0
	bne	.test_1

	@ else return 0
	mov	r3, #0
	b	.fibonacci_exit

.test_1:
	ldr	r3, [fp, #fib_n]
	cmp	r3, #1
	bne	.recurse
	mov	r3, #1
	b	.fibonacci_exit

.recurse:
	@ subtract 1 from n then call Fibonacci
	ldr	r3, [fp, #fib_n]
	sub	r3, r3, #1
	mov	r0, r3
	bl	Fibonacci
	mov	r4, r0

	@ subtract 2 from n then call Fibonacci
	ldr	r3, [fp, #fib_n]
	sub	r3, r3, #2
	mov	r0, r3
	bl	Fibonacci
	mov	r3, r0

	@ add the results
	add	r3, r4, r3

.fibonacci_exit:
	mov	r0, r3

	@ restore the context from caller
	sub	sp, fp, #8
	ldmfd	sp!, {r4, fp, pc}
	
	.size	Fibonacci, .-Fibonacci

