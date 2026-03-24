add_library(core STATIC
    greeter.cpp
)

target_include_directories(core
    PUBLIC
        ${PROJECT_SOURCE_DIR}/include
)

add_executable(test_clang_app
    main.cpp
)

target_link_libraries(test_clang_app
    PRIVATE
        core
)
