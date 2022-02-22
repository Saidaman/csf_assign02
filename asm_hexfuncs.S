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
