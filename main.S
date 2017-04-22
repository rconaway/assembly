	.file	"fibonacci.S"

	.global	_start

	.data
usage_text: 		.asciz "Usage: fibonacci <count>\n"
display_buffer: 	.space 100	

	.text
	
_start:
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
	
