	.file "common_test.S"
	.include "aunit.S"

	.data

buffer:	.space	1000

	.text

BEGIN_TEST_LIST

BEGIN_TEST inline_string_empty
	load_string	r1, ""
	load_string	r2, ""

	bl	text_eq

	assert  	eq, "did not match" 
END_TEST

BEGIN_TEST inline_string_1_character
	load_string	r1, "a"
	load_string	r2, "a"

	bl	text_eq

	assert 		eq, "did not match" 
END_TEST

BEGIN_TEST inline_string_2_character
	load_string	r1, "ab"
	load_string	r2, "ab"

	bl	text_eq

	assert  	eq, "did not match\n" 
END_TEST

BEGIN_TEST inline_string_3_character
	load_string 	r1, "abc"
	load_string 	r2, "abc"

	bl	text_eq

	assert  	eq, "did not match\n" 
END_TEST

BEGIN_TEST inline_string_4_character
	load_string	r1, "abcd"
	load_string	r2, "abcd"

	bl	text_eq

	assert  	eq, "did not match\n" 
END_TEST

BEGIN_TEST inline_string_not_match
	load_string	r1, "foo"
	load_string	r2, "bazoo"

	bl	text_eq

	assert		ne, "strings matched even though they are different"
END_TEST

BEGIN_TEST reverse_text_empty
	store_string	buffer, ""

	ldr	r0, =buffer
	bl 	reverse_text

	test_string	buffer, ""
	assert  	eq, "reverse_string did not work for empty string\n"
END_TEST

BEGIN_TEST reverse_text_even
	store_string 	buffer, "abcd"

	ldr	r0, =buffer
	bl	reverse_text

	test_string	buffer, "dcba"
	assert eq	"reverse_string did not work for even number of characters\n"
END_TEST

BEGIN_TEST reverse_text_odd
	store_string	buffer, "abc"

	ldr	r0, =buffer
	bl	reverse_text

	test_string	buffer, "cba"
	assert  	eq, "reverse_string did not work for odd number of characters\n"
END_TEST


BEGIN_TEST digit_to_text_test
	mov	r0, #4
	bl	digit_to_text

	cmp		r0, #'4'
	assert  	eq, "digit_to_text did not convert 4 to '4'\n"
END_TEST


BEGIN_TEST shift_10_zero
	mov	r0, #0
	bl	shift_10
	
	cmp		r0, #0
	assert		eq, "r0 (dividend) was not 0"
	cmp		r1, #0
	assert  	eq, "r1 (modulus) was not 0"
END_TEST


BEGIN_TEST shift_10_one_digit
	mov	r0, #1
	bl	shift_10
	
	cmp		r0, #0
	assert		eq, "r0 (dividend) was not 0"
	cmp		r1, #1
	assert  	eq, "r1 (modulus) was not 1"
END_TEST


BEGIN_TEST shift_10_two_digits
	mov	r0, #42
	bl	shift_10
	
	cmp		r0, #4
	assert		eq, "r0 (dividend) was not 4"
	cmpeq		r1, #2
	assert  	eq, "r1 (modulus) was not 2"
END_TEST


BEGIN_TEST int_to_text_zero
	mov	r0, #0
	ldr	r1, =buffer	
	bl	int_to_text
	
	test_string	buffer, "0"
	assert  	eq,  "did not convert int correctly\n"
END_TEST


BEGIN_TEST int_to_text_one_digit
	mov	r0, #1
	ldr	r1, =buffer	
	bl	int_to_text
	
	test_string	buffer, "1"
	assert  	eq,  "did not convert int correctly\n"
END_TEST

BEGIN_TEST int_to_text_even_digit
	mov	r0, #2
	ldr	r1, =buffer	
	bl	int_to_text

	test_string	buffer, "2"
	assert  	eq,  "did not convert int correctly\n"
END_TEST

BEGIN_TEST int_to_text_two_digits
	mov	r0, #42
	ldr	r1, =buffer	
	bl	int_to_text
	
	test_string	buffer, "42"
	assert  	eq,  "did not convert int correctly\n"
END_TEST

BEGIN_TEST int_to_text_returns_buffer
	mov	r0, #42
	ldr	r1, =buffer	
	bl	int_to_text
	
	ldr		r2, =buffer
	cmp		r1, r2
	assert  	eq, "did not return buffer\n"
END_TEST

BEGIN_TEST text_to_int_empty_string
	load_string	r1, ""
	bl	text_to_int
	cmp	r0, #0

	assert  eq,  "empty string is not zero"
END_TEST

BEGIN_TEST text_to_int_one_digit
	load_string	r1, "5"
	
	bl	text_to_int
	
	cmp		r0, #5
	assert  eq,  "'5' is not 5\n"
END_TEST

BEGIN_TEST text_to_int_two_digits
	load_string 	r1, "42"

	bl	text_to_int

	cmp		r0, #42
	assert  	eq, "'42' is not 42"
END_TEST

BEGIN_TEST text_to_int_invalid
	load_string 	r1, "1foo"

	bl	text_to_int

	cmp 		r0, #-1
	assert  	eq, "invalid is not -1\n"
END_TEST

BEGIN_TEST copy_string_test
	load_string	r2, "a test"
	ldr		r1, =buffer

	bl	copy_string

	test_string	buffer, "a test"

	assert  	eq, "did not copy string"
END_TEST

BEGIN_TEST add_nl_test
	load_string	r2, "a test"

	ldr	r1, =buffer
	bl	copy_string
	ldr	r1, =buffer
	bl	add_nl

	test_string	buffer, "a test\n"
	assert  eq,  "did not append nl"
END_TEST

BEGIN_TEST add_nl_not_needed
	load_string 	r2, "a test\n"

	ldr	r1, =buffer
	bl	copy_string
	ldr	r1, =buffer
	bl	add_nl

	load_string	r2, "a test\n"
	bl	text_eq

	assert  eq,  "did not append nl"
END_TEST


END_TEST_LIST


