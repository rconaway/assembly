	.file	"fibonacci.S"

	.global	_start

	.data

usage_text: 		.asciz "Usage: fibonacci <count>\n"
display_buffer: 	.space 100	

	.text

_start:
	// alias registers for readability
	rIndex	.req	r7
	rCount	.req	r8

	// r0 = count from command line
	bl	parse_command_line
	cmp	r0, #-1
	blt	usage

	// looping from 1 to count
	mov	rCount, r0
	mov	rIndex, #1

loop:
	cmp	rIndex, rCount
	movgt	r0, #0
	bgt	exit

	mov	r0, rIndex
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
	
