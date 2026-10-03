rm -rf build-$1
mkdir build-$1
cmake --preset $1
cmake --build --preset $1
