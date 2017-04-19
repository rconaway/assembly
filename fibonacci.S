	.file	"fibonacci.S"

	.equ	write, 4
	.equ	stdout, 1

	.data

usage_text:
	.ascii	"Usage: fibonacci <count>\n"
	.equ	usage_text_len, .-usage_text

display_buffer:
	.space	100

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
	
	
	.global	system
system:
	@ make sure we have a command-line parameter
	ldr	r0, [sp]
	cmp	r0, #2
	blt	usage

	ldr	r1, [sp, #8]
	bl	atoi

	mov	r8, r0
	mov	r7, #1

loop:
	cmp	r7, r8
	bgt	end

	mov	r0, r7
	bl	fibonacci
	ldr	r1, =display_buffer
	bl	itoa
	mov	r2, #13
	strb	r2,[r1],#1
	mov	r2, r1
	sub	r2, #display_buffer
	mov	r0, #1
	mov	r7, #4
	swi	0

	b 	exit



	
	@ call Fibonacci, passing i as argument
	ldr	r0, [fp, #i]
	bl	fibonacci
	mov	r3, r0

	@ print the result	
	@ldr	r0, .format_ref
	mov	r1, r3
	@bl	printf

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
	ble	loop

	@ return with exit code 0
	mov	r3, #0
	mov	r0, r3

	# restore the context from caller
	sub	sp, fp, #4
	@ sp needed
	ldmfd	sp!, {fp, pc}

.END_OF_MAIN:

usage:
	mov	r7, #write 
	mov	r0, #stdout
	mov	r2, #usage_text_len
	ldr	r1, =usage_text
	swi 	0

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
	

atoi:
	stmfd	sp!, {r4}
	mov	r0, #0
	mov	r3, #10

atoi_loop:	
	ldrb	r2, [r1], #1
	cmp	r2, #0
	beq	atoi_end
	
	cmp	r2, #0x30
	blt	usage
	cmp	r2, #0x39
	bgt	usage

	mul	r4, r0, r3
	mov	r0, r4
	sub	r2, r2, #0x30
	add	r0, r0, r2
	b	atoi_loop

atoi_end:
	ldmfd	sp!, {r4}
	mov	pc, lr		

/*
	int_to_text - convert integer to decimal text
	
	on entry:
		r0 = integer to convert
		r1 = buffer to place the text
	on exit:
		r0 = length of text
		r1 = original buffer
*/
	.global int_to_text
int_to_text:
	push	{r1, r2, r3,r4, lr}

	mov	r4, r1

	mov	r2, r0
	mov	r3, r1

int_to_text_loop:
	mov	r0, r2	
	bl	shift_10
	mov	r2, r0

	mov	r0, r1
	bl	digit_to_text
	strb	r0, [r3], #1

	cmp	r2, #0
	bne	int_to_text_loop

	mov	r0, r4
	bl	reverse_text

	mov	r0, r3 
	sub	r0, r4

	mov	r1, #0
	strb	r1, [r3]

	pop	{r1, r2, r3, r4, pc}

itoa:
	@ > r0 = i
	@ > r1 => text buffer
	@ < r0 = len
	@ < r1 = text buffer

text_buffer .req r4
text_ptr .req r3
remainder .req r2

	stmfd	sp!,{r4}

	mov	text_buffer, r1
	mov	text_ptr, r1
	mov	remainder, r0

itoa_loop:
	mov	r1, remainder
	bl	shift_10
	mov	remainder, r1

	bl	digit_to_text
	strb	r0, [text_ptr], #1

	cmp	remainder, #0
	bne	itoa_loop

	sub	r0, text_ptr, text_buffer
	mov	r1, text_buffer

	ldmfd	sp!,{r4}
	mov	pc, lr

/*
	shift_10 - "shift" the lowest decimal digit out of an integer

	on entry:
		r0 = integer to shift
	
	on exit:
		r0 = integer / 10
		r1 = integer mod 10
*/
	.global shift_10
shift_10:
	push	{r4, r5, r6, lr}

	mov	r4, #10
	udiv	r5, r0, r4
	mul	r6, r5, r4
	mov	r1, r0
	sub	r1, r6
	mov	r0, r5

	pop	{r4, r5, r6, pc}


/*
	digit_to_text - convert a single digit to ascii text

	on entry:
		r0 = digit (0x00 - 0x09)

	on exit:
		r0 = text ('0' - '9')
*/
	.global digit_to_text
digit_to_text:
	add	r0, #'0'
	mov	pc, lr

/*
	reverse_text - reverse characters in a null-terminated string

	on entry:
		r0 = address of string

	on exit:
		r0 unchanged
*/
	.global reverse_text
reverse_text:
	push	{r1-r4, lr}
	mov	r1, r0
	mov	r2, r0

reverse_text_2:
	ldrb	r3, [r2]
	cmp	r3, #0
	beq	reverse_text_1
	add	r2, #1
	b	reverse_text_2

reverse_text_1:
	sub	r2, #1

reverse_text_loop:
	cmp	r1, r2
	bge	reverse_text_exit
	ldrb	r3, [r1]
	ldrb	r4, [r2]
	strb	r3, [r2], #-1
	strb	r4, [r1], #1
	b	reverse_text_loop	

reverse_text_exit:	
	pop	{r1-r4, pc}


