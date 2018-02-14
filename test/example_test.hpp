#ifndef EXAMPLE_TEST_HPP
#define EXAMPLE_TEST_HPP

#include "gtest/gtest.h"

class ExampleTest : public ::testing::Test {
protected:
  ExampleTest () {};
  virtual ~ExampleTest () {};
};

#endif /* EXAMPLE_TEST_HPP */
