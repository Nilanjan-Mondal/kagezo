cmake_minimum_required(VERSION 3.10)
project(Kagezo)

# Set C++ Standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# Define source and header directories
include_directories(include)
file(GLOB SOURCES src/*.cpp)

# Create the executable
add_executable(kagezo ${SOURCES})

# Enable extra warnings
target_compile_options(kagezo PRIVATE -Wall -Wextra -Wpedantic)

# Install target (optional)
install(TARGETS kagezo DESTINATION bin)

