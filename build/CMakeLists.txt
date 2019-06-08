cmake_minimum_required(VERSION 2.8)
project(cpsl)

find_package(BISON)
find_package(FLEX)

bison_target(Parser ../cpsl_frontend.y ${CMAKE_CURRENT_BINARY_DIR}/cpsl_parser.c COMPILE_FLAGS "--graph")
flex_target(Scanner ../cpsl_frontend.l ${CMAKE_CURRENT_BINARY_DIR}/cpsl_scanner.c)
add_flex_bison_dependency(Scanner Parser "../parse_tree.h")

set(CMAKE_C_STANDARD 11)
set(EXTRA_COMPILE_FLAGS "-g3")

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${EXTRA_COMPILE_FLAGS}")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS}")

set(cpsl_srcs
    ../parse_tree.h
    ../parse_tree.c
    ../symbol_table.h
    ../symbol_table.c
    ../preprocess.h
    ../preprocess.c
    ../error.h
    ../error.c
    ../register_pool.h
    ../register_pool.c
    ../main.c
    ${BISON_Parser_OUTPUTS}
    ${FLEX_Scanner_OUTPUTS}
)
source_group("CPSL Compiler" FILES ${cpsl_srcs})

add_executable(cpsl ${cpsl_srcs})
target_link_libraries(cpsl ${FLEX_LIBRARIES} ${BISON_LIBRARIES})
target_include_directories(cpsl PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
