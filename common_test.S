	.file "common_test.S"
	.include "aunit.S"

	.text

BEGIN_TEST_LIST

BEGIN_TEST out_here_test
	bl	here_is
	.asciz	"this is a test\n"
	.align	4
END_TEST

BEGIN_TEST out_here_empty_string
	bl	here_is
	.asciz	""
	.align	4
END_TEST

BEGIN_TEST out_here_1_character
	bl	here_is
	.asciz	"\n"
	.align	4
END_TEST

BEGIN_TEST out_here_2_character
	bl	here_is
	.asciz	"a\n"
	.align 	4
END_TEST

BEGIN_TEST out_here_3_characters
	bl	here_is
	.asciz	"ab\n"
	.align 	4
END_TEST

BEGIN_TEST out_here_4_characters
	bl	here_is
	.asciz	"abc\n"
	.align	4
END_TEST

END_TEST_LIST

