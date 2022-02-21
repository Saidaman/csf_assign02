// C implementation of hexdump functions

#include <unistd.h>  // this is the only system header file you may include!
#include "hexfuncs.h"

// TODO: add function implementations here

unsigned hex_read(char data_buf[]) {
    unsigned bytes_read = 0;
    for (int i = 0; i < 16; i++) {
        if (read(0, &data_buf[i], 1) == 1) {
            bytes_read++;
        }
        else {
            break;
        }
    }
    return bytes_read;
}

void hex_write_string(const char s[]) {
    write(1, s, string_length(s));
}

int string_length(const char s[]) {
    int length = 0;
    while (s[length] != '\0') {
        length++;
    }
    return length;
}

void hex_format_offset(unsigned offset, char sbuf[]) {
    unsigned leading_zeros = calc_offset(offset);
    //need to add leading zeros to sbuf
    for (int i = 0; i < leading_zeros; i++) {
        sbuf[i] = '0';
    }
    //need to do calculation
    unsigned idx  = leading_zeros;
    while (idx < 8) {
        unsigned current_digit = offset;
        while (current_digit > 15) {
            current_digit = current_digit / 16;
        }
        if (current_digit > 9) {
            sbuf[idx] = (unsigned char)current_digit + '87'; //need to check if this is a safe way to convert unsinged to char
        }
        else { 
            sbuf[idx] = current_digit + '0';
        }
        offset = offset % 16;
        idx++;
    }
    sbuf[8] = '\0';
}

unsigned calc_offset(unsigned val) {
    unsigned offset = 0;
    while (val > 0) {
        val = val / 16;
        offset++;
    }
    //return the number of leading zeros for the sbuf
    return 8 - offset; 
}

void hex_format_byte_as_hex(unsigned char byteval, char sbuf[]) {
    sbuf[2] = '\0';
    int char1 = byteval / 16;
    int char2 = byteval % 16;
    if (char1 > 9) {
        sbuf[0] = char1 + '87';
    } else {
        sbuf[0] = char1 + '0';
    }
    if (char2 > 9) {
        sbuf[1] = char2 + '87';
    } else {
        sbuf[1] = char2 + '0';
    }
}

char hex_to_printable(unsigned char byteval) {
    if (byteval >= 32 && byteval <= 126) {
        return (char) byteval;
    } else {
        return '.';
    }
}
