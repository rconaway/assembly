	.data
str:	.ascii "Hello World\n"
	.equ	str_len, .-str

	.text
	.global _start

_start:	
	mov	r7, #4
	mov	r0, #1
	mov 	r2, #str_len
	ldr	r1, =str
	swi	0

	mov 	r7, #1
	swi	0

