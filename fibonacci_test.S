	.file "fibonacci_test.S"
	.include "aunit.S"

	.data
	.text

BEGIN_TEST_LIST

BEGIN_TEST parse_command_line_no_parameter
	mov	r0, #1
	INLINE	r1, "the_program"
	push	{r0, r1}

	bl	parse_command_line
	cmp	r0, #-1
	ASSERT_EQ "did not fail on no parameter"

END_TEST

BEGIN_TEST parse_command_line_invalid_parameter
	mov	r0, #2
	INLINE  r1, "the_program"
	INLINE 	r2, "1x"
	push	{r0,r1,r2}

	bl parse_command_line
	cmp	r0, #-1
	ASSERT_EQ "did not fail on invalid parameter"
END_TEST

BEGIN_TEST parse_command_line_valid
	mov	r0, #2
	INLINE	r1, "the_program"
	INLINE	r2, "42"
	push	{r0, r1, r2}

	bl 	parse_command_line
	cmp	r0, #42
	ASSERT_EQ "did not convert parameter correctly"
END_TEST

END_TEST_LIST

