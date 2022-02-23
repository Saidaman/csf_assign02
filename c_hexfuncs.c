/*
 * Implementation of C functions useful for a hexdump program.
 * CSF Assignment 2
 * Shayan Hossain, Sai Earla
 * shossa11@jhu.edu, searla1@jhu.edu
 */

// C implementation of hexdump functions

#include <unistd.h>  // this is the only system header file you may include!
#include "hexfuncs.h"

unsigned hex_read(char data_buf[]) {
    unsigned bytes_read = 0;
    for (int i = 0; i < 16; i++) {
        if (read(0, &data_buf[i], 1) == 1) {
            bytes_read++;
        } else {
            break;
        }
    }
    return bytes_read;
}

void hex_write_string(const char s[]) {
    int res = write(1, s, string_length(s));
    if (res < 0) { //error checking
        int raise(int sig);
        raise(2);
    }
}

int string_length(const char s[]) {
    int length = 0;
    while (s[length] != '\0') {
        length++;
    }
    return length;
}

void hex_format_offset(unsigned offset, char sbuf[]) {
    //Gary's suggestion from OH to make function easier
    char hexVals[] = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'};
    char *val = sbuf;
    for (int i = 28; i >= 0; i -= 4) { //need groups of 4 bits, hence decrease by 4 at a time
        int idx = (offset >> i) & 15; //& operator to isolate the values of the 4 bits
        *val = hexVals[idx]; //pointer arithmetic
        *val++;
    }
    *val = '\0';
}

void hex_format_byte_as_hex(unsigned char byteval, char sbuf[]) {
    sbuf[2] = '\0';
    int char1 = byteval / 16; //first "letter" in output
    int char2 = byteval % 16; //second "letter" in output
    if (char1 > 9) {
        sbuf[0] = char1 + 'a' - 10; //adjusting char for when it's [a, f]
    } else {
        sbuf[0] = char1 + '0'; //adjusting char for when it's [0,9]
    }
    if (char2 > 9) {
        sbuf[1] = char2 + 'a' - 10;
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
