	.file "common_test.S"
	.include "aunit.S"

	.data

buffer:	.space	1000

	.text

BEGIN_TEST_LIST

BEGIN_TEST inline_string_empty
	ld_rs	r1, ""
	ld_rs	r2, ""

	bl	text_eq

	a_eq	"did not match" 
END_TEST

BEGIN_TEST inline_string_1_character
	ld_rs	r1, "a"
	ld_rs	r2, "a"

	bl	text_eq

	a_eq	"did not match" 
END_TEST

BEGIN_TEST inline_string_2_character
	ld_rs	r1, "ab"
	ld_rs	r2, "ab"

	bl	text_eq

	a_eq	"did not match" 
END_TEST

BEGIN_TEST inline_string_3_character
	ld_rs 	r1, "abc"
	ld_rs 	r2, "abc"

	bl	text_eq

	a_eq	"did not match" 
END_TEST

BEGIN_TEST inline_string_4_character
	ld_rs	r1, "abcd"
	ld_rs	r2, "abcd"

	bl	text_eq

	a_eq	"did not match" 
END_TEST

BEGIN_TEST inline_string_not_match
	ld_rs	r1, "foo"
	ld_rs	r2, "bazoo"

	bl	text_eq

	a_ne	"strings matched even though they are different"
END_TEST

BEGIN_TEST inline_does_not_move_sp
	mov	r2, sp

	bl	inline_string
	.ascii	"foo"
	.align	4
	pop	{r1}

	cmp	sp, r2

	a_eq	"sp was moved"
END_TEST

BEGIN_TEST reverse_text_empty
	st_bs	buffer, ""

	ldr	r0, =buffer
	bl 	reverse_text

	cmp_bs	buffer, ""
	a_eq	"reverse_string did not work for empty string"
END_TEST

BEGIN_TEST reverse_text_even
	st_bs 	buffer, "abcd"

	ldr	r0, =buffer
	bl	reverse_text

	cmp_bs	buffer, "dcba"
	a_eq	"reverse_string did not work for even number of characters"
END_TEST

BEGIN_TEST reverse_text_odd
	st_bs	buffer, "abc"

	ldr	r0, =buffer
	bl	reverse_text

	cmp_bs	buffer, "cba"
	a_eq	"reverse_string did not work for odd number of characters"
END_TEST


BEGIN_TEST digit_to_text_test
	mov	r0, #4
	bl	digit_to_text

	cmp	r0, #'4'
	a_eq	"digit_to_text did not convert 4 to '4'"
END_TEST


BEGIN_TEST shift_10_zero
	mov	r0, #0
	bl	shift_10
	
	cmp	r0, #0
	a_eq	"r0 (dividend) was not 0"
	cmp	r1, #0
	a_eq	"r1 (modulus) was not 0"
END_TEST


BEGIN_TEST shift_10_one_digit
	mov	r0, #1
	bl	shift_10
	
	cmp	r0, #0
	a_eq	"r0 (dividend) was not 0"
	cmp	r1, #1
	a_eq	"r1 (modulus) was not 1"
END_TEST


BEGIN_TEST shift_10_two_digits
	mov	r0, #42
	bl	shift_10
	
	cmp	r0, #4
	a_eq	"r0 (dividend) was not 4"
	cmp	r1, #2
	a_eq	"r1 (modulus) was not 2"
END_TEST


BEGIN_TEST int_to_text_zero
	mov	r0, #0
	ldr	r1, =buffer	
	bl	int_to_text
	
	cmp_bs	buffer, "0"
	a_eq	"did not convert int correctly"
END_TEST


BEGIN_TEST int_to_text_one_digit
	mov	r0, #1
	ldr	r1, =buffer	
	bl	int_to_text
	
	cmp_bs	buffer, "1"
	a_eq	"did not convert int correctly"
END_TEST

BEGIN_TEST int_to_text_even_digit
	mov	r0, #2
	ldr	r1, =buffer	
	bl	int_to_text

	cmp_bs	buffer, "2"
	a_eq	"did not convert int correctly"
END_TEST

BEGIN_TEST int_to_text_two_digits
	mov	r0, #42
	ldr	r1, =buffer	
	bl	int_to_text
	
	cmp_bs	buffer, "42"
	a_eq	"did not convert int correctly"
END_TEST

BEGIN_TEST int_to_text_returns_buffer
	mov	r0, #42
	ldr	r1, =buffer	
	bl	int_to_text
	
	ldr	r2, =buffer
	cmp	r1, r2
	a_eq	"did not return buffer"
END_TEST

BEGIN_TEST text_to_int_empty_string
	ld_rs	r1, ""
	bl	text_to_int
	cmp	r0, #0

	a_eq	"empty string is not zero"
END_TEST

BEGIN_TEST text_to_int_one_digit
	ld_rs	r1, "5"
	
	bl	text_to_int
	
	cmp	r0, #5
	a_eq	"'5' is not 5"
END_TEST

BEGIN_TEST text_to_int_two_digits
	ld_rs 	r1, "42"

	bl	text_to_int

	cmp	r0, #42
	a_eq	"'42' is not 42"
END_TEST

BEGIN_TEST text_to_int_invalid
	ld_rs 	r1, "1foo"

	bl	text_to_int

	cmp 	r0, #-1
	a_eq	"invalid is not -1"
END_TEST

BEGIN_TEST copy_string_test
	ld_rs	r2, "a test"
	ldr	r1, =buffer

	bl	copy_string

	cmp_bs	buffer, "a test"

	a_eq	"did not copy string"
END_TEST

BEGIN_TEST add_nl_test
	ld_rs	r2, "a test"

	ldr	r1, =buffer
	bl	copy_string
	ldr	r1, =buffer
	bl	add_nl

	cmp_bs	buffer, "a test\n"
	a_eq	"did not append nl"
END_TEST

BEGIN_TEST add_nl_not_needed
	ld_rs 	r2, "a test"

	ldr	r1, =buffer
	bl	copy_string
	ldr	r1, =buffer
	bl	add_nl

	ld_rs	r2, "a test\n"
	bl	text_eq

	a_eq	"did not append nl"
END_TEST


END_TEST_LIST


