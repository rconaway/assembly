	.file "hello.S"

	.data

hello:		.asciz "Hello, "
default_name: 	.asciz "whoever you are"
bang:		.asciz "!\n"
buffer:		.space 1000

	.text
	.global _start

_start:
	ldr	r0, [sp]
	cmp	r0, #2
	
	ldrge	r4, [sp, #8]
	ldrlt	r4, =default_name

	ldr	r1, =hello
	bl	out
	mov	r1, r4
	bl	out
	ldr	r1, =bang
	bl	out
	
	mov 	r0, #0
	mov 	r7, #1
	swi	0

