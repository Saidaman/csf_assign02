// C implementation of hexdump functions

#include <unistd.h>  // this is the only system header file you may include!
#include "hexfuncs.h"

// TODO: add function implementations here

unsigned hex_read(char data_buf[]) {
    //TODO
    assert(0);
    return;
}

void hex_write_string(const char s[]) {
    write(1, s, strlen(s));
}

void hex_format_offset(unsigned offset, char sbuf[]) {
    //TODO
    assert(0);
    return;
}

void hex_format_byte_as_hex(unsigned char byteval, char sbuf[]) {
    sbuf[2] = '\0';
    int char1 = byteval / 16;
    int char2 = byteval % 16;
    if (char1 > 9) {
        sbuf[0] = (char) char1 + 87;
    } else {
        sbuf[0] = (char) char1;
    }
    if (char2 > 9) {
        sbuf[1] = (char) char2 + 87;
    } else {
        sbuf[1] = (char) char2;
    }
}

char hex_to_printable(unsigned char byteval) {
    //TODO
    assert(0);
    return;
}