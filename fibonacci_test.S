	.file "fibonacci_test.S"
	.include "aunit.S"

	.data
	.text

BEGIN_TEST_LIST

BEGIN_TEST parse_command_line_no_parameter
	mov	r0, #1
	ld_rs	r1, "the_program"
	push	{r0, r1}

	bl	parse_command_line

	a_ne	"did not fail on no parameter"
END_TEST

BEGIN_TEST parse_command_line_invalid_parameter
	mov	r0, #2
	ld_rs  r1, "the_program"
	ld_rs 	r2, "1x"
	push	{r0,r1,r2}

	bl parse_command_line

	a_ne 	"did not fail on invalid parameter"
END_TEST

BEGIN_TEST parse_command_line_valid
	mov	r0, #2
	ld_rs	r1, "the_program"
	ld_rs	r2, "42"
	push	{r0, r1, r2}

	bl 	parse_command_line

	a_eq	"failed parsing valid parameter"
	cmp	r0, #42
	a_eq	"did not convert parameter correctly"
END_TEST

BEGIN_TEST fibonacci_1
	mov	r0, #1

	bl	fibonacci

	cmp	r0, #1
	a_eq	"first number should be 1"
END_TEST

BEGIN_TEST fibonacci_2
	mov	r0, #2

	bl	fibonacci

	cmp	r0, #1
	a_eq	"second number should be 1"
END_TEST

BEGIN_TEST fibonacci_3
	mov	r0, #3

	bl	fibonacci

	cmp	r0, #2
	a_eq	"third number should be 2"
END_TEST

BEGIN_TEST fibonacci_4
	mov	r0, #4

	bl	fibonacci

	cmp	r0, #3
	a_eq	"fourth number should be 3"
END_TEST

BEGIN_TEST fibonacci_6
	mov	r0, #6

	bl	fibonacci

	cmp	r0, #8
	a_eq	"fourth number should be 8"
END_TEST

END_TEST_LIST

