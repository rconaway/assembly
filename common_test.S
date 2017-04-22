	.file "common_test.S"
	.include "aunit.S"

	.data

inline_string_empty_expected:
	.asciz	""
inline_string_1_character_expected:
	.asciz	"a"
inline_string_2_character_expected:
	.asciz	"ab"
inline_string_3_character_expected:
	.asciz	"abc"
inline_string_4_character_expected:
	.asciz	"abcd"

empty_string:
	.asciz ""

abcd:
	.asciz "abcd"

dcba:	
	.asciz "dcba"

abc:	.asciz "abc"
cba:	.asciz "cba"

buffer:	.space 1000

	.text

BEGIN_TEST_LIST


BEGIN_TEST save_registers_r0
	mov	r0, #42
	bl	save_registers

	ldr	r0, [r1, #0]
	cmp	r0, #42
	ASSERT_EQ "r0 was not saved correctly\n"
END_TEST

BEGIN_TEST save_registers_r1
	mov	r1, #42
	bl	save_registers

	ldr	r0, [r1, #4]
	cmp	r0, #42
	ASSERT_EQ "r1 was not saved correctly\n"
END_TEST

BEGIN_TEST save_registers_lr
	push	{lr}
	mov	r2, lr
	bl	save_registers

	ldr	r0, [r1, #56]
	cmp	r0, r2
	ASSERT_EQ "lr was not saved correctly\n"
	pop	{lr}
END_TEST

BEGIN_TEST inline_string_empty
	INLINE	r1, ""

	ldr	r2,=inline_string_empty_expected
	bl	text_eq

	ASSERT_EQ "did not match\n" 
END_TEST

BEGIN_TEST inline_string_1_character
	INLINE	r1, "a"

	ldr	r2,=inline_string_1_character_expected
	bl	text_eq

	ASSERT_EQ "did not match\n" 
END_TEST

BEGIN_TEST inline_string_2_character
	INLINE	r1, "ab"

	ldr	r2,=inline_string_2_character_expected
	bl	text_eq

	ASSERT_EQ "did not match\n" 
END_TEST

BEGIN_TEST inline_string_3_character
	INLINE r1, "abc"

	ldr	r2,=inline_string_3_character_expected
	bl	text_eq

	ASSERT_EQ "did not match\n" 
END_TEST

BEGIN_TEST inline_string_4_character
	INLINE	r1, "abcd"

	ldr	r2,=inline_string_4_character_expected
	bl	text_eq

	ASSERT_EQ "did not match\n" 
END_TEST

BEGIN_TEST reverse_text_empty
	ldr	r0, =empty_string
	bl 	reverse_text

	mov	r2, r0
	INLINE r1, ""
	bl	text_eq
	ASSERT_EQ "reverse_string did not work for empty string\n"
END_TEST

BEGIN_TEST reverse_text_even
	ldr	r0, =abcd
	bl	reverse_text

	mov	r2, r0
	INLINE	r1, "dcba"
	bl	text_eq
	ASSERT_EQ "reverse_string did not work for even number of characters\n"
END_TEST

BEGIN_TEST reverse_text_odd
	ldr	r0, =abc
	bl	reverse_text

	mov	r2, r0
	INLINE	r1, "cba"
	bl	text_eq
	ASSERT_EQ "reverse_string did not work for odd number of characters\n"
END_TEST


BEGIN_TEST digit_to_text_test
	mov	r0, #4
	bl	digit_to_text
	cmp	r0, #'4'
	ASSERT_EQ "digit_to_text did not convert 4 to '4'\n"
END_TEST


BEGIN_TEST shift_10_zero
	mov	r0, #0
	bl	shift_10
	
	cmp	r0, #0
	cmpeq	r1, #0

	ASSERT_EQ "was not zero\n"
END_TEST


BEGIN_TEST shift_10_one_digit
	mov	r0, #1
	bl	shift_10
	
	cmp	r0, #0
	cmpeq	r1, #1

	ASSERT_EQ "test_shift_10_one_digit failed\n"
END_TEST


BEGIN_TEST shift_10_two_digits
	mov	r0, #42
	bl	shift_10
	
	cmp	r0, #4
	cmpeq	r1, #2
	
	ASSERT_EQ "test_shift_10_two_digits failed\n"
END_TEST


BEGIN_TEST int_to_text_zero
	mov	r0, #0
	ldr	r1, =buffer	
	bl	int_to_text
	
	cmp	r0, #1
	ASSERT_EQ "did not return length\n"

	ldr	r2, =buffer
	cmp	r1, r2
	ASSERT_EQ "did not return buffer\n"

	INLINE	r2, "0"

	bl	text_eq
	ASSERT_EQ "did not convert int correctly\n"
END_TEST


BEGIN_TEST int_to_text_one_digit
	mov	r0, #1
	ldr	r1, =buffer	
	bl	int_to_text
	
	cmp	r0, #1
	ASSERT_EQ "did not return length\n"

	ldr	r2, =buffer
	cmp	r1, r2
	ASSERT_EQ "did not return buffer\n"

	INLINE	r2, "1"
	bl	text_eq
	ASSERT_EQ "did not convert int correctly\n"
END_TEST

BEGIN_TEST int_to_text_two_digits
	mov	r0, #42
	ldr	r1, =buffer	
	bl	int_to_text
	
	cmp	r0, #2
	ASSERT_EQ "did not return length\n"

	ldr	r2, =buffer
	cmp	r1, r2
	ASSERT_EQ "dod not return buffer\n"

	INLINE r2, "42"
	bl	text_eq
	ASSERT_EQ "did not convert int correctly\n"
END_TEST

END_TEST_LIST


