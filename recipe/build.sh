#! /usr/bin/bash
set -e

NPROC=$(nproc 2>/dev/null || sysctl -n hw.ncpu)

case "$PKG_VERSION" in
  1.2.0)
    # Pre-CMake era: a hand-rolled Perl ./configure generates a
    # per-directory makefile via scripts/makef95makefile. FC=/FFLAGS=
    # are recognized as trailing configure args (not --flags); passing
    # our full conda gfortran path makes it print an "Unknown compiler"
    # warning to stderr since it only pattern-matches bare names like
    # "gfortran", but that's harmless -- our own FFLAGS always
    # overrides its compiler-preset default regardless. Build only
    # `src` (the actual libhoppet_v1.a + hoppet_v1.h/.mod) and skip
    # example_f90/benchmarking, which need LHAPDF example programs we
    # don't need for a library package.
    #
    # Deliberately NOT using conda's full ${FFLAGS}: it includes
    # -ftree-vectorize, which auto-vectorizes EXP() calls in hoppet's
    # DGLAP evolution code into calls to glibc's libmvec
    # (_ZGVbN2v_exp). That's harmless for a normal shared-lib build,
    # but this static .a gets linked directly INTO applgrid's .so,
    # and applgrid's own link step doesn't pull in -lmvec -- symbol
    # stays undefined until "symbol lookup error" at runtime. Plain
    # -O2 -fPIC avoids introducing that dependency in the first place.
    ./configure --prefix="${PREFIX}" FC="${FC}" FFLAGS="-O2 -fPIC"
    make src
    make install
    ;;

  *)
    cmake -S . -B build -DCMAKE_INSTALL_PREFIX=$PREFIX

    cmake --build build -j$NPROC
    cmake --install build

    #rm ${PREFIX}/lib/libhoppet*.a
    ctest --test-dir build --rerun-failed --output-on-failure
    ;;
esac
