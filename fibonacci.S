	.file	"fibonacci.S"

	.equ	write, 4
	.equ	stdout, 1

	.data

usage_text:
	.ascii	"Usage: fibonacci <count>\n"

display_buffer:
	.space	100

	.set	n, -16
	.set 	i, -8
	.set	c, -12

	.set	fib_n, -16

	.file	"fibonacci.S"
	.align	2

.format:
	.ascii	"%d\n\0"
	
	
	.global	system
system:
	bl	parse_command_line
	cmp	r0, #-1
	blt	usage

	mov	r8, r0
	mov	r7, #1

loop:
	cmp	r7, r8
	movgt	r0, #0
	bgt	exit

	mov	r0, r7
	//bl	fibonacci
	ldr	r1, =display_buffer
	bl	int_to_text
	bl	add_nl
	bl	out
	
	add	r7, #1
	b	loop

usage:
	ldr	r1, =usage_text
	bl	out

	mov 	r0, #-1
	b	exit

exit:
	mov	r7, #1
	swi	0
	

fibonacci:
	mov	pc, lr

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
	bl	fibonacci
	mov	r4, r0

	@ subtract 2 from n then call Fibonacci
	ldr	r3, [fp, #fib_n]
	sub	r3, r3, #2
	mov	r0, r3
	bl	fibonacci
	mov	r3, r0

	@ add the results
	add	r3, r4, r3

.fibonacci_exit:
	mov	r0, r3

	@ restore the context from caller
	sub	sp, fp, #8
	ldmfd	sp!, {r4, fp, pc}
	
itoa:
	mov	pc, lr

/*
	parse_command_line - get count from command line

	on entry:
	    stack + 0 = parameter count
	    stack + 4 => name of program (null-terminated)
	    stack + 8 => first parameter (null-terminated)
	on exit:
	    r0 = count or -1 if error
*/

	.global parse_command_line		
parse_command_line:
	push	{lr}

	// make sure there is at least 1 parameter beyond prog name
	ldr	r0, [sp, #4]
	cmp	r0, #2

	movlt	r0, #-1	
	blt	parse_command_line_exit

	// parse parameter 1 (prog name is parameter 0)
	ldr	r1, [sp, #12]
	bl	text_to_int

	// if not parsed, r0 is already -1
	
parse_command_line_exit:
	pop	{pc}	

