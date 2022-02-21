// C implementation of hexdump main function

#include "hexfuncs.h"  // this is the only header file which may be included!

int main(void) {
  char input[17] = "";
  char address[9] = "";
  char hexVal[2] = "";
  input[17] = '\0';
  address[9] = '\0';
  unsigned chars_read = hex_read(input);

  //for the first iteration, where the address must be 0
  if (chars_read > 0) {
    hex_format_offset(0, address);
    //print position: column 1
    hex_write_string(address);
    hex_write_string(" "); //empty space?
    //print ASCII values
    for (int i = 0; i < chars_read; i++) {
      hex_format_byte_as_hex(input[i], hexVal);
      hex_write_string(hexVal);
      hex_write_string(" ");
    }
    //need to print empty space for last line?
    //print string representation of data
    
  }
  
  chars_read = hex_read(input);
  //keep repeating while there is valid input
  while (chars_read > 0) {
    hex_format_offset(chars_read, address);
    //printf("%s: ", address); can't have printf
    


    //update the new line of input
    chars_read = hex_read(input);
  }
}
