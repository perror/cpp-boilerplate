# Required by Google-test
find_package(Threads REQUIRED)
include_directories(${GTEST_INCLUDE_DIRS})

set(PROJECT_TEST_NAME ${CMAKE_PROJECT_NAME}_test)

# Adding GTest framework
set(TEST_SRC_FILES
  main.cpp
  example_test.cpp
  )
add_executable(${PROJECT_TEST_NAME} ${TEST_SRC_FILES})
add_dependencies(${PROJECT_TEST_NAME} googletest)

target_link_libraries(${PROJECT_TEST_NAME}
  ${CMAKE_THREAD_LIBS_INIT}
  ${GTEST_LIBS_DIR}/libgtest.a
  ${GTEST_LIBS_DIR}/libgtest_main.a
  )

add_test(Example_tests ${PROJECT_TEST_NAME})
