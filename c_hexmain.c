/*
 * Implementation of a hexdump program in C.
 * CSF Assignment 2
 * Shayan Hossain, Sai Earla
 * shossa11@jhu.edu, searla1@jhu.edu
 */

// C implementation of hexdump main function

#include "hexfuncs.h"  // this is the only header file which may be included!

int main(void) {
  char input_buf[16] = {0};
  char address[9] = "";
  char hex_digits[3] = "";
  unsigned chars_read = 0;
  unsigned bytes_read = 0;
  int need_exit = 0;

  while ((chars_read = hex_read(input_buf)) != 0) {
    //print column 1
    hex_format_offset(bytes_read, address);
    hex_write_string(address);
    hex_write_string(": "); //colon and space

    //print column 2
    for (int i = 0; i < chars_read; i++) {
      hex_format_byte_as_hex(input_buf[i], hex_digits);
      hex_write_string(hex_digits);
      hex_write_string(" ");
    }
    if (chars_read < 16) {
      //need to pad extra blank with spaces
      for (int i = 16 - chars_read; i > 0; i--) {
        //print 3 spaces
        hex_write_string("   ");
      }
      need_exit = 1; //last line of input read in
    }
    //two spaces before string representation
    hex_write_string("  ");

    for (int i = 0; i < chars_read; i++) {
      char char_to_print[2];
      char_to_print[0] = hex_to_printable(input_buf[i]);
      char_to_print[1]= '\0';
      hex_write_string(&char_to_print);
      }

      //need to add a \n before the next x bytes read in
      hex_write_string('\n');

      //last line of input where the bytes read in are < 16
      if (need_exit) {
        break;
      }
  }
}
