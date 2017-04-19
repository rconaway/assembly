	.data
failures:
	.word	0

	.text

	.global _start
_start:
	bl	test_digit_to_text
	bl	test_shift_10_zero

	ldr	r1, =failures	
	ldr	r0, [r1]
	mov	r7, #1
	swi	0

test_digit_to_text:
	push	{lr}
	mov	r0, #4
	bl	digit_to_text
	cmp	r0, #'4'
	popeq	{pc}

	bl	error
	.asciz	"digit_to_text did not convert 4 to '4'\n"
	.align	4

test_shift_10_zero:
	push	{lr}
	bl	error
	.asciz	"test_shift_10_zero not implemented\n"

error:
	mov	r1, lr
	bl	out
	ldr	r1, =failures
	ldr	r0, [r1]
	add	r0, #1
	str	r0, [r1]

	pop	{pc}

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
	
	
	
