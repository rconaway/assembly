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
	bl	fibonacci
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
	
	.global fibonacci
fibonacci:
	push	{r4,r5,lr}
	cmp	r0, #2
	ble	fibonacci_exit

	mov	r4, r0
	sub	r0, #1
	bl	fibonacci
	mov	r5, r0
	mov	r0, r4
	sub	r0, #2
	bl	fibonacci
	add	r0, r5
	
fibonacci_exit:
	pop	{r4,r5,pc}
	
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

