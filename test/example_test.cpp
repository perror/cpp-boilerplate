#include "example_test.hpp"

TEST_F (ExampleTest, First_example_test) {
  EXPECT_TRUE (true);
  ASSERT_TRUE (true);
}

TEST_F (ExampleTest, Second_example_test) {
  EXPECT_TRUE (false);
  ASSERT_TRUE (true);
}

TEST_F (ExampleTest, Third_example_test) {
  EXPECT_TRUE (true);
  ASSERT_TRUE (false);
}
