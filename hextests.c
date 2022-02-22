/*
 * Testing implementation of functions useful for a hexdump program.
 * CSF Assignment 2
 * Shayan Hossain, Sai Earla
 * shossa11@jhu.edu, searla1@jhu.edu
 */

// Unit tests for hex functions
// These tests should work for both your C implementations and your
// assembly language implementations

#include <stdio.h>
#include <stdlib.h>
#include "tctest.h"
#include "hexfuncs.h"

// test fixture object
typedef struct {
  char test_data_1[16];
} TestObjs;

// setup function (to create the test fixture)
TestObjs *setup(void) {
  TestObjs *objs = malloc(sizeof(TestObjs));
  strcpy(objs->test_data_1, "Hello, world!\n");
  return objs;
}

// cleanup function (to destroy the test fixture)
void cleanup(TestObjs *objs) {
  free(objs);
}

// Prototypes for test functions
void testFormatOffset(TestObjs *objs);
void testFormatByteAsHex(TestObjs *objs);
void testHexToPrintable(TestObjs *objs);

int main(int argc, char **argv) {
  if (argc > 1) {
    tctest_testname_to_execute = argv[1];
  }

  TEST_INIT();

  TEST(testFormatOffset);
  TEST(testFormatByteAsHex);
  TEST(testHexToPrintable);

  TEST_FINI();

  return 0;
}

void testFormatOffset(TestObjs *objs) {
  (void) objs; // suppress warning about unused parameter
  char buf[16];
  hex_format_offset(1L, buf);
  ASSERT(0 == strcmp(buf, "00000001"));

  hex_format_offset(16, buf);
  ASSERT(0 == strcmp(buf, "00000010"));

  hex_format_offset(17, buf);
  ASSERT(0 == strcmp(buf, "00000011"));

  hex_format_offset(10, buf);
  ASSERT(0 == strcmp(buf, "0000000A"));


}

void testFormatByteAsHex(TestObjs *objs) {
  char buf[16];
  hex_format_byte_as_hex(objs->test_data_1[0], buf);
  ASSERT(0 == strcmp(buf, "48"));
  
  hex_format_byte_as_hex(0, buf);
  ASSERT(0 == strcmp(buf, "00"));

  hex_format_byte_as_hex(255, buf);
  ASSERT(0 == strcmp(buf, "ff"));

  hex_format_byte_as_hex(187, buf);
  ASSERT(0 == strcmp(buf, "bb"));

  hex_format_byte_as_hex(16, buf);
  ASSERT(0 == strcmp(buf, "10"));

  hex_format_byte_as_hex(32, buf);
  ASSERT(0 == strcmp(buf, "20"));

  hex_format_byte_as_hex(48, buf);
  ASSERT(0 == strcmp(buf, "30"));

  hex_format_byte_as_hex(69, buf);
  ASSERT(0 == strcmp(buf, "45"));

  hex_format_byte_as_hex(150, buf);
  ASSERT(0 == strcmp(buf, "96"));

  hex_format_byte_as_hex(87, buf);
  ASSERT(0 == strcmp(buf, "57"));

  hex_format_byte_as_hex(15, buf);
  ASSERT(0 == strcmp(buf, "0f"));

  hex_format_byte_as_hex(30, buf);
  ASSERT(0 == strcmp(buf, "1e"));

  hex_format_byte_as_hex(58, buf);
  ASSERT(0 == strcmp(buf, "3a"));

  hex_format_byte_as_hex(247, buf);
  ASSERT(0 == strcmp(buf, "f7"));
}

void testHexToPrintable(TestObjs *objs) {
  hex_write_string(hex_to_printable(objs->test_data_1[0]));
  ASSERT('H' == hex_to_printable(objs->test_data_1[0]));
  ASSERT('.' == hex_to_printable(objs->test_data_1[13]));
  
  //Only values in [32, 126] range are printable
  ASSERT((char) 32 == hex_to_printable(32));
  ASSERT((char) 33 == hex_to_printable(33));
  ASSERT((char) 56 == hex_to_printable(56));
  ASSERT((char) 63 == hex_to_printable(63));
  ASSERT((char) 79 == hex_to_printable(79));
  ASSERT((char) 101 == hex_to_printable(101));
  ASSERT((char) 103 == hex_to_printable(103));
  ASSERT((char) 125 == hex_to_printable(125));
  ASSERT((char) 126 == hex_to_printable(126));

  //Values outside of [32, 126] range return '.'
  ASSERT(hex_to_printable(31) == '.');
  ASSERT(hex_to_printable(127) == '.');
  ASSERT(hex_to_printable(0) == '.');
  ASSERT(hex_to_printable(255) == '.');
  ASSERT(hex_to_printable(201) == '.');
  ASSERT(hex_to_printable(-5) == '.');
  ASSERT(hex_to_printable(176) == '.');
  ASSERT(hex_to_printable(19) == '.');
  ASSERT(hex_to_printable(420) == '.');
  ASSERT(hex_to_printable(21) == '.');
}
