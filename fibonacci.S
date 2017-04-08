	.file	"fibonacci.S"

	.text	
/*
	fibonacci - calculate the nth fibonacci number

	on entry:
	    r0 = n
	on exit:
	    r0 = nth fibonacci number	
*/
	.global fibonacci
fibonacci:
	// we're going to use r4 and r5, so save them
	// also save the return address
	push	{r4,r5,lr}

	// handle edge case of first two numbers
	cmp	r0, #2
	blt	fibonacci_exit

	// remember n
	mov	r4, r0

	// get fibonacci for n-1
	sub	r0, #1
	bl	fibonacci

	// save it
	mov	r5, r0

	// get fibonacci for n-2
	mov	r0, r4
	sub	r0, #2
	bl	fibonacci

	// add fibonacci(n-1) to fibonacci(n-2)
	add	r0, r5
	
fibonacci_exit:
	// restore the non-volatile registers
	// restore lr directly into pc
	pop	{r4,r5,pc}

	
/*
	parse_command_line - get count from command line

	on entry:
	    stack + 0 = parameter count
	    stack + 4 => name of program (null-terminated)
	    stack + 8 => first parameter (null-terminated)
	on exit:
	    Z if successful, NZ if failure
	    r0 = count if Z
*/

	.global parse_command_line		
parse_command_line:
	push	{lr}	// this adds 4 to the offsets

	// make sure there is at least 1 parameter beyond prog name
	ldr	r0, [sp, #4]
	cmp	r0, #2
	blt	parse_command_line_exit	

	// parse parameter 1 (prog name is parameter 0)
	ldr	r1, [sp, #12]
	bl	text_to_int

parse_command_line_exit:	
	// if failure during parse, Z is already off
 	pop	{pc}	

