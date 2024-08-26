#!/bin/zsh
set -e
touch $HOME/.zshrc
source $HOME/.zshrc

## Runtime dependencies: libxml2, libffi, z3, libedit, ncurses, zstd and zlib

## TO BE EDITED ACCORDING TO YOUR PREFERENCES
IS_TEMP="${TEMP:-0}"
PROGRAM_VERSION_MAJOR="18"
PROGRAM_VERSION="18.1.8"
PROGRAM_NAME="llvm"
SHA512_SUM="25eeee9984c8b4d0fbc240df90f33cbb000d3b0414baff5c8982beafcc5e59e7ef18f6f85d95b3a5f60cb3d4cd4f877c80487b5768bc21bc833f107698ad93db"

## EDIT WITH CARE
SOFTWARES_DIR="${SOFTWARES_DIR:-$HOME/.softwares}"
SOURCES_DIR="$SOFTWARES_DIR/sources"
BUILD_DIR="$SOFTWARES_DIR/build"
INSTALL_DIR="$SOFTWARES_DIR/install"

## SHOULD NOT BE EDITED
BASE_DIR=$(realpath $(dirname "$0"))
TEMP_PREFIX=""
if ((IS_TEMP == 1)); then
  TEMP_PREFIX="temp-"
fi
PROGRAM_FULL="$PROGRAM_NAME-$PROGRAM_VERSION"
PROGRAM_INSTALL_PREFIX="$BUILD_DIR/$TEMP_PREFIX$PROGRAM_FULL"

SOFTWARES_DIR=$SOFTWARES_DIR

if $BASE_DIR/utils/detect-installation.sh "$TEMP_PREFIX$PROGRAM_NAME" min="$PROGRAM_VERSION" > /dev/null; then
  echo "$TEMP_PREFIX$PROGRAM_NAME $PROGRAM_VERSION is already installed"
  exit 0
fi


if ((IS_TEMP == 0)); then
  if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh temp-llvm && ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh llvm; then
    if ! TEMP=1 $BASE_DIR/llvm-18.1.8.sh 2> /dev/null; then
      echo "$TEMP_PREFIX$PROGRAM_NAME $PROGRAM_VERSION needs LLVM (at least temporary version) which failed to install"
      exit 1
    fi
  fi
fi
if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh ${TEMP_PREFIX}cmake > /dev/null; then
  if ! TEMP=$IS_TEMP $BASE_DIR/cmake-3.30.2.sh 2> /dev/null; then
    echo "$TEMP_PREFIX$PROGRAM_NAME $PROGRAM_VERSION needs ${TEMP_PREFIX}cmake which failed to install"
    exit 1
  fi
fi
if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh ${TEMP_PREFIX}ninja > /dev/null; then
  if ! TEMP=$IS_TEMP $BASE_DIR/ninja-1.12.1.sh 2> /dev/null; then
    echo "$TEMP_PREFIX$PROGRAM_NAME $PROGRAM_VERSION needs ${TEMP_PREFIX}ninja which failed to install"
    exit 1
  fi
fi
if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh ${TEMP_PREFIX}zlib > /dev/null; then
  if ! TEMP=$IS_TEMP $BASE_DIR/zlib-1.3.1.sh 2> /dev/null; then
    echo "$TEMP_PREFIX$PROGRAM_NAME $PROGRAM_VERSION needs ${TEMP_PREFIX}zlib which failed to install"
    exit 1
  fi
fi
if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh ${TEMP_PREFIX}zstd > /dev/null; then
  if ! TEMP=$IS_TEMP $BASE_DIR/zstd-1.5.6.sh 2> /dev/null; then
    echo "$TEMP_PREFIX$PROGRAM_NAME $PROGRAM_VERSION needs ${TEMP_PREFIX}zstd which failed to install"
    exit 1
  fi
