cmake_minimum_required(VERSION 3.25)
project(watcher VERSION 0.0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

if(CMAKE_SOURCE_DIR STREQUAL CMAKE_BINARY_DIR)
    message(FATAL_ERROR "In-source build запрещён. Создайте директорию build/.")
endif()

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

find_package(Protobuf CONFIG REQUIRED)
find_package(gRPC CONFIG REQUIRED)

# Экспортируем пути к плагинам, чтобы использовать в макросах
set(PROTOC $<TARGET_FILE:protobuf::protoc> CACHE FILEPATH "protoc executable")
set(GRPC_CPP_PLUGIN $<TARGET_FILE:gRPC::grpc_cpp_plugin> CACHE FILEPATH "gRPC C++ plugin")

# Подключаем общий макрос для генерации .proto
include(proto)

# Общие библиотеки
add_subdirectory(common)

# Подпроекты
add_subdirectory(daemon)
# add_subdirectory(server)
# add_subdirectory(client)

