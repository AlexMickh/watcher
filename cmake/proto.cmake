function(generate_proto)
    cmake_parse_arguments(ARG "" "TARGET;DIR" "PROTOS" ${ARGN})

    set(_proto_dir "${ARG_DIR}")
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
                --proto_path=${_proto_dir}
                --cpp_out=${CMAKE_CURRENT_BINARY_DIR}/generated
                --grpc_out=${CMAKE_CURRENT_BINARY_DIR}/generated
                --plugin=protoc-gen-grpc=${GRPC_CPP_PLUGIN}
                ${_proto_dir}/${_proto}
            DEPENDS ${_proto_dir}/${_proto}
            COMMENT "Генерация gRPC кода для ${_proto}"
        )

        list(APPEND _generated_files ${_cpp_file} ${_grpc_file})
    endforeach()

    target_sources(${ARG_TARGET} PRIVATE ${_generated_files})
    target_include_directories(${ARG_TARGET} PRIVATE "${CMAKE_CURRENT_BINARY_DIR}/generated")
endfunction()

