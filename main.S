	.file	"main.S"

	.data

usage_text: 		.asciz "Usage: fibonacci <count>\n"
display_buffer: 	.space 100	
life: 
			.word 0x42424242
	.text

/*
	_start - display first n fibonacci numbers

	on entry:
	    stack + 0 = parameter count
	    stack + 4 => name of program (null-terminated)
	    stack + 8 => first parameter (null-terminated)

	
*/
	.global	_start
_start:
	// parse command line, returning n in r0
	bl	parse_command_line
	bne	usage		// NE means error

	// the index (r7) starts at 1
	// r8 remembers how many numbers were requested
	mov	r7, #1
	mov	r8, r0

loop:
	// loop terminates when index (r7) > n (r8)
	cmp	r7, r8
	movgt	r0, #0
	bgt	exit

	// get the nth fibonacci number
	mov	r0, r7
	bl	fibonacci

	// convert it to text
	ldr	r1, =display_buffer
	bl	int_to_text
	bl	add_nl

	// display it
	bl	out

	// end of loop		
	add	r7, #1
	b	loop

usage:
	// display the text in usage_text
	ldr	r1, =usage_text
	bl	out

	// set return code = -1
	mov 	r0, #-1
	b	exit

exit:
	// makes system call to exit
	// assumes r0 has return code
	mov	r7, #1
	swi	0
	
