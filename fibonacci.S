	.file	"fibonacci.S"

	.data

usage_text:
	.ascii	"Usage: fibonacci <count>\n"

display_buffer:
	.space	100

	.text	
	
	.global	system
system:
	bl	parse_command_line
	.global fibonacci
fibonacci:
	push	{r4,r5,lr}
	cmp	r0, #2
	ble	fibonacci_exit

	mov	r4, r0
	sub	r0, #1
	bl	fibonacci
	mov	r5, r0
	mov	r0, r4
	sub	r0, #2
	bl	fibonacci
	add	r0, r5
	
fibonacci_exit:
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

	// if failure during parse, Z is already off

parse_command_line_exit:	
 	pop	{pc}	

