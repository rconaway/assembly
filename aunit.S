/*
	aunit.S
*/
	.data 
failures:	.word	0
fail_message:	.asciz "FAILED\n"

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
	bl	heap_reset
.endm


.macro END_TEST
	b	next_test
.endm

.macro FAIL
	b fail_test
.endm

.macro	ASSERT_EQ message
	beq	1f
	bl	inline_string
	.asciz "\message"
	.align 4
	pop	{r1}
	bl	out
	b	next_test
1:
.endm

.macro INLINE register, string
	bl	inline_string
	.asciz	"\string"
	.align 4
	pop	{\register}
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
        mov     r7, #1
        swi     0

fail_test:
	bl	save_registers
	ldr	r1, =fail_message
	bl	out
	@bl	report_registers
	ldr	r1, =failures
	ldr	r0, [r1]
	add	r0, #1
	str	r0, [r1]
	b next_test

