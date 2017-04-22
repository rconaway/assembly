	.file "fibonacci_test.S"
	.include "aunit.S"

	.data
buffer:
	.space 1000

zero:
	.asciz "0"

one:
	.asciz "1"

forty_two:
	.asciz "42"


foo_string:	.asciz "this is foo\n"
bazoo_string:	.asciz	"this is bazoo\n"

	.text

BEGIN_TEST_LIST



END_TEST_LIST

