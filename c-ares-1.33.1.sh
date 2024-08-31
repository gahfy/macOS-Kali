#!/bin/zsh
set -e
touch $HOME/.zshrc
source $HOME/.zshrc

# No runtime dependencies

## TO BE EDITED ACCORDING TO YOUR PREFERENCES
PROGRAM_VERSION="1.33.1"
PROGRAM_NAME="c-ares"
SHA512_SUM="b5ec4f08539be552f01d49f03327e3999754b940d83c63fbd934c2ed34cf7f05c3f90c9eb64a78a3d7862280bf75765296576a70a6029257daaf90e3e35ab3e4"

## EDIT WITH CARE
SOFTWARES_DIR="${SOFTWARES_DIR:-$HOME/.softwares}"
SOURCES_DIR="$SOFTWARES_DIR/sources"
BUILD_DIR="$SOFTWARES_DIR/build"
INSTALL_DIR="$SOFTWARES_DIR/install"

## SHOULD NOT BE EDITED
BASE_DIR=$(realpath $(dirname "$0"))
PROGRAM_FULL="$PROGRAM_NAME-$PROGRAM_VERSION"
PROGRAM_INSTALL_PREFIX="$BUILD_DIR/$PROGRAM_FULL"

SOFTWARES_DIR=$SOFTWARES_DIR

if $BASE_DIR/utils/detect-installation.sh "$PROGRAM_NAME" min="$PROGRAM_VERSION" > /dev/null; then
  echo "$PROGRAM_NAME $PROGRAM_VERSION is already installed"
  exit 0
fi

if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh temp-llvm && ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh llvm; then
  if ! TEMP=1 $BASE_DIR/llvm-18.1.8.sh 2> /dev/null; then
    echo "$PROGRAM_NAME $PROGRAM_VERSION needs LLVM (at least temporary version) which failed to install"
    exit 1
  fi
fi

if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh temp-cmake && ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh cmake; then
  if ! TEMP=1 $BASE_DIR/cmake-3.30.2.sh 2> /dev/null; then
    echo "$PROGRAM_NAME $PROGRAM_VERSION needs CMake (at least temporary version) which failed to install"
    exit 1
  fi
fi

SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/download-file.sh \
  "https://github.com/c-ares/c-ares/releases/download/v${PROGRAM_VERSION}/${PROGRAM_FULL}.tar.gz" \
  "$PROGRAM_FULL.tar.xz" \
  "$SHA512_SUM"
cd $SOURCES_DIR
tar -xf $PROGRAM_FULL.tar.xz
if [ -d "$SOURCES_DIR/$PROGRAM_NAME-build" ]; then
  echo "Removing build directory"
  rm -rf $SOURCES_DIR/$PROGRAM_NAME-build
fi
mkdir -p $PROGRAM_NAME-build
cd $PROGRAM_NAME-build
cmake ../${PROGRAM_FULL} -DCMAKE_INSTALL_PREFIX=$PROGRAM_INSTALL_PREFIX \
  -DCARES_STATIC=ON \
  -DCARES_SHARED=ON
cmake --build .
cmake --build . --target install
install_name_tool -id $PROGRAM_INSTALL_PREFIX/lib/libcares.2.dylib $PROGRAM_INSTALL_PREFIX/lib/libcares.2.18.1.dylib
install_name_tool -change '@rpath/libcares.2.dylib' $PROGRAM_INSTALL_PREFIX/lib/libcares.2.dylib $PROGRAM_INSTALL_PREFIX/bin/adig
install_name_tool -change '@rpath/libcares.2.dylib' $PROGRAM_INSTALL_PREFIX/lib/libcares.2.dylib $PROGRAM_INSTALL_PREFIX/bin/ahost
cd $SOURCES_DIR
rm -rf $PROGRAM_FULL
rm -rf $PROGRAM_NAME-build
if [ -L $INSTALL_DIR/$PROGRAM_NAME ]; then
    rm $INSTALL_DIR/$PROGRAM_NAME
fi
ln -s ../build/$PROGRAM_FULL $INSTALL_DIR/$PROGRAM_NAME
SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/apply_installation.sh $PROGRAM_NAME $INSTALL_DIR