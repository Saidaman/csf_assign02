// C implementation of hexdump functions

#include <unistd.h>  // this is the only system header file you may include!
#include "hexfuncs.h"

// TODO: add function implementations here

unsigned hex_read(char data_buf[]) {
    unsigned bytes_read = 0;
    for (int i = 0; i < 16; i++) {
        if (read(0, &data_buf[i], 1) == 1) bytes_read++;
        else break;
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
    //TODO
    assert(0);
    return;
}

void hex_format_byte_as_hex(unsigned char byteval, char sbuf[]) {
    //TODO
    assert(0);
    return;
}

char hex_to_printable(unsigned char byteval) {
    //TODO
    assert(0);
    return;
}