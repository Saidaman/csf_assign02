// C implementation of hexdump main function

#include "hexfuncs.h"  // this is the only header file which may be included!

int main(void) {
  char input[16] = "";
  char address[8] = "";
  unsigned chars_read = hex_read(input);

  //for the first iteration, where the address must be 0
  if (chars_read > 0) {
    hex_format_offset(0, address);
    //print position: column 1
    printf("%s: ", address);
    //print ASCII values
    for (int i = 0; i < chars_read; i++) {
      printf("%u ", hex_to_printable(input[i]));
    }
    //need to print empty space for last line?
    //print string representation of data
    
  }
  
  chars_read = hex_read(input);
  //keep repeating while there is valid input
  while (chars_read > 0) {
    hex_format_offset(chars_read, address);
    printf("%s: ", address);
    


    //update the new line of input
    chars_read = hex_read(input);
  }
}
