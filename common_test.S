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

BEGIN_TEST heap_allocate_zero_bytes
	mov	r0, #0
	bl	heap_allocate
	mov 	r4, r1
	bl	heap_allocate
	cmp	r1, r4

	ASSERT_EQ "heap was changed\n"
END_TEST

BEGIN_TEST heap_allocate_n_bytes
	mov	r0, #0
	bl	heap_allocate
	mov	r4, r1

	mov	r0, #42
	bl	heap_allocate
	cmp	r4, r1
	ASSERT_EQ "allocated memory is not at expected location\n"

	bl	heap_allocate
	add	r4, #42
	cmp	r4, r1
	ASSERT_EQ "did not allocate 42 bytes\n"
END_TEST

BEGIN_TEST heap_append_empty_string
	INLINE	r1, ""

	bl	heap_append_string
	mov	r4, r1
	
	INLINE	r1, ""
	mov	r2, r4
	bl	text_eq 
	
	ASSERT_EQ "did not allocate empty string\n"
END_TEST

BEGIN_TEST heap_allocate_string_init
	bl	heap_allocate_string
	INLINE	r2, ""
	bl	text_eq
	ASSERT_EQ "did not init correctly\n"
END_TEST

BEGIN_TEST heap_append_string_test

	INLINE	r1, "foo"
	bl	heap_append_string
	
	INLINE	r1, "bazoo"
	bl	heap_append_string

	bl	heap_allocate_string

	mov	r2, r1
	INLINE	r1,"foobazoo"

	bl	text_eq
	ASSERT_EQ "result was not 'foobazoo'"
END_TEST


END_TEST_LIST


