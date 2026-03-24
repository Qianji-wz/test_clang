cmake_minimum_required(VERSION 3.16)

project(test_clang VERSION 0.1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

add_subdirectory(src)

enable_testing()
add_test(NAME app_runs COMMAND test_clang_app)
