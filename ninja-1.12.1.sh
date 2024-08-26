#!/bin/zsh
set -e
touch $HOME/.zshrc
source $HOME/.zshrc

## No runtime dependencies

## TO BE EDITED ACCORDING TO YOUR PREFERENCES
IS_TEMP="${TEMP:-0}"
PROGRAM_VERSION="1.12.1"
PROGRAM_NAME="ninja"
SHA512_SUM="d6e6f0e89a4844a69069ff0c7cefc07704a41c7b0c062a57534de87decdde63e27928147b321111b806aa7efa1061f031a1319b074391db61b0cbdccf096954c"

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


## Ninja 1.12.1 needs CMake 3.15 (https://github.com/ninja-build/ninja/blob/master/CMakeLists.txt)
if ((IS_TEMP == 0)); then
  if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh temp-llvm && ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh llvm; then
    if ! TEMP=1 $BASE_DIR/llvm-18.1.8.sh 2> /dev/null; then
      echo "$TEMP_PREFIX$PROGRAM_NAME $PROGRAM_VERSION needs LLVM (at least temporary version) which failed to install"
      exit 1
    fi
  fi
fi
if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh ${TEMP_PREFIX}cmake; then
  if ! TEMP=$IS_TEMP $BASE_DIR/cmake-3.30.2.sh 2> /dev/null; then
    echo "$TEMP_PREFIX$PROGRAM_NAME $PROGRAM_VERSION needs ${TEMP_PREFIX}cmake which failed to install"
    exit 1
  fi
fi
SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/download-file.sh \
  "https://github.com/ninja-build/ninja/archive/refs/tags/v$PROGRAM_VERSION.tar.gz" \
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
cmake ../$PROGRAM_FULL -DCMAKE_INSTALL_PREFIX=$PROGRAM_INSTALL_PREFIX && \
cmake --build . && \
cmake --build . --target test && \
cmake --build . --target install/local && \
cd $SOURCES_DIR
rm -rf $PROGRAM_FULL
rm -rf $PROGRAM_NAME-build
if [ -L $INSTALL_DIR/$PROGRAM_NAME ]; then
    rm $INSTALL_DIR/$PROGRAM_NAME
fi
ln -s ../build/$TEMP_PREFIX$PROGRAM_FULL $INSTALL_DIR/$PROGRAM_NAME
SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/apply_installation.sh $PROGRAM_NAME $INSTALL_DIR