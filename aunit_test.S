	.file "aunit_test.S"
	.include "aunit.S"

	.data

empty_string:	.asciz ""
broken:		.asciz "He's dead, Jim\n"
foo_string:	.asciz "this is foo\n"
bazoo_string:	.asciz	"this is bazoo\n"

	.text

BEGIN_TEST_LIST

BEGIN_TEST foo
	ldr	r1, =foo_string
	bl	out
END_TEST

BEGIN_TEST bazoo
	ldr	r1, =bazoo_string
	bl	out	
END_TEST

END_TEST_LIST
