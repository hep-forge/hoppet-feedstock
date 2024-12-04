#! /usr/bin/bash

cmake -S . -B build -DCMAKE_INSTALL_PREFIX=$PREFIX

cmake --build  build -j$(nproc)
cmake --install build

rm ${PREFIX}/lib/libhoppet*.a
ctest --test-dir build