fi
if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh ${TEMP_PREFIX}ncurses > /dev/null; then
  if ! TEMP=$IS_TEMP $BASE_DIR/ncurses-6.5.sh 2> /dev/null; then
    echo "$TEMP_PREFIX$PROGRAM_NAME $PROGRAM_VERSION needs ${TEMP_PREFIX}ncurses which failed to install"
    exit 1
  fi
fi
if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh ${TEMP_PREFIX}libedit > /dev/null; then
  if ! TEMP=$IS_TEMP $BASE_DIR/libedit-3.1.2024.08.08.sh 2> /dev/null; then
    echo "$TEMP_PREFIX$PROGRAM_NAME $PROGRAM_VERSION needs ${TEMP_PREFIX}libedit which failed to install"
    exit 1
  fi
fi
if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh ${TEMP_PREFIX}z3 > /dev/null; then
  if ! TEMP=$IS_TEMP $BASE_DIR/z3-4.13.0.0.sh 2> /dev/null; then
    echo "$TEMP_PREFIX$PROGRAM_NAME $PROGRAM_VERSION needs ${TEMP_PREFIX}z3 which failed to install"
    exit 1
  fi
fi
if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh ${TEMP_PREFIX}libffi > /dev/null; then
  if ! TEMP=$IS_TEMP $BASE_DIR/libffi-3.4.6.sh 2> /dev/null; then
    echo "$TEMP_PREFIX$PROGRAM_NAME $PROGRAM_VERSION needs ${TEMP_PREFIX}libffi which failed to install"
    exit 1
  fi
fi
if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh ${TEMP_PREFIX}libxml2 > /dev/null; then
  if ! TEMP=$IS_TEMP $BASE_DIR/libxml2-2.13.3.sh 2> /dev/null; then
    echo "$TEMP_PREFIX$PROGRAM_NAME $PROGRAM_VERSION needs ${TEMP_PREFIX}libxml2 which failed to install"
    exit 1
  fi
fi

SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/download-file.sh \
  "https://github.com/llvm/llvm-project/releases/download/llvmorg-${PROGRAM_VERSION}/llvm-project-${PROGRAM_VERSION}.src.tar.xz" \
  "llvm-project-${PROGRAM_VERSION}.src.tar.xz" \
  "$SHA512_SUM"
cd $SOURCES_DIR
tar -xf llvm-project-${PROGRAM_VERSION}.src.tar.xz
if [ -d "$SOURCES_DIR/$PROGRAM_NAME-build" ]; then
  echo "Removing build directory"
  rm -rf $SOURCES_DIR/$PROGRAM_NAME-build
