#!/bin/zsh
set -e
touch $HOME/.zshrc
source $HOME/.zshrc

## Runtime dependencies: zlib and lz4

## TO BE EDITED ACCORDING TO YOUR PREFERENCES
IS_TEMP="${TEMP:-0}"
VERSION_MAJOR="1"
PROGRAM_VERSION="1.5.6"
PROGRAM_NAME="zstd"
SHA512_SUM="54a578f2484da0520a6e9a24f501b9540a3fe3806785d6bc9db79fc095b7c142a7c121387c7eecd460ca71446603584ef1ba4d29a33ca90873338c9ffbd04f14"

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
if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh ${TEMP_PREFIX}zlib; then
  if ! TEMP=$IS_TEMP $BASE_DIR/zlib-1.3.1.sh 2> /dev/null; then
    echo "$TEMP_PREFIX$PROGRAM_NAME $PROGRAM_VERSION needs ${TEMP_PREFIX}zlib which failed to install"
    exit 1
  fi
fi
if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh ${TEMP_PREFIX}lz4; then
  if ! TEMP=$IS_TEMP $BASE_DIR/lz4-1.10.0.sh 2> /dev/null; then
    echo "$TEMP_PREFIX$PROGRAM_NAME $PROGRAM_VERSION needs ${TEMP_PREFIX}lz4 which failed to install"
    exit 1
  fi
fi

if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh ${TEMP_PREFIX}cmake; then
  if ! TEMP=$IS_TEMP $BASE_DIR/cmake-3.30.2.sh 2> /dev/null; then
    echo "$TEMP_PREFIX$PROGRAM_NAME $PROGRAM_VERSION needs ${TEMP_PREFIX}cmake which failed to install"
    exit 1
  fi
fi

SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/download-file.sh \
  "https://github.com/facebook/zstd/releases/download/v${PROGRAM_VERSION}/${PROGRAM_FULL}.tar.gz" \
  "$PROGRAM_FULL.tar.gz" \
  "$SHA512_SUM"
cd $SOURCES_DIR
tar -xf $PROGRAM_FULL.tar.gz
if [ -d "$SOURCES_DIR/$PROGRAM_NAME-build" ]; then
  echo "Removing build directory"
  rm -rf $SOURCES_DIR/$PROGRAM_NAME-build
fi
mkdir -p $PROGRAM_NAME-build
cd $PROGRAM_NAME-build
cmake ../$PROGRAM_FULL/build/cmake -DCMAKE_INSTALL_PREFIX=$PROGRAM_INSTALL_PREFIX \
  -DZSTD_PROGRAMS_LINK_SHARED=ON \
  -DZSTD_BUILD_CONTRIB=ON \
  -DZSTD_LEGACY_SUPPORT=ON \
  -DZSTD_ZLIB_SUPPORT=ON \
  -DZSTD_LZMA_SUPPORT=ON \
  -DZSTD_LZ4_SUPPORT=ON \
  -DZLIB_INCLUDE_DIR=$BUILD_DIR/${TEMP_PREFIX}zlib-1.3.1/include \
  -DZLIB_LIBRARY=$BUILD_DIR/${TEMP_PREFIX}zlib-1.3.1/lib/libz.1.3.1.dylib \
  -DLIBLZMA_INCLUDE_DIR=$BUILD_DIR/${TEMP_PREFIX}xz-5.6.2/include \
  -DLIBLZMA_LIBRARY=$BUILD_DIR/${TEMP_PREFIX}xz-5.6.2/lib/liblzma.5.dylib \
  -DLIBLZ4_INCLUDE_DIR=$BUILD_DIR/${TEMP_PREFIX}lz4-1.10.0/include \
  -DLIBLZ4_LIBRARY=$BUILD_DIR/${TEMP_PREFIX}lz4-1.10.0/lib/liblz4.1.10.0.dylib
cmake --build .
cmake --build . --target install
install_name_tool -id $PROGRAM_INSTALL_PREFIX/lib/libzstd.${PROGRAM_VERSION}.dylib $PROGRAM_INSTALL_PREFIX/lib/libzstd.${PROGRAM_VERSION}.dylib
install_name_tool -change @rpath/libzstd.${VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libzstd.${VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/bin/pzstd
install_name_tool -change @rpath/libzstd.${VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libzstd.${VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/bin/unzstd
install_name_tool -change @rpath/libzstd.${VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libzstd.${VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/bin/zstd
install_name_tool -change @rpath/libzstd.${VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libzstd.${VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/bin/zstdcat
install_name_tool -change @rpath/libzstd.${VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libzstd.${VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/bin/zstdmt
cd $SOURCES_DIR
rm -rf $PROGRAM_FULL
rm -rf $PROGRAM_NAME-build
if [ -L $INSTALL_DIR/$PROGRAM_NAME ]; then
    rm $INSTALL_DIR/$PROGRAM_NAME
fi
ln -s ../build/$TEMP_PREFIX$PROGRAM_FULL $INSTALL_DIR/$PROGRAM_NAME
SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/apply_installation.sh $PROGRAM_NAME $INSTALL_DIR