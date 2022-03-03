/*
 * Implementation of a hexdump program in Assembly.
 * CSF Assignment 2
 * Shayan Hossain, Sai Earla
 * shossa11@jhu.edu, searla1@jhu.edu
 */

/* Hexdump main function, assembly language version */

	.section .rodata

	sColonSpace: .string ": "
	sSpace: .string " "
	sNewLine: .string "\n"
	sNullTerminator: .string "\0"
	sThreeSpace: .string "   "

	.section .text

	.globl main
main:

	pushq %rbp
	pushq %r12 //used as loop variable for .LprintColumnTwo
	pushq %r13 //used as loop variable for .LpadWithSpaces
	pushq %r14 //used as loop variable for .LprintColumnThree

	movq %rsp, %rbp // 0(%rbp) = char input_buf[16]
					//16(%rbp) = char address[9]
					//25(%rbp) = char hex_digits[3]
					//28(%rbp) = unsigned bytes_read
					//32(%rbp) = unsigned need_exit
					//36(%rbp) = unsigned chars_read
					//40(%rbp) = char char_to_print[2]

	movq 42(%rsp), %r12 //am I doing this right?
	movq 46(%rsp), %r13 
	movq 50(%rsp), %r14

	subq $80, %rsp //stack alignment


.LmainWhileLoop:
	movq $0, %r12 //intialize loop counter for .LprintColumnTwo
	movq $16, %r13 //initialize loop counter for .LpadWithSpaces
	movq $0, %r14 //initialize loop counter for .LprintColumnThree

	movq %rbp, %rdi //moves input_buf into first argument for input into hex_read
	call hex_read 
	movq %rax, 36(%rbp) //moves the output of hex_read into %rbp + 36 (chars_read)

	cmpq $0, 36(%rbp) //compare chars_read 36(%rbp) to 0 (whether input was read in)
	je .LreturnMain // return 0 from main and end program	

// fall through
	movq 28(%rbp), %rdi //move bytes_read into the first argument register %rdi (for hex_format_offset)
	movq 16(%rbp), %rsi //move address into the second argument register %rsi
	call hex_format_offset

	movq 16(%rbp), %rdi //move address into the first argument register %rdi (for hex_write_string)
	call hex_write_string

	movq $sColonSpace, %rdi //move ": " into the first argument register %rdi (for hex_write_string)
	call hex_write_string

.LprintColumnTwo:
	movq %r12(%rbp), %rdi //move the char at position %rbp + %r12(loop index) into %rdi
	movq 25(%rbp), %rsi //move hex_digits 25(%rbp) into %rsi
	call hex_format_byte_as_hex
	movq 25(%rbp), %rdi //move hex_digits 25(%rbp) into %rdi
	call hex_write_string
	movq $sSpace, %rdi //move " " into %rdi
	call hex_write_string
	
	incq %r12 //increment the loop index by 1
	cmpq 36(%rbp), %r12 //this compares loop variable %r12 and chars_read 36(%rbp)
	jl .LprintColumnTwo //if current index < chars_read, then another iteration is done

// fall through
	cmpq $16, 36(%rbp) //checks to see if the chars read is less than 16
	subq 36(%rbp), %r13 //subtract chars_read from %r13 (initialized to 16)
	jl .LpadWithSpaces

// fall through
.LprintSpace:
	movq $sSpace, %rdi
	call hex_write_string

//fall through
.LprintColumnThree:
	movq %r14(%rbp), %rdi //moves the input_buf[i] into %rdi
	call hex_to_printable
	movq %rax, 40(%rbp) //moves return value into char_to_print[0] 40(%rbp)
	movq $sNullTerminator, 41(%rbp) //moves null terminator into char_to_print[1] 41(%rbp)
	movb 40(%rbp), $rdi //moves char_to_print[0] 40(%rbp) into %rdi
	call hex_write_string
	incq %r14 //increments the loop index by 1
	cmpq 36(%rbp), %r14 // compare the loop index to chars_read	36(%rbp)
	jl .LprintColumnThree //only iterate through loop again if index < chars_read

// fall through
	movq $sNewLine, %rdi
	call hex_write_string

	cmpq $1, 32(%rbp) //compare exit to see if it's value is 1
	je .LreturnMain //return from main if need_exit = 1

	addq $16, 28(%rbp) //add 16 to bytes_read 32(%rbp)
	jmp .LmainWhileLoop

//**End of big while loop

.LpadWithSpaces:
	movq $1, 32(%rbp) //move 1 into need_exit (signals exit from main)
	cmpq $0, %r13 // compare 0 with the loop index
	jle .LprintSpace // exit loop if loop index is <= 0
	//fall through
	movq $sThreeSpace, %rdi //move "   " into %rdi
	call hex_write_string
	decq %r13 //decrement the loop index by 1
	jmp .LpadWithSpaces //go for another iteration of the loop

.LreturnMain:
	//pop the registers in the reverse order we pushed
	popq %r14
	popq %r13
	popq %r12
	popq %rbp

	addq $80, %rsp //stack alignment
	movq $0, %rax //main function should return 0 from main
	ret

/* vim:ft=gas:
 */
