/*
 * Implementation of Assembly functions useful for a hexdump program.
 * CSF Assignment 2
 * Shayan Hossain, Sai Earla
 * shossa11@jhu.edu, searla1@jhu.edu
 */

/* Assembly language implementation of hexdump functions */

	.section .rodata

	/* TODO: add read-only data such as strings here */

	.section .text

	/* TODO: add functions here */


	.globl hex_read
hex_read:
    ret

	.globl hex_write_string
hex_write_string:
    ret

	.globl hex_format_offset
hex_format_offset:
    ret

	.globl hex_format_byte_as_hex
hex_format_byte_as_hex:
	subq $8, %rsp //stack alignment

	movq $0, 2(%rsi) //storing null character in last position of input array

	movq %rdi, %rax //copy input char value
	
	shrq $4, %rdi //char1: right shift 4 places for first four bits
	andq $0xf, %rax //char2: & operator for last 4 bits

	cmpq $9, %rdi //comparing "char1" like from C implementation with 9
	ja .LadjustChar1 //going into if statement for char1 like in C implementation

	addq $48, %rdi //this is the else part for char1 like in C implementation to add '0'
	jmp .Lchar1Adjusted //jumps to second if-else block like in C implementation

//adding 'a' and subtracting 10 from char1 like in C implementation
L.adjustChar1:
	addq $97, %rdi //adding 'a' like in C implementation
	subq $10, %rdi //subtracting 10 like in C implementation

//this is the second if-else block for char2 like in C implementation	
L.char1Adjusted:
	cmpq $9, %rax //comparing char2 with 9
	ja .LadjustChar2 //if char2 > 9

	addq $48, %rax //else (when char2 <= 9)
	jmp .Lchar2Adjusted //indicates both chars have been adjusted and are ready to be put into sbuf

//adding 'a' and subtracting 10 from char2 like in C implementation
L.adjustChar2:
	addq $97, %rax //adding 'a' like in C implementation
	subq $10, %rax //subtracting 10 like in C implementation

//At this point, both chars have had the necessary adjustments from the "if-else" blocks above and
//are ready to be put into sbuf
L.char2Adjusted:
	movq %rdi, (%rsi) //first element in sbuf is char1
	movq %rax, 1(%rsi) //second element in sbuf is char2

    addq $8, %rsp //stack alignment
	ret

	.globl hex_to_printable
hex_to_printable:
	subq $8, %rsp //stack alignment

	movq %rdi, %rcx //store input into register %rcx

	cmpq $126, %rdi //comparing input with value 126
	jbe .LcheckLowerBound //if input is <= 126, jump to check if input is >= 32

	movq $46, %rcx //if input is > 126, store ascii value of '.'
	jmp .LreturnVal //return the '.' as stored in above line

.LcheckLowerBound: //comparing input with value 32
	cmpq $32, %rdi //comparing input value with 32
	jae .LreturnVal //return input value, which is in printable range

	movq $46, %rcx //if input is < 32, store ascii value of '.'
	jmp .LreturnVal //return the '.' as stored in above line

.LreturnVal:
	addq $8, %rsp //stack alignment
	ret

/* vim:ft=gas:
 */
