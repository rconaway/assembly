	.file "library.S"

	.equ write, 4

	.text

	.global out
/*
	out - display null-terminated string to STDOUT

	on entry:
	    r1 => string to display

	on exit:
	    r0, r2 changed
	    r1 => string to display (unchanged)
*/

out:
	push	{r7, lr}

	// find the null terminator
	mov	r2, r1

out_find_z:
	ldrb	r0, [r2]
	cmp 	r0, #0
	addne	r2, #1
	bne	out_find_z

	// compute length of string
	sub	r2, r1	

	// system call to display string
	//	r0 = file handle (1 for STDOUT)
	//	r1 => string
	//	r2 = length of string
	//	r7 = system call (4 = write file)
	mov	r0, #1
	mov	r7, #write
	swi	0

	pop	{r7, pc}

/*
	text_eq - compare two null-terminated strings for equality

	on entry:
	    r1 points to first string
	    r2 points to second string

	on exit:
	    z is set if equal, unset if not equal
*/	
	.global text_eq
text_eq:
	push	{r1-r4, lr}

text_eq_loop:	
	ldrb	r3, [r1], #1
	ldrb	r4, [r2], #1

	cmp	r3, r4
	bne	text_eq_end

	cmp 	r3, #0
	bne	text_eq_loop

	cmp	r0, r0

text_eq_end:
	pop	{r1-r4, pc}


/*
	here_is - display an inline string

	on entry:
		LR points to the "return address" which is actually the beginning of the string

	on exit:
		PC returns to aligned address after the string
*/
here_is:
	// display the string at lr
	push	{lr}
	mov	r1, lr
	bl	out
	pop	{lr}

	b	inline_string

	.global inline_string
inline_string:
	push	{lr}	// pointer to string
	push	{r0}

	// advance lr to the null-terminator
1:
	ldrb	r0, [lr], #1
	cmp	r0, #0
	bne	1b

	// align to next word boundary, if necessary
	ands	r0, lr, #3
	beq	inline_string_end
	and	lr, #0xFFFFFFFC
	add	lr, #4

inline_string_end:
	// "return" to the instruction after the string
	pop	{r0}
	mov	pc, lr

/*
	reverse_text - reverse characters in a null-terminated string

	on entry:
		r0 = address of string

	on exit:
		r0 unchanged
*/
	.global reverse_text
reverse_text:
	push	{r1-r4, lr}
	mov	r1, r0
	mov	r2, r0

reverse_text_2:
	ldrb	r3, [r2]
	cmp	r3, #0
	beq	reverse_text_1
	add	r2, #1
	b	reverse_text_2

reverse_text_1:
	sub	r2, #1

reverse_text_loop:
	cmp	r1, r2
	bge	reverse_text_exit
	ldrb	r3, [r1]
	ldrb	r4, [r2]
	strb	r3, [r2], #-1
	strb	r4, [r1], #1
	b	reverse_text_loop	

reverse_text_exit:	
	pop	{r1-r4, pc}

/*
	int_to_text - convert integer to decimal text
	
	on entry:
		r0 = integer to convert
		r1 = buffer to place the text
	on exit:
		r1 = original buffer
*/
	.global int_to_text
int_to_text:
	push	{r1, r4, lr}

	// remember where the buffer starts
	mov	r4, r1

	// r2 starts with original number
	mov	r2, r0

	// r3 is the working buffer pointer
	mov	r3, r1

int_to_text_loop:
	// shift a decimal digit out of r2 into r1
	mov	r0, r2	
	bl	shift_10
	mov	r2, r0

	// convert the digit to ascii and store in buffer
	mov	r0, r1
	add	r0, #'0'
	strb	r0, [r3], #1

	// if nothing left to shift, then we're done
	cmp	r2, #0
	bne	int_to_text_loop

	// store a null byte at the end of the buffer
	mov	r0, #0
	strb	r0, [r3]

	// reverse the buffer
	mov	r0, r4
	bl	reverse_text

	pop	{r1, r4, pc}

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
	push	{r4, r5, r6, lr}

	mov	r4, #10
	udiv	r5, r0, r4
	mul	r6, r5, r4
	mov	r1, r0
	sub	r1, r6
	mov	r0, r5

	pop	{r4, r5, r6, pc}


/*
	text_to_int - convert text to an integer

	on entry:
	    r1 => null-terminated text
	    
	on exit:
	    if success:
		r0 = integer
		eq = true
	    if failure:
		r0 = undefined
		eq = false	    
*/
	.global text_to_int
text_to_int:
	// initialize accumulator
	mov	r0, #0

	// constant 10 for use later
	mov	r3, #10

text_to_int_loop:
	// get the next character then bump the text pointer
	ldrb	r2, [r1], #1

	// if character is null, we're done
	cmp	r2, #0
	beq	text_to_int_end

	// verify character between '0' and '9'	
	cmp	r2, #'0'
	blt	text_to_int_end
	cmp	r2, #'9'
	bgt	text_to_int_end

	// convert ascii to binary
	sub	r2, #0x30

	// shift the accumulator left one digit
	mul	r0, r3

	// add the new digit
	add	r0, r2

	// go get the next character
	b	text_to_int_loop

text_to_int_end:
	mov	pc, lr		


/*
	copy_string

	on entry:
	    r1 => destination buffer
	    r2 => source string
	on exit:
	    undefined
*/
	.global copy_string
copy_string:
	ldrb	r0, [r2], #1
	strb	r0, [r1], #1
	cmp	r0, #0
	bne	copy_string

	mov	pc, lr

/*
	add_nl

	on entry:
	    r1 => null-terminated string
	on exit:
	    r1 is unchanged
*/
	.global add_nl
add_nl:
	push	{r1, lr}

1:
	ldrb	r0, [r1]
	cmp	r0, #0
	beq	2f

	mov	r2, r0
	add	r1, #1
	b	1b

2:
	cmp	r2, #'\n'
	beq	add_nl_exit
	
	mov	r0, #'\n'
	strb	r0, [r1],#1
	mov	r0, #0
	strb	r0, [r1]

add_nl_exit:
	pop	{r1, pc}

