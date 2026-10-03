function(generate_proto_lib)
    cmake_parse_arguments(ARG "" "NAME;DIR" "PROTOS" ${ARGN})

    set(_generated_files "")

    foreach(_proto ${ARG_PROTOS})
        get_filename_component(_proto_name ${_proto} NAME_WE)
        set(_cpp_file  "${CMAKE_CURRENT_BINARY_DIR}/generated/${_proto_name}.pb.cc")
        set(_hdr_file  "${CMAKE_CURRENT_BINARY_DIR}/generated/${_proto_name}.pb.h")
        set(_grpc_file "${CMAKE_CURRENT_BINARY_DIR}/generated/${_proto_name}.grpc.pb.cc")
        set(_grpc_hdr  "${CMAKE_CURRENT_BINARY_DIR}/generated/${_proto_name}.grpc.pb.h")

        add_custom_command(
            OUTPUT ${_cpp_file} ${_hdr_file} ${_grpc_file} ${_grpc_hdr}
            COMMAND ${CMAKE_COMMAND} -E make_directory "${CMAKE_CURRENT_BINARY_DIR}/generated"
            COMMAND ${PROTOC}
                --proto_path=${ARG_DIR}
                --cpp_out=${CMAKE_CURRENT_BINARY_DIR}/generated
                --grpc_out=${CMAKE_CURRENT_BINARY_DIR}/generated
                --plugin=protoc-gen-grpc=${GRPC_CPP_PLUGIN}
                ${ARG_DIR}/${_proto}
            DEPENDS ${ARG_DIR}/${_proto}
            COMMENT "Генерация gRPC кода для ${_proto}"
        )

        list(APPEND _generated_files ${_cpp_file} ${_grpc_file})
    endforeach()

    add_library(${ARG_NAME} STATIC ${_generated_files})

    target_include_directories(${ARG_NAME} PUBLIC
        "${CMAKE_CURRENT_BINARY_DIR}/generated"   # для сгенерированных заголовков
        "${ARG_DIR}"                              # чтобы #include "api.proto"-импорты резолвились
    )

    target_link_libraries(${ARG_NAME} PUBLIC
        gRPC::grpc++
        protobuf::libprotobuf
    )
endfunction()


