generate_proto_lib(
    NAME common_proto
    PROTOS api.proto
    DIR ${CMAKE_CURRENT_SOURCE_DIR}/proto
)

add_library(common STATIC
    src/test.cpp
)

target_include_directories(common PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)
target_link_libraries(common PUBLIC common_proto)

