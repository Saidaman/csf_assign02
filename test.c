#include<stdio.h>
#include "hexfuncs.h"

int main () {
    hex_write_string("hellowrite");
    char databuf[] = "helloread";
    hex_read(databuf);
}