fi
mkdir -p $PROGRAM_NAME-build
cd $PROGRAM_NAME-build
mkdir stage1
cd stage1
cmake -G Ninja ../../llvm-project-${PROGRAM_VERSION}.src/llvm \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX="$PROGRAM_INSTALL_PREFIX" \
  -DLLVM_ENABLE_LIBCXX=ON \
  -DCOMPILER_RT_ENABLE_IOS=OFF \
  -DCOMPILER_RT_ENABLE_WATCHOS=OFF \
  -DCOMPILER_RT_ENABLE_TVOS=OFF \
  -DLLVM_TARGETS_TO_BUILD="Native;AArch64;ARM;X86" \
  -DLLVM_ENABLE_PROJECTS="clang;lld" \
  -DLLVM_ENABLE_RUNTIMES="compiler-rt" \
  -DLIBXML2_INCLUDE_DIR="$BUILD_DIR/${TEMP_PREFIX}libxml2-2.13.3/include" \
  -DLIBXML2_LIBRARY="$BUILD_DIR/${TEMP_PREFIX}libxml2-2.13.3/lib/libxml2.2.dylib" \
  -DFFI_INCLUDE_DIR="$BUILD_DIR/${TEMP_PREFIX}libffi-3.4.6/include" \
  -DFFI_LIBRARY_DIR="$BUILD_DIR/${TEMP_PREFIX}libffi-3.4.6/lib" \
  -DLLVM_Z3_INSTALL_DIR="$BUILD_DIR/${TEMP_PREFIX}z3-4.13.0.0" \
  -DLibEdit_INCLUDE_DIRS="$BUILD_DIR/${TEMP_PREFIX}libedit-3.1.2024.08.08/include" \
  -DLibEdit_LIBRARIES="$BUILD_DIR/${TEMP_PREFIX}libedit-3.1.2024.08.08/lib/libedit.0.dylib" \
  -DTerminfo_LIBRARIES="$BUILD_DIR/${TEMP_PREFIX}ncurses-6.5/lib/libncursesw.6.dylib" \
  -DZLIB_INCLUDE_DIR="$BUILD_DIR/${TEMP_PREFIX}zlib-1.3.1/include" \
  -DZLIB_LIBRARY="$BUILD_DIR/${TEMP_PREFIX}zlib-1.3.1/lib/libz.1.3.1.dylib" \
  -Dzstd_INCLUDE_DIR="$BUILD_DIR/${TEMP_PREFIX}zstd-1.5.6/include" \
  -Dzstd_LIBRARY="$BUILD_DIR/${TEMP_PREFIX}zstd-1.5.6/lib/libzstd.1.5.6.dylib" \
  -Dzstd_STATIC_LIBRARY="$BUILD_DIR/${TEMP_PREFIX}zstd-1.5.6/lib/libzstd.a"
cmake --build . --target clang llvm-profdata compiler-rt llvm-libtool-darwin LTO
mkdir ../stage2
cd ../stage2
cmake -G Ninja ../../llvm-project-${PROGRAM_VERSION}.src/llvm \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX="${PROGRAM_INSTALL_PREFIX}" \
  -DCMAKE_C_COMPILER="${SOURCES_DIR}/llvm-build/stage1/bin/clang" \
  -DCMAKE_CXX_COMPILER="${SOURCES_DIR}/llvm-build/stage1/bin/clang++" \
  -DLLVM_BUILD_INSTRUMENTED=IR \
  -DLLVM_BUILD_RUNTIME=NO \
  -DCMAKE_C_FLAGS="-Xclang -mllvm -Xclang -vp-counters-per-site=6" \
  -DCMAKE_CXX_FLAGS="-Xclang -mllvm -Xclang -vp-counters-per-site=6" \
  -DLLVM_ENABLE_RUNTIMES="compiler-rt" \
  -DLLVM_TARGETS_TO_BUILD="Native;AArch64;ARM;X86" \
  -DLLVM_ENABLE_PROJECTS="clang;lld" \
  -DLLVM_ENABLE_LIBCXX=ON \
  -DCOMPILER_RT_ENABLE_IOS=OFF \
  -DCOMPILER_RT_ENABLE_WATCHOS=OFF \
  -DCOMPILER_RT_ENABLE_TVOS=OFF \
  -DCLANG_TABLEGEN="${SOURCES_DIR}/llvm-build/stage1/bin/clang-tblgen" \
  -DLLVM_TABLEGEN="${SOURCES_DIR}/llvm-build/stage1/bin/llvm-tblgen" \
  -DLIBXML2_INCLUDE_DIR="$BUILD_DIR/${TEMP_PREFIX}libxml2-2.13.3/include" \
  -DLIBXML2_LIBRARY="$BUILD_DIR/${TEMP_PREFIX}libxml2-2.13.3/lib/libxml2.2.dylib" \
  -DFFI_INCLUDE_DIR="$BUILD_DIR/${TEMP_PREFIX}libffi-3.4.6/include" \
  -DFFI_LIBRARY_DIR="$BUILD_DIR/${TEMP_PREFIX}libffi-3.4.6/lib" \
  -DLLVM_Z3_INSTALL_DIR="$BUILD_DIR/${TEMP_PREFIX}z3-4.13.0.0" \
  -DLibEdit_INCLUDE_DIRS="$BUILD_DIR/${TEMP_PREFIX}libedit-3.1.2024.08.08/include" \
  -DLibEdit_LIBRARIES="$BUILD_DIR/${TEMP_PREFIX}libedit-3.1.2024.08.08/lib/libedit.0.dylib" \
  -DTerminfo_LIBRARIES="$BUILD_DIR/${TEMP_PREFIX}ncurses-6.5/lib/libncursesw.6.dylib" \
  -DZLIB_INCLUDE_DIR="$BUILD_DIR/${TEMP_PREFIX}zlib-1.3.1/include" \
  -DZLIB_LIBRARY="$BUILD_DIR/${TEMP_PREFIX}zlib-1.3.1/lib/libz.1.3.1.dylib" \
  -Dzstd_INCLUDE_DIR="$BUILD_DIR/${TEMP_PREFIX}zstd-1.5.6/include" \
  -Dzstd_LIBRARY="$BUILD_DIR/${TEMP_PREFIX}zstd-1.5.6/lib/libzstd.1.5.6.dylib" \
  -Dzstd_STATIC_LIBRARY="$BUILD_DIR/${TEMP_PREFIX}zstd-1.5.6/lib/libzstd.a"
