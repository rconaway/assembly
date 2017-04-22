	.file "library.S"

	.data
saved_registers:
	.space 64

heap:
	.word	0
	.space 0x10000

heap_end:

heap_next:
	.word heap

	.text

	.global out
out:
	push	{r7, lr}
	mov	r2, r1

out_find_z:
	ldrb	r0, [r2]
	cmp 	r0, #0
	addne	r2, #1
	bne	out_find_z

	sub	r2, r1	
	mov	r0, #1
	mov	r7, #4
	swi	0

	pop	{r7, pc}

/*
	text_eq - compare two null-terminated strings for equality

	on entry:
	    r1 points to first string
	    r2 points to second string

	on exit:
	    z is set if equal, unset if not equal
*/	
	.global text_eq
text_eq:
	push	{r1-r4, lr}

text_eq_loop:	
	ldrb	r3, [r1], #1
	ldrb	r4, [r2], #1

	cmp	r3, r4
	bne	text_eq_end

	cmp 	r3, #0
	bne	text_eq_loop

	cmp	r0, r0

text_eq_end:
	pop	{r1-r4, pc}


/*
	here_is - display an inline string

	on entry:
		LR points to the "return address" which is actually the beginning of the string

	on exit:
		PC returns to aligned address after the string
*/
here_is:
	// display the string at lr
	push	{lr}
	mov	r1, lr
	bl	out
	pop	{lr}

	b	inline_string

	.global save_registers
save_registers:
	push	{r0, r1}
	ldr	r1, =saved_registers
	stmia	r1, {r0-r14}

	// get r1 off the stack
	ldr	r0, [sp, #4]
	str	r0, [r1, #4]

	// get lr off the stack
	ldr	r0, [sp, #8]
	str	r0, [r1, #56]

	pop	{r0, r1}
	ldr	r1, =saved_registers
	mov	pc, lr

	.global interpolate_registers	
interpolate_registers:
	mov	pc, lr

	.global inline_string
inline_string:
	add	sp, #4
	push	{r0,r1}
	mov	r1, lr

	// advance lr to the null-terminator
inline_string_skip:
	ldrb	r0, [lr], #1
	cmp	r0, #0
	bne	inline_string_skip

	// align to next word boundary, if necessary
	ands	r0, lr, #3
	beq	inline_string_end
	and	lr, #0xFFFFFFFC
	add	lr, #4

inline_string_end:
	str	r1, [sp, #8]
	// "return" to the instruction after the string
	pop	{r0,r1}
	mov	pc, lr

	.global heap_allocate
heap_allocate:
	ldr	r2, =heap_next
	ldr	r1, [r2]
	ldr	r3, [r2]
	add	r3, r0
	str	r3, [r2]
	
	mov	pc, lr

	.global heap_append_string
heap_append_string:
	ldr	r0, =heap_next
	ldr	r2, [r0]

heap_append_string_skip:
	ldrb	r0,[r2], #1
	cmp	r0, #0
	bne	heap_append_string_skip
	sub	r2, #1	// write over null-terminator

heap_append_string_copy:
	ldrb	r0, [r1], #1
	strb	r0, [r2], #1
	cmp	r0, #0
	bne	heap_append_string_copy
	mov	r1, r2

	mov 	pc, lr	

	.global heap_allocate_string
heap_allocate_string:
	ldr	r0, =heap_next
	ldr	r1, [r0]
	mov	r2, r1

heap_allocate_string_skip:
	ldrb	r0, [r2], #1
	cmp	r0, #0
	bne	heap_allocate_string_skip

	ldr	r0, =heap_next
	str	r2, [r0]

	mov	pc, lr

	.global heap_reset
heap_reset:
	ldr	r0, =heap_next
	ldr	r1, =heap
	str	r1, [r0]
	mov	r0, #0
	str	r0, [r1]

	mov	pc, lr

