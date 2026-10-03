add_library(common STATIC
    src/test.cpp
)

target_include_directories(common PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)

# Публично линкуем gRPC/Protobuf: транзитивно подтянется во все подпроекты
target_link_libraries(common PUBLIC
    gRPC::grpc++
    protobuf::libprotobuf
)

# Генерируем код из общих .proto
generate_proto(
    TARGET common
    PROTOS api.proto
    DIR ${CMAKE_CURRENT_SOURCE_DIR}/proto
)

