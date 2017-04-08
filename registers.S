	.file "hi.S"

	.data
ptr:	.word
buffer:	.space 100		

	.text
	.global _start

_start:	
	// put the address of the buffer in the string pointer
	ldr	r1, =str
	ldr	r2, =ptr
	str	r1, [r2]

	// store the first letter in the buffer
	ldr	r4, [r2]
	mov	r0, #'H'
	strb	r0, [r4]
	add	r4, #1

	// store the second letter in the buffer
	mov	r0, #'i'
	strb	r0, [r4], #1

	// store null-terminator
	mov	r0, #0
	strb	r0, [r4]

	mo
	mov	r0, #'H'
	ldr	
	mov	r1, r0		// copy register to register
	ldr	r2, =life	// load register with addr of label
	ldr	r3, [r2]	// load word from memory
	ldrb	r4, [r2]	// load byte from memory
	str	r1, [r2]	// store word in memory

	// r1 => string to display
	ldr	r1, =str
	bl	out

	mov 	r7, #1
	swi	0

