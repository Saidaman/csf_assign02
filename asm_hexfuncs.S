/*
 * Implementation of Assembly functions useful for a hexdump program.
 * CSF Assignment 2
 * Shayan Hossain, Sai Earla
 * shossa11@jhu.edu, searla1@jhu.edu
 */

/* Assembly language implementation of hexdump functions */

	.section .rodata

	hexArray: .string "0123456789abcdef"

	.section .text

	/* TODO: add functions here */


	.globl hex_read
hex_read:
	subq $8, %rsp //stack alignment
	pushq %r12 //loop counter
	pushq %r13 //to store the address of %rdi
	pushq %r14 //how many are read in successfully

	movq %rdi, %r13 //store the address of data_buf into %r13
	movq $0, %r12 //initalize loop counter
	movq $0, %r14 //initialize numReadSuccessfully

.LcheckRead:
	cmpq $16, %r12
	jnb .LdoneWithRead

	movq $0, %rdi //move 0 into first arg for read to signal standard input
	leaq (%r13, %r12, 1), %rsi //store data_buf + idx into second arg for read
	movq $1, %rdx //moves 1 into third arg signalling to read only 1 hex_format_byte_as_hex
	call read

	cmpq $1, %rax //need to compare 1 with the return value of read, 1 signals that a byte was successfully read in
	jne .LdoneWithRead //done with input reading

	incq %r12 //increment loop counter
	incq %r14 //increment numReadSuccessfully
	jmp .LcheckRead //for another iteration

.LdoneWithRead:
	movq %r14, %rax //move numReadSuccessfully into return register %rax
	//need to pop in reverse order
	popq %r14
	popq %r13
	popq %r12
	addq $8, %rsp //stack alignment
	ret

	.globl hex_write_string
hex_write_string:
	
	pushq %rbx
	movq %rdi, %rbx //to preserve the string in %rdi
	call string_length

	cmpq $16, %rax //compare 16 to the return value of string_length
	jnbe .LsetMaxLength
	jmp .Lcontinue

.LsetMaxLength:
	movq $16, %rax //move 16(max length) into the return register

.Lcontinue:
	//need to use write here
	movq $1, %rdi //move 1 into first arg, signalling standard output
	movq %rbx, %rsi //move the string into the second arg
	movq %rax, %rdx //move the length of the string into third arg
	call write

	popq %rbx //need to align
	ret

//helper for hex_write_string
	.globl string_length
string_length:
	subq $8, %rsp //stack alignment
	movq $0, %r9 //this will be the length of the string (to return)

.LtraverseString:
	cmpb $0, (%rdi) //checking for the null terminator
	je .LdoneCheck

	incq %r9 //increment the string length counter
	addq $1, %rdi //move 1 index through the string for next loop iteration
	jmp .LtraverseString

.LdoneCheck:
	movq %r9, %rax //move the string length to the return register
	addq $8, %rsp //stack alignment
	ret

	.globl hex_format_offset //need to annotate this function with comments
hex_format_offset:
	pushq %r12 
	pushq %r13
	movq %rdi, %rdx 
	movq %rdx, %r9 
	movq %rsi, %r10
	movq $3, %r12 
	movq $0, %r8 
	movq $24, %r13
	cmp $0, %r12
	jl .LdoneOffset 

	.Lloop:
	movq %r9, %rdx
	cmp $24, %r13 
	je .LtwentyFour
	cmp $16, %r13
	je .LsixTeen
	cmp $8, %r13 
	je .Leight

	jmp .LandOperator 

.LtwentyFour:
	shrq $24, %rdx 
	jmp .LandOperator
.LsixTeen:
	shrq $16, %rdx
	jmp .LandOperator
.Leight:
	shrq $8, %rdx 
	jmp .LandOperator

.LandOperator:
	movq %rdx, %rcx 
	andq $0xFF, %rcx 
	movq %rcx, %rdi 
	leaq (%r10, %r8, 2), %rsi 

	push %rdx
	push %r10
	push %rcx
	push %r8

	call hex_format_byte_as_hex

	pop %r8
	pop %rcx
	pop %r10
	pop %rdx

	subq $1, %r12 
	addq $1, %r8 

	subq $8, %r13

	cmp $0, %r12 
	jl .LdoneOffset 

	jmp .Lloop

.LdoneOffset:
	addq $1, %r8 /* advance the index by one more, at index 8 */
	movb $0, (%r10, %r8, 2) /* adding null terminator at end of 8 char sbuf */
	
	popq %r13 /* restoring original value of %r13 */
	popq %r12 /* restoring original value of %r12 */

	ret
	

	.globl hex_format_byte_as_hex
hex_format_byte_as_hex:
	subq $8, %rsp //stack alignment

	movq $0, 2(%rsi) //storing null character in last position of input array

	movq %rdi, %rax //copying input char value
	
	shrq $4, %rdi //right shift input value 4 places for first four bits - gives us char1
	andq $0xf, %rax //& operator for last 4 bits - gives us char2

	cmpq $9, %rdi //comparing "char1" with 9 like from C implementation 
	ja .LadjustChar1 //going into if statement for char1 like in C implementation

	addq $48, %rdi //this is the else part for char1 to add '0' like in C implementation
	jmp .Lchar1Adjusted //jumps to second if-else block like in C implementation

//adding 'a' and subtracting 10 from char1 like in C implementation
.LadjustChar1:
	addq $97, %rdi //adding 'a' like in C implementation (ascii value of 'a' is 97)
	subq $10, %rdi //subtracting 10 like in C implementation

//this is the second if-else block for char2 like in C implementation	
.Lchar1Adjusted:
	cmpq $9, %rax //comparing char2 with 9
	ja .LadjustChar2 //if char2 > 9

	addq $48, %rax //else (when char2 <= 9)
	jmp .Lchar2Adjusted //indicates both chars have been adjusted and are ready to be put into sbuf

//adding 'a' and subtracting 10 from char2 like in C implementation
.LadjustChar2:
	addq $97, %rax //adding 'a' like in C implementation
	subq $10, %rax //subtracting 10 like in C implementation

//At this point, both chars have had the necessary adjustments from the "if-else" blocks above and
//are ready to be put into sbuf
.Lchar2Adjusted:
	movq %rdi, (%rsi) //first element in sbuf is char1
	movq %rax, 1(%rsi) //second element in sbuf is char2

    addq $8, %rsp //stack alignment
	ret

	.globl hex_to_printable
hex_to_printable:
	subq $8, %rsp //stack alignment

	movq %rdi, %rax //store input into register %rax

	cmpq $126, %rdi //comparing input with value 126
	jbe .LcheckLowerBound //if input is <= 126, jump to check if input is >= 32

	movq $46, %rax //if input is > 126, store ascii value of '.'
	jmp .LreturnVal //return the '.' as stored in above line

.LcheckLowerBound:
	cmpq $32, %rdi //comparing input value with 32
	jae .LreturnVal //if input is >= 32, we are in printable range

	movq $46, %rax //if input is < 32, store ascii value of '.'
	jmp .LreturnVal //return the '.' as stored in above line

.LreturnVal:
	addq $8, %rsp //stack alignment
	ret

/* vim:ft=gas:
 */
