add_executable(daemon
    src/main.cpp
)

target_link_libraries(daemon PRIVATE
    common
    project_deps
)
