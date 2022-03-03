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
	movl $0, %r10d //bytes_read

.LreadLoop:
	movq %rdi, %rsi //second argument of syscall
	movl $0, %edi //first argument of syscall
	movl $1, %edx //third argument of syscall
	movl $0, %eax //telling syscall we want to read
	syscall //reading
	addq $1, %rsi //pointer arithmetic to traverse array
	cmpl $1, %eax //output of syscall compared with how many bytes we want read
	jne .Ldone //when it's not equal to
	incl %r10d //increment bytes_read
	jmp .LreadLoop //another iteration of the read loop

.LdoneReading:
	addq $8, %rsp //stack alignment
	movl %r10d, %eax //ensuring bytes_read is the value being returned
    ret

	.globl hex_write_string
hex_write_string:
	subq $8, %rsp //stack alignment
	movl $1, %edi //first argument of write function
	movq %rdi, %rsi //second argument of write function
	call strLen //third argument of syscall (stored in %eax)
	movl %eax, %edx //moving result from line above into third argument register	
	movl $1, %eax //telling syscall we want to write
	syscall //writing
	cmpl $0, %eax

.LdoneWriting:	
	addq $8, %rsp //stack alignment
    ret

/*
 * Determine the length of specified character string.
 *
 * Parameters:
 *   s - pointer to a NUL-terminated character string
 *
 * Returns:
 *    number of characters in the string
 */
	.globl strLen
strLen:
	subq $8, %rsp                 /* adjust stack pointer */
	movq $0, %r10                 /* initial count is 0 */

.LstrLenLoop:
	cmpb $0, (%rdi)               /* found NUL terminator? */
	jz .LstrLenDone               /* if so, done */
	inc %r10                      /* increment count */
	inc %rdi                      /* advance to next character */
	jmp .LstrLenLoop              /* continue loop */

.LstrLenDone:
	movq %r10, %rax               /* return count */
	addq $8, %rsp                 /* restore stack pointer */
	ret

	.globl hex_format_offset //need to annotate this function with comments
hex_format_offset:
	subq $8, %rsp //stack alignment
	movq %rsi, %r8
	movq $28, %r9
.LoffsetLoop:
	cmpq $0, %r9
	jl .LdoneOffset
	movq %rdi, %r10
	shrq (%r9), %r10
	andq $15, %r10
	movq $hexArray, %r11
	movb (%r11, %r10, 1), %cl
	movb %cl, (%r8)
	incq %r8
	subq $4, %r9
	jmp .LoffsetLoop

.LdoneOffset:
	movb $0, (%r9)
	addq $8, %rsp //stack alignment	
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