cmake --build . --target check-clang check-llvm -- -k 0 || true
mkdir ../output
cd ../output
cmake -G Ninja ../../llvm-project-${PROGRAM_VERSION}.src/llvm \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX="${PROGRAM_INSTALL_PREFIX}" \
  -DCMAKE_C_COMPILER="${SOURCES_DIR}/llvm-build/stage2/bin/clang" \
  -DCMAKE_CXX_COMPILER="${SOURCES_DIR}/llvm-build/stage2/bin/clang++" \
  -DLLVM_BUILD_RUNTIMES=OFF \
  -DLLVM_TARGETS_TO_BUILD="Native;AArch64;ARM;X86" \
  -DLLVM_ENABLE_PROJECTS="clang;lld" \
  -DLLVM_ENABLE_RUNTIMES=compiler-rt \
  -DLLVM_ENABLE_LIBCXX=ON \
  -DCOMPILER_RT_ENABLE_IOS=OFF \
  -DCOMPILER_RT_ENABLE_WATCHOS=OFF \
  -DCOMPILER_RT_ENABLE_TVOS=OFF \
  -DCLANG_TABLEGEN="${SOURCES_DIR}/llvm-build/stage1/bin/clang-tblgen" \
  -DLLVM_TABLEGEN="${SOURCES_DIR}/llvm-build/stage1/bin/llvm-tblgen" \
  -DLIBXML2_INCLUDE_DIR="$BUILD_DIR/${TEMP_PREFIX}libxml2-2.13.3/include" \
  -DLIBXML2_LIBRARY="$BUILD_DIR/${TEMP_PREFIX}libxml2-2.13.3/lib/libxml2.2.dylib" \
  -DFFI_INCLUDE_DIR="$BUILD_DIR/${TEMP_PREFIX}libffi-3.4.6/include" \
  -DFFI_LIBRARY_DIR="$BUILD_DIR/${TEMP_PREFIX}libffi-3.4.6/lib" \
  -DLLVM_Z3_INSTALL_DIR="$BUILD_DIR/${TEMP_PREFIX}z3-4.13.0.0" \
  -DLibEdit_INCLUDE_DIRS="$BUILD_DIR/${TEMP_PREFIX}libedit-3.1.2024.08.08/include" \
  -DLibEdit_LIBRARIES="$BUILD_DIR/${TEMP_PREFIX}libedit-3.1.2024.08.08/lib/libedit.0.dylib" \
  -DTerminfo_LIBRARIES="$BUILD_DIR/${TEMP_PREFIX}ncurses-6.5/lib/libncursesw.6.dylib" \
  -DZLIB_INCLUDE_DIR="$BUILD_DIR/${TEMP_PREFIX}zlib-1.3.1/include" \
  -DZLIB_LIBRARY="$BUILD_DIR/${TEMP_PREFIX}zlib-1.3.1/lib/libz.1.3.1.dylib" \
  -Dzstd_INCLUDE_DIR="$BUILD_DIR/${TEMP_PREFIX}zstd-1.5.6/include" \
  -Dzstd_LIBRARY="$BUILD_DIR/${TEMP_PREFIX}zstd-1.5.6/lib/libzstd.1.5.6.dylib" \
  -Dzstd_STATIC_LIBRARY="$BUILD_DIR/${TEMP_PREFIX}zstd-1.5.6/lib/libzstd.a"
