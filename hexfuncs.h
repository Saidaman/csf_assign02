/*
 * Header file of C functions useful for a hexdump program.
 * CSF Assignment 2
 * Shayan Hossain, Sai Earla
 * shossa11@jhu.edu, searla1@jhu.edu
 */

// Function prototypes for hexdump functions
// Do not change these!

#ifndef HEXFUNCS_H
#define HEXFUNCS_H

// Read up to 16 bytes from standard input into data_buf.
// Returns the number of characters read.
unsigned hex_read(char data_buf[]);

// Write given nul-terminated string to standard output.
void hex_write_string(const char s[]);

// Returns the length of a given char array (string).
// Helper function for hex_write_string.
int string_length(const char s[]);

// Format an unsigned value as an offset string consisting of exactly 8
// hex digits.  The formatted offset is stored in sbuf, which must
// have enough room for a string of length 8.
void hex_format_offset(unsigned offset, char sbuf[]);

// Calculate the number of leading zeros for the sbuf in hex_format_offset.
// Helper function for hex_format_offset.
unsigned calc_offset(unsigned val);

// Format a byte value (in the range 0-255) as string consisting
// of two hex digits.  The string is stored in sbuf.
void hex_format_byte_as_hex(unsigned char byteval, char sbuf[]);

// Convert a byte value (in the range 0-255) to a printable character
// value.  If byteval is already a printable character, it is returned
// unmodified.  If byteval is not a printable character, then the
// ASCII code for '.' should be returned.
char hex_to_printable(unsigned char byteval);

#endif // HEXFUNCS_H
