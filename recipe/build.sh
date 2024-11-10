#! /usr/bin/bash

./configure --prefix=${PREFIX}

make -j$(nproc)
make check

make install
make install-mod
