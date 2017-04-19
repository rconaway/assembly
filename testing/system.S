	.data
buffer:	.space 100

	.text

	.global system
system:
	mov	r0, #42
	ldr	r1, =buffer
	bl	int_to_text

	mov	r2, r0
	mov	r0, #1
	mov	r7, #4
	swi	0

	mov	r7, #1
	mov 	r0, #0
	swi	0	

/*
	int_to_text - convert integer to decimal text
	
	on entry:
		r0 = integer to convert
		r1 = buffer to place the text
	on exit:
		r0 = length of text
		r1 = original buffer
*/
	.global int_to_text
int_to_text:
	mov	pc, lr


/*
	shift_10 - "shift" the lowest decimal digit out of an integer

	on entry:
		r0 = integer to shift
	
	on exit:
		r0 = integer / 10
		r1 = integer mod 10
*/
	.global shift_10
shift_10:
	mov	pc, lr


/*
	digit_to_text - convert a single digit to ascii text

	on entry:
		r0 = digit (0x00 - 0x09)

	on exit:
		r0 = text ('0' - '9')
*/
	.global digit_to_text
digit_to_text:
	mov	pc, lr

