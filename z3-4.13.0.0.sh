#!/bin/zsh
set -e
touch $HOME/.zshrc
source $HOME/.zshrc

## No runtime dependencies

## TO BE EDITED ACCORDING TO YOUR PREFERENCES
IS_TEMP="${TEMP:-0}"
VERSION_MINOR="4.13"
WEBFILE_VERSION="4.13.0"
PROGRAM_VERSION="4.13.0.0"
PROGRAM_NAME="z3"
WEBFILE_NAME="$PROGRAM_NAME-$WEBFILE_VERSION"
SHA512_SUM="8503787fe0b18592b5a131bcec2cacfa5f5096d76386a1c4fda7a836e472924b154433306d27600ff0d0758ddb710c965901fbfc2e5605919b624b9d4d1bc4fd"

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

if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh ${TEMP_PREFIX}cmake; then
  if ! TEMP=$IS_TEMP $BASE_DIR/cmake-3.30.2.sh 2> /dev/null; then
    echo "$TEMP_PREFIX$PROGRAM_NAME $PROGRAM_VERSION needs ${TEMP_PREFIX}cmake which failed to install"
    exit 1
  fi
fi

SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/download-file.sh \
  "https://github.com/Z3Prover/z3/archive/refs/tags/${WEBFILE_NAME}.tar.gz" \
  "${WEBFILE_NAME}.tar.gz" \
  "$SHA512_SUM"
cd $SOURCES_DIR
tar -xf $WEBFILE_NAME.tar.gz
if [ -d "$SOURCES_DIR/$PROGRAM_NAME-build" ]; then
  echo "Removing build directory"
  rm -rf $SOURCES_DIR/$PROGRAM_NAME-build
fi
mkdir -p $PROGRAM_NAME-build
cd $PROGRAM_NAME-build
cmake -G Ninja ../z3-$WEBFILE_NAME \
  -DCMAKE_INSTALL_PREFIX=$PROGRAM_INSTALL_PREFIX \
  -DZ3_LINK_TIME_OPTIMIZATION=ON \
  -DZ3_INCLUDE_GIT_DESCRIBE=OFF \
  -DZ3_INCLUDE_GIT_HASH=OFF \
  -DZ3_INSTALL_PYTHON_BINDINGS=ON \
  -DZ3_BUILD_EXECUTABLE=ON \
  -DZ3_BUILD_TEST_EXECUTABLES=ON \
  -DZ3_BUILD_PYTHON_BINDINGS=ON \
  -DZ3_BUILD_DOTNET_BINDINGS=OFF \
  -DZ3_BUILD_JAVA_BINDINGS=OFF \
  -DZ3_USE_LIB_GMP=OFF \
  -DCMAKE_INSTALL_PYTHON_PKG_DIR=$PROGRAM_INSTALL_PREFIX/lib/python3.12/site-packages
cmake --build .
cmake --build . --target test-z3
./test-z3 /a
cmake --build . --target install
install_name_tool -id $PROGRAM_INSTALL_PREFIX/lib/libz3.${VERSION_MINOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libz3.${PROGRAM_VERSION}.dylib
cd $SOURCES_DIR
rm -rf z3-$WEBFILE_NAME
rm -rf $PROGRAM_NAME-build
if [ -L $INSTALL_DIR/$PROGRAM_NAME ]; then
    rm $INSTALL_DIR/$PROGRAM_NAME
fi
ln -s ../build/$TEMP_PREFIX$PROGRAM_FULL $INSTALL_DIR/$PROGRAM_NAME
SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/apply_installation.sh $PROGRAM_NAME $INSTALL_DIR