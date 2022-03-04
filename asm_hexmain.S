/*
 * Implementation of a hexdump program in Assembly.
 * CSF Assignment 2
 * Shayan Hossain, Sai Earla
 * shossa11@jhu.edu, searla1@jhu.edu
 */

/* Hexdump main function, assembly language version */

	.section .rodata

	sColon: .string ":"
	sSpace: .string " "
	sNewLine: .string "\n"
	sNullTerminator: .string "\0"
	sThreeSpace: .string "   "

	.section .bss

	input_buf: .space 16
	offset: .space 9
	hex_digits: .space 2
	chars_to_print: .space 2

	.section .text

	.globl main
main:

	subq $8, %rsp //stack alignment

	pushq %rbx //a loop counter for writing bytes
	pushq %rbp //loop variable
	pushq %r12
	pushq %r13
	pushq %r14 
	pushq %r15 

	movq $0, %r12 //this will store the address of different arrays throughout
	movq $0, %r13 //need_exit, will be changed to 1 if its the last iteration of while loop
	movq $0, %r14 //chars_read value
	movq $0, %r15 //offset value
	
.LmainWhileLoop:
	cmpq $0, %r13
	je .LreturnMain //if need_exit != 0, then we need to exit main

	movq $input_buf, $rdi //moves the input_buf into the first arg %rdi
	movq %rdi, %r12 //this will save the address of input_buf
	call hex_read

	movq %rax, %r14 //store the return value of hex_read into chars_read
	cmpq $0, %rax //need to see if the return value (chars_read) = 0
	je .LreturnMain //need to exit main if so

	cmpq $16, %r14 //checks to see if we read in the full 16 bytes
	jnb .LContinueWithoutFlaggingEnd
//fall through
	addq $1, %r13 //this signals for this iteration to be the last (need_exit = 1)

.LContinueWithoutFlaggingEnd:
	movq %r15, %rdi //move offset value into first arg
	movq %offset, %rsi //stores the offset string into the second arg
	movq %rsi, %r12 //this will save the address of offset
	call hex_format_offset

	movq %r12, %rdi //store the offset string into the first arg
	call hex_write_string

	addq $16, %r15 //***this increments offset value by 16 for next iteration

	movq $sColon, %rdi //move ":" into first arg
	call hex_write_string

	movq $0, %rbx //this will be the loop counter for the following loop

//this will print as bytes all the bytes read in during this iteration
.LprintBytes:
	cmpq %r14 , %rbx //this will compare the bytes printed to chars_read
	jnb .LdonePrintingBytes

	movq $sSpace, %rdi //moves " " to first arg
	call hex_write_string

	movq $input_buf, %rdi //moves input_buf into the first arg
	movzbq (%rdi, %rbx, 1), %rdi //this will index into the "ith" position of input_buf
	movq $hex_digits, %rsi //moves hex_digits into the second arg
	call hex_format_byte_as_hex

	movq $hex_digits, %rdi //move changed hex_digits into the first arg
	call hex_write_string

	incq %rbx //increment loop variable by one
	jmp .LprintBytes

.LdoneWritingBytes:
	movq $0, %rbx //%rbx will now be the loop counter for padding
	movq $16, %rbp //initialize padding count to 16
	subq %r14, %rbp //stores how many much padding will be needed

.LprintPadding:
	cmpq %rbp, %rbx //this will compare the ammount padded to the ammount needing padding
	jnb .LdonePadding

	//print " " three times
	movq $sSpace, %rdi //move " " into first arg
	call hex_write_string
	movq $sSpace, %rdi
	call hex_write_string
	movq $sSpace, %rdi
	call hex_write_string

	incq %rbx //increment loop counter by 1
	jmp .LprintPadding

.LdonePadding:
	//print " " two times
	movq $sSpace, %rdi //move " " into first arg
	call hex_write_string
	movq $sSpace, %rdi
	call hex_write_string

	movq $0, %rbx //%rbx will be the loop counter for string representation printing loop

.LprintStringRep:
	cmpq %r14, %rbx
	jnb .LdoneStringRep

	movq $input_buf, %rdi //move input_buf into first arg
	movzbq (%rbx, %rdi), %rdi //this will index into the "ith" position of input_buf
	call hex_to_printable

	movq $char_to_print, %rdi //move char_to_print to first arg
	movb %al, (%rdi) //move return 8-bit value into char_to_print[0], as input into first arg
	movb $0, 1(%rdi) //move null terminator into char_to_print[0], as input into first arg
	call hex_write_string

	incq %rbx //increment loop counter by one
	jmp .LprintStringRep

.LdoneStringRep:
	movq $sNewLine, %rdi //move "\n" into the first arg
	call hex_write_string

	jmp .LmainWhileLoop	//another iteration of while loop

.LreturnMain:

	//need to pop in the reverse order they are pushed initially
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbp
	popq %rbx

	addq $8, %rsp //stack alignment
	movq $0, %rax //sets return value of main as 0
	ret

/* vim:ft=gas:
 */