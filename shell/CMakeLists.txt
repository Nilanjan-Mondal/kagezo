cmake_minimum_required(VERSION 3.10)
project(kagezo)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

include_directories(include)
file(GLOB SOURCES src/*.cpp)

add_executable(kagezo ${SOURCES})

target_compile_options(kagezo PRIVATE -Wall -Wextra -Wpedantic)

install(TARGETS kagezo DESTINATION bin)

