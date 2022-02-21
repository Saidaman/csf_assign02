// C implementation of hexdump main function

#include "hexfuncs.h"  // this is the only header file which may be included!

int main(void) {
  char input[16] = "";
  char address[8] = "";
  unsigned chars_read = hex_read(input);

  //for the first iteration
  if (chars_read > 0) {
    hex_format_offset(0, address);
    printf("%s: ", address);
  }
  
  //keep repeating while there is valid input
  while (chars_read > 0) {
    hex_format_offset(chars_read, address);
    printf("%s: ", address);
    


    //update the new line of input
    chars_read = hex_read(input);
  }
}
