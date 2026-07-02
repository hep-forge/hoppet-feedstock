#! /usr/bin/bash

cmake -S . -B build -DCMAKE_INSTALL_PREFIX=$PREFIX

NPROC=$(nproc 2>/dev/null || sysctl -n hw.ncpu)
cmake --build  build -j$NPROC
cmake --install build

#rm ${PREFIX}/lib/libhoppet*.a
ctest --test-dir build --rerun-failed --output-on-failure