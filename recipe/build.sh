#! /usr/bin/bash

FFLAGS="-std=legacy" ./configure --prefix=${PREFIX}

make -j$(nproc)
make check

make install
make install-mod

rm ${PREFIX}/lib/libhoppet_v1.a
