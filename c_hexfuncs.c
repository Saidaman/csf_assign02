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
    //TODO
    assert(0);
    return;
}

char hex_to_printable(unsigned char byteval) {
    //TODO
    assert(0);
    return;
}