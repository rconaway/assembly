	.file "test.S"

	.data
failures:
	.word	0

buffer:
	.space 1000

zero:
	.asciz "0"

one:
	.asciz "1"

forty_two:
	.asciz "42"

empty_string:
	.asciz ""

abcd:
	.asciz "abcd"

dcba:	
	.asciz "dcba"

abc:	.asciz "abc"
cba:	.asciz "cba"

	.text

	.global _start
_start:
	nop
	bl	test_reverse_text_empty
	bl	test_reverse_text_even
	bl	test_reverse_text_odd
	bl	test_digit_to_text
	bl	test_shift_10_zero
	bl	test_shift_10_one_digit
	bl	test_shift_10_two_digits
	bl	test_int_to_text_zero
	bl	test_int_to_text_one_digit
	bl	test_int_to_text_two_digits

	ldr	r1, =failures	
	ldr	r0, [r1]
	mov	r7, #1
	swi	0

test_reverse_text_empty:
	push	{lr}
	ldr	r0, =empty_string
	bl 	reverse_text
	ldr	r1, =empty_string
	cmp	r0, r1
	popeq	{pc}

	bl	error
	.asciz	"reverse_string did not work for empty string\n"
	.align	4

test_reverse_text_even:
	push	{lr}
	ldr	r0, =abcd
	bl	reverse_text
	ldr	r1, =abcd
	cmp	r0, r1

	ldreq	r2, =dcba
	bleq	text_eq
	popeq	{pc}

	bl	error
	.asciz	"reverse_string did not work for even number of characters\n"
	.align	4

test_reverse_text_odd:
	push	{lr}
	ldr	r0, =abc
	bl	reverse_text
	ldr	r1, =abc
	cmp	r0, r1

	ldreq	r2, =cba
	bleq	text_eq
	popeq	{pc}

	bl	error
	.asciz	"reverse_string did not work for odd number of characters\n"
	.align	4


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

	mov	r0, #0
	bl	shift_10
	
	cmp	r0, #0
	cmpeq	r1, #0
	popeq	{pc}

	bl	error
	.asciz	"was not zero\n"
	.align	4

test_shift_10_one_digit:
	push	{lr}

	mov	r0, #1
	bl	shift_10
	
	cmp	r0, #0
	cmpeq	r1, #1
	popeq	{pc}

	bl	error
	.asciz	"test_shift_10_one_digit failed\n"
	.align	4

test_shift_10_two_digits:
	push	{lr}

	mov	r0, #42
	bl	shift_10
	
	cmp	r0, #4
	cmpeq	r1, #2
	popeq	{pc}

	bl	error
	.asciz	"test_shift_10_two_digits failed\n"
	.align	4

test_int_to_text_zero:
	push 	{lr}

	mov	r0, #0
	ldr	r1, =buffer	
	bl	int_to_text
	
	cmp	r0, #1
	ldreq	r2, =buffer
	cmpeq	r1, r2
	ldreq	r2, =zero

	bleq	text_eq
	popeq	{pc}

	bl	error
	.asciz	"test_int_to_text_zero failed\n"
	.align 4

test_int_to_text_one_digit:
	push 	{lr}

	mov	r0, #1
	ldr	r1, =buffer	
	bl	int_to_text
	
	cmp	r0, #1
	ldreq	r2, =buffer
	cmpeq	r1, r2
	ldreq	r2, =one
	bleq	text_eq
	popeq	{pc}

	bl	error
	.asciz	"test_int_to_text_one_digit failed\n"
	.align 4

test_int_to_text_two_digits:
	push 	{lr}

	mov	r0, #42
	ldr	r1, =buffer	
	bl	int_to_text
	
	cmp	r0, #2
	ldreq	r2, =buffer
	cmpeq	r1, r2
	ldreq	r2, =forty_two
	bleq	text_eq
	popeq	{pc}

	bl	error
	.asciz	"test_int_to_text_two_digits failed\n"
	.align 4

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

/*
	text_eq - compare two null-terminated strings for equality

	on entry:
	    r1 points to first string
	    r2 points to second string

	on exit:
	    z is set if equal, unset if not equal
*/	
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
