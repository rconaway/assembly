/*
	aunit.S
*/
	.data 
failures:	.word	0
fail_message:	.asciz "FAILED\n"
message:	.space 1000

.macro BEGIN_TEST_LIST
	.data

test_list:
	.text
.endm


.macro END_TEST_LIST
	.data
	.word 0
	.text
.endm


.macro BEGIN_TEST name
	.data
	.word	\name
	.asciz	"test: \name\n"
	.text
\name:
.endm


.macro END_TEST
	b	next_test
.endm

.macro	a_eq  message
	assert eq, "\message"
.endm

.macro	a_ne message
	assert ne, "\message"
.endm

.macro	assert condition, message
	b\condition	1f
	ld_rs 	r1, "\033[31mFAILURE: "
	bl	out
	bl	inline_string
	.asciz "\message"
	.align 4
	pop	{r2}
	ldr	r1, =message
	bl 	copy_string
	ldr	r1, =message	
	bl	add_nl
	bl	out
	ld_rs	r1, "\033[0m"
	bl	out

	ldr	r1, =failures
	ldr	r0, [r1]
	add 	r0, #1
	str	r0, [r1]

	b	next_test
	.ltorg
1:
.endm

.macro ld_rs  register, string
	bl	inline_string
	.asciz	"\string"
	.align 4
	pop	{\register}
.endm

.macro st_bs	buffer, string
	push	{r1, r2}
	bl	inline_string
	.asciz	"\string"
	.align 4
	pop	{r2}
	ldr	r1, =\buffer
	bl	copy_string
	pop	{r1,r2}
.endm

.macro	cmp_bs	buffer, string
	push	{r1, r2}
	bl	inline_string
	.asciz	"\string"
	.align  4
	pop	{r2}
	ldr	r1, =\buffer
	bl	text_eq
	pop	{r1, r2}
.endm

.macro	cmp_rs	register, string
	push	{r1, r2}
	mov	r1, \register
	bl	inline_string
	.asciz	"\string"
	.align  4
	pop	{r2}
	bl	text_eq
	pop	{r1, r2}
.endm

	.global _start
_start:
        nop
        ldr     r11, =test_list

next_test:
        ldr     r10, [r11], #4
        cmp     r10, #0
        beq     after_test
        mov     r1, r11
        bl      out

skip_name:
        ldrb    r0, [r11], #1
        cmp     r0, #0
        bne     skip_name

        mov     pc, r10

after_test:
        ldr     r1, =failures   
        ldr     r0, [r1]
	cmp	r0, #0
	beq	success

	mov	r7, r0
	ld_rs	r1, "\033[31m"
	bl	out
	mov	r0, r7
	ldr	r1, =message
	bl	int_to_text
	bl	out
	ld_rs	r1, " TESTS FAILED\033[0m\n"
	bl	out
	b	exit

success:
	ld_rs	r1, "\033[32mPASSED\033[0m\n"
	bl	out
	mov	r0, #0

exit:
        mov     r7, #1
        swi     0

