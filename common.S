	.file "library.S"

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
	here_is	
*/
	.global here_is
here_is:
	push	{lr}
	mov	r1, lr
	bl	out

	pop	{lr}
here_is_skip:
	ldrb	r0, [lr], #1
	cmp	r0, #0
	bne	here_is_skip

	ands	r0, lr, #3
	moveq	pc, lr

	and	lr, #0xFFFFFFFC
	add	lr, #4
	mov	pc, lr

	