cmake --build . --
${SOURCES_DIR}/llvm-build/stage1/bin/llvm-profdata merge \
  -output=${SOURCES_DIR}/llvm-build/stage2/profiles/pgo_profile.prof \
  ${SOURCES_DIR}/llvm-build/stage2/profiles/*.profraw
mkdir ../build && cd ../build
cmake -G Ninja ../../llvm-project-${PROGRAM_VERSION}.src/llvm \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX="${PROGRAM_INSTALL_PREFIX}" \
  -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra;lld;mlir;polly" \
  -DLLVM_ENABLE_RUNTIMES="compiler-rt;libcxx;libcxxabi;libunwind;openmp" \
  -DLLVM_POLLY_LINK_INTO_TOOLS=ON \
  -DLLVM_BUILD_EXTERNAL_COMPILER_RT=ON \
  -DLLVM_LINK_LLVM_DYLIB=ON \
  -DLLVM_ENABLE_EH=ON \
  -DLLVM_ENABLE_FFI=ON \
  -DLLVM_ENABLE_RTTI=ON \
  -DLLVM_INCLUDE_DOCS=OFF \
  -DLLVM_INCLUDE_TESTS=OFF \
  -DLLVM_INSTALL_UTILS=ON \
  -DLLVM_ENABLE_Z3_SOLVER=ON \
  -DLLVM_OPTIMIZED_TABLEGEN=ON \
  -DLLVM_TARGETS_TO_BUILD=all \
  -DLIBOMP_INSTALL_ALIASES=OFF \
  -DLIBCXX_INSTALL_MODULES=ON \
  -DLLVM_CREATE_XCODE_TOOLCHAIN=OFF \
  -DCLANG_FORCE_MATCHING_LIBCLANG_SOVERSION=OFF \
  -DLLVM_BUILD_LLVM_C_DYLIB=ON \
  -DLLVM_ENABLE_LIBCXX=ON \
  -DLIBCXX_PSTL_CPU_BACKEND=libdispatch \
  -DDEFAULT_SYSROOT=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk \
  -DLLVM_ENABLE_LTO=Thin \
  -DCMAKE_LIBTOOL="${SOURCES_DIR}/llvm-build/stage1/bin/llvm-libtool-darwin" \
  -DCMAKE_C_COMPILER="${SOURCES_DIR}/llvm-build/stage1/bin/clang" \
  -DCMAKE_CXX_COMPILER="${SOURCES_DIR}/llvm-build/stage1/bin/clang++" \
  -DLLVM_PROFDATA_FILE="${SOURCES_DIR}/llvm-build/stage2/profiles/pgo_profile.prof" \
  -DCLANG_TABLEGEN="${SOURCES_DIR}/llvm-build/stage1/bin/clang-tblgen" \
  -DLIBXML2_INCLUDE_DIR="$BUILD_DIR/${TEMP_PREFIX}libxml2-2.13.3/include" \
  -DLIBXML2_LIBRARY="$BUILD_DIR/${TEMP_PREFIX}libxml2-2.13.3/lib/libxml2.2.dylib" \
  -DFFI_INCLUDE_DIR="$BUILD_DIR/${TEMP_PREFIX}libffi-3.4.6/include" \
  -DFFI_LIBRARY_DIR="$BUILD_DIR/${TEMP_PREFIX}libffi-3.4.6/lib" \
  -DFFI_LIBRARIES="$BUILD_DIR/${TEMP_PREFIX}libffi-3.4.6/lib/libffi.8.dylib" \
  -DLLVM_Z3_INSTALL_DIR="$BUILD_DIR/${TEMP_PREFIX}z3-4.13.0.0" \
  -DLibEdit_INCLUDE_DIRS="$BUILD_DIR/${TEMP_PREFIX}libedit-3.1.2024.08.08/include" \
  -DLibEdit_LIBRARIES="$BUILD_DIR/${TEMP_PREFIX}libedit-3.1.2024.08.08/lib/libedit.0.dylib" \
  -DTerminfo_LIBRARIES="$BUILD_DIR/${TEMP_PREFIX}ncurses-6.5/lib/libncursesw.6.dylib" \
  -DZLIB_INCLUDE_DIR="$BUILD_DIR/${TEMP_PREFIX}zlib-1.3.1/include" \
  -DZLIB_LIBRARY="$BUILD_DIR/${TEMP_PREFIX}zlib-1.3.1/lib/libz.1.3.1.dylib" \
  -Dzstd_INCLUDE_DIR="$BUILD_DIR/${TEMP_PREFIX}zstd-1.5.6/include" \
  -Dzstd_LIBRARY="$BUILD_DIR/${TEMP_PREFIX}zstd-1.5.6/lib/libzstd.1.5.6.dylib" \
  -Dzstd_STATIC_LIBRARY="$BUILD_DIR/${TEMP_PREFIX}zstd-1.5.6/lib/libzstd.a"
cmake --build .
cmake --build . --target install
for binFile in ${PROGRAM_INSTALL_PREFIX}/bin/*; do
    if [ ! -L $binFile ]; then
        install_name_tool -change '@rpath/libLLVM.dylib' ${PROGRAM_INSTALL_PREFIX}/lib/libLLVM.dylib $binFile || true
        install_name_tool -change '@rpath/libclang.dylib' ${PROGRAM_INSTALL_PREFIX}/lib/libclang.dylib $binFile || true
        install_name_tool -change '@rpath/libclang-cpp.dylib' ${PROGRAM_INSTALL_PREFIX}/lib/libclang-cpp.dylib $binFile || true
    fi
done
for libFile in ${PROGRAM_INSTALL_PREFIX}/lib/*.dylib; do
    if [ ! -L $libFile ]; then
        install_name_tool -id "$libFile" "$libFile"
        install_name_tool -change '@rpath/libLLVM.dylib' ${PROGRAM_INSTALL_PREFIX}/lib/libLLVM.dylib $libFile
        install_name_tool -change '@rpath/libmlir_float16_utils.dylib' ${PROGRAM_INSTALL_PREFIX}/lib/libmlir_float16_utils.dylib $libFile
        install_name_tool -change '@rpath/libunwind.1.dylib' ${PROGRAM_INSTALL_PREFIX}/lib/libunwind.1.dylib $libFile
        install_name_tool -change '@rpath/libc++abi.1.dylib' ${PROGRAM_INSTALL_PREFIX}/lib/libc++abi.1.dylib $libFile
    fi
done
/usr/libexec/PlistBuddy -c "Add:CFBundleIdentifier string org.llvm.${PROGRAM_VERSION}" Info.plist
/usr/libexec/PlistBuddy -c "Add:CompatibilityVersion integer 2" Info.plist
mkdir -p ${PROGRAM_INSTALL_PREFIX}/Toolchains/LLVM${PROGRAM_VERSION}.xctoolchain/usr
mv Info.plist ${PROGRAM_INSTALL_PREFIX}/Toolchains/LLVM${PROGRAM_VERSION}.xctoolchain/
ln -s ${PROGRAM_INSTALL_PREFIX}/bin ${PROGRAM_INSTALL_PREFIX}/Toolchains/LLVM${PROGRAM_VERSION}.xctoolchain/usr/bin
ln -s ${PROGRAM_INSTALL_PREFIX}/include ${PROGRAM_INSTALL_PREFIX}/Toolchains/LLVM${PROGRAM_VERSION}.xctoolchain/usr/include
ln -s ${PROGRAM_INSTALL_PREFIX}/lib ${PROGRAM_INSTALL_PREFIX}/Toolchains/LLVM${PROGRAM_VERSION}.xctoolchain/usr/lib
ln -s ${PROGRAM_INSTALL_PREFIX}/libexec ${PROGRAM_INSTALL_PREFIX}/Toolchains/LLVM${PROGRAM_VERSION}.xctoolchain/usr/libexec
ln -s ${PROGRAM_INSTALL_PREFIX}/share ${PROGRAM_INSTALL_PREFIX}/Toolchains/LLVM${PROGRAM_VERSION}.xctoolchain/usr/share
cd ${PROGRAM_INSTALL_PREFIX}/lib
for lib in *.a; do
    mkdir -p temp
    cd temp
    ${PROGRAM_INSTALL_PREFIX}/bin/llvm-ar x "../$lib"
    incorrect=""
    for obj_file in *.o; do
        file_type=$(file --brief "$obj_file")
        if [[ "$file_type" != "Mach-O 64-bit object arm64" ]]; then
          incorrect="$incorrect $obj_file"
          ${PROGRAM_INSTALL_PREFIX}/bin/clang -fno-lto -Wno-unused-command-line-argument -x ir $obj_file -c -o $obj_file
        fi
    done
    if [ -n "$incorrect" ]; then
      incorrect="${incorrect:1}"
      echo "$incorrect" | xargs ${PROGRAM_INSTALL_PREFIX}/bin/llvm-ar r ../$lib
    fi
    cd ..
    rm -rf temp
done
cd $SOURCES_DIR
rm -rf llvm-project-${PROGRAM_VERSION}.src
rm -rf $PROGRAM_NAME-build
if [ -L $INSTALL_DIR/$PROGRAM_NAME ]; then
    rm $INSTALL_DIR/$PROGRAM_NAME
fi
ln -s ../build/$TEMP_PREFIX$PROGRAM_FULL $INSTALL_DIR/$PROGRAM_NAME
mkdir -p ${INSTALL_DIR}/compiler-defaults/bin
ln -s ../../llvm/bin/clang-${PROGRAM_VERSION_MAJOR} ${INSTALL_DIR}/compiler-defaults/bin/cc
ln -s ../../llvm/bin/clang-${PROGRAM_VERSION_MAJOR} ${INSTALL_DIR}/compiler-defaults/bin/gcc
ln -s ../../llvm/bin/clang-${PROGRAM_VERSION_MAJOR} ${INSTALL_DIR}/compiler-defaults/bin/cpp
ln -s ../../llvm/bin/clang-${PROGRAM_VERSION_MAJOR} ${INSTALL_DIR}/compiler-defaults/bin/c++
ln -s ../../llvm/bin/clang-${PROGRAM_VERSION_MAJOR} ${INSTALL_DIR}/compiler-defaults/bin/g++
ln -s ../../llvm/bin/llvm-ar ${INSTALL_DIR}/compiler-defaults/bin/ar
ln -s ../../llvm/bin/llvm-objdump ${INSTALL_DIR}/compiler-defaults/bin/objdump
ln -s ../../llvm/bin/llvm-nm ${INSTALL_DIR}/compiler-defaults/bin/nm
ln -s ../../llvm/bin/llvm-as ${INSTALL_DIR}/compiler-defaults/bin/as
SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/apply_installation.sh $PROGRAM_NAME $INSTALL_DIR
SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/apply_installation.sh compiler-defaults $INSTALL_DIR