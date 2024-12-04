#! /usr/bin/bash

mkdir build

cmake -S . -B build -DCMAKE_INSTALL_PREFIX=$PREFIX

cmake --build  build -j$(nproc)
cmake --install build

ctest --test-dir build
