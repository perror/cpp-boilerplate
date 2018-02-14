# Additional targets to perform clang-format/clang-tidy
# Get all project source files
file(GLOB_RECURSE ALL_SOURCE_FILES
  ${PROJECT_SOURCE_DIR}/src/*.cpp
  ${PROJECT_SOURCE_DIR}/include/*.hpp
  )

message(ALL_SOURCE_FILES)

# Adding clang-format target if executable is found
find_program(CLANG_FORMAT "clang-format")
if(CLANG_FORMAT)
  add_custom_target(
    clang-format
    COMMAND /usr/bin/clang-format
    -i
    -style=file
    ${ALL_SOURCE_FILES}
    )
endif()

# Adding clang-tidy target if executable is found
find_program(CLANG_TIDY "clang-tidy")
if(CLANG_TIDY)
  add_custom_target(
    clang-tidy
    COMMAND /usr/bin/clang-tidy
    ${ALL_SOURCE_FILES}
    -config=''
    --
    -std=c++11
    -I${CMAKE_SOURCE_DIR}/include
    )
endif()
