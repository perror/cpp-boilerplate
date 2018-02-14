# Main CMakeList file
cmake_minimum_required (VERSION 3.5)
project (boilerplate)

# Current build modes are:
#   - Release : Normal release of the software
#   - Debug : Debug version of the software (with symbols and debug output)
#   - Tests : Add all the tests and code coverage
#   - Profile : Add all profiling options

# Default CMAKE_BUILD_TYPE
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE "Release" CACHE STRING "Release" FORCE)
endif()

# Setup 'Tests' build-mode flags
set(CMAKE_CXX_FLAGS_TESTS
    "-O0 -DDEBUG ${CMAKE_CXX_FLAGS_DEBUG}"
    CACHE STRING "Flags used by the C compiler during test builds."
    FORCE)
set(CMAKE_EXE_LINKER_FLAGS_TESTS
    "" CACHE STRING
    "Flags used for linking binaries during test builds."
    FORCE)
set(CMAKE_SHARED_LINKER_FLAGS_TESTS
    "" CACHE STRING
    "Flags used by the shared libraries linker during test builds."
    FORCE)

mark_as_advanced(
    CMAKE_CXX_FLAGS_TESTS
    CMAKE_EXE_LINKER_FLAGS_TESTS
    CMAKE_SHARED_LINKER_FLAGS_TESTS)

# Setup 'Profile' custom build-mode flags
set(CMAKE_CXX_FLAGS_PROFILE
    "-O3 -DNDEBUG"
    CACHE STRING "Flags used by the C compiler during profile builds."
    FORCE)
set(CMAKE_EXE_LINKER_FLAGS_PROFILE
    "" CACHE STRING
    "Flags used for linking binaries during profile builds."
    FORCE)
set(CMAKE_SHARED_LINKER_FLAGS_PROFILE
    "" CACHE STRING
    "Flags used by the shared libraries linker during profile builds."
    FORCE)

mark_as_advanced(
    CMAKE_CXX_FLAGS_PROFILE
    CMAKE_EXE_LINKER_FLAGS_PROFILE
    CMAKE_SHARED_LINKER_FLAGS_PROFILE)
 
# Customizing existing types of builds
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE}")
set(CMAKE_CXX_FLAGS_DEBUG "-O3 -DDEBUG ${CMAKE_CXX_FLAGS_DEBUG}")

# Update the documentation string of CMAKE_BUILD_TYPE for GUIs
SET( CMAKE_BUILD_TYPE "${CMAKE_BUILD_TYPE}" CACHE STRING
    "Choose the type of build, options are: Release Debug Tests Profile."
    FORCE )
 
# OS specific settings
if(APPLE)
  set(SYSTEM_TYPE "Darwin")
  set(CMAKE_MACOSX_RPATH ON)
elseif(UNIX)
  set(SYSTEM_TYPE "Unix/Linux")
elseif(WIN32)
  set(SYSTEM_TYPE "MS-Windows")
else()
  set(SYSTEM_TYPE "Unknown")
endif()

# Compiler specific settings
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Setup specific properties
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -std=c++11")

# Setting paths
if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  set(CMAKE_INSTALL_PREFIX "${PROJECT_SOURCE_DIR}/bin" CACHE STRING "Install path" FORCE)
endif()
set(CMAKE_INSTALL_RPATH "./")
set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake/modules)

# Install specific clang-dev-tools
include(cmake/clang-dev-tools.cmake)

# Setting include directories
include_directories("${PROJECT_SOURCE_DIR}/src" "${PROJECT_SOURCE_DIR}/include")

# External modules
set(EXT_PROJECTS_DIR "${PROJECT_SOURCE_DIR}/ext")

# Build modes
if(CMAKE_BUILD_TYPE STREQUAL "Tests")
  # Setting up the google-test framework
  include(CTest)
  set(CMAKE_BUILD_TESTS "yes")
  add_subdirectory(ext/gtest)
  add_subdirectory(test)
  # Setting up the coverage framework
  include(CodeCoverage)
  append_coverage_compiler_flags()
  setup_target_for_coverage(NAME coverage
                            EXECUTABLE ${CMAKE_PROJECT_NAME}_test
                            DEPENDENCIES ${CMAKE_PROJECT_NAME}_test)
endif()

if(CMAKE_BUILD_TYPE STREQUAL "Profile")
  set(CMAKE_BUILD_TESTS "yes")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fprofile-arcs -pg")
  include(CTest)
  add_subdirectory(ext/gtest)
  add_subdirectory(test)
endif()

# Building project
add_subdirectory(src)
add_subdirectory(doc)

# Display current configuration
message("-- -------------------- --")
message("** Configuration Summary **")
message("-- Project:     ${CMAKE_PROJECT_NAME}")
message("-- OS type:     ${SYSTEM_TYPE}")
message("-- Build type:  ${CMAKE_BUILD_TYPE}")
message("-- Build tests:  ${CMAKE_BUILD_TESTS}")
message("-- -------------------- --")
message("-- C++ Compiler:     ${CMAKE_CXX_COMPILER}")
message("-- CFLAGS:           ${CMAKE_CXX_FLAGS}")
message("-- CFLAGS (Release): ${CMAKE_CXX_FLAGS_RELEASE}")
message("-- CFLAGS (Debug):   ${CMAKE_CXX_FLAGS_DEBUG}")
message("-- CFLAGS (Tests):   ${CMAKE_CXX_FLAGS_TESTS}")
message("-- CFLAGS (Profile): ${CMAKE_CXX_FLAGS_PROFILE}")
message("-- LDFLAGS (exe):    ${CMAKE_EXE_LINKER_FLAGS}")
message("-- LDFLAGS (shared): ${CMAKE_SHARED_LINKER_FLAGS}")
message("-- LDFLAGS (static): ${CMAKE_SHARED_LINKER_FLAGS}")
message("-- -------------------- --")
message("-- Source dir: ${PROJECT_SOURCE_DIR}")
message("-- Binary dir: ${PROJECT_BINARY_DIR}")
message("-- -------------------- --")

