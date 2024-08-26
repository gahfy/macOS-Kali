#!/bin/zsh
set -e
touch $HOME/.zshrc
source $HOME/.zshrc

# Runtime dependencies: libiconv

## TO BE EDITED ACCORDING TO YOUR PREFERENCES
PROGRAM_VERSION="0.29.2"
PROGRAM_NAME="pkg-config"
SHA512_SUM="4861ec6428fead416f5cbbbb0bbad10b9152967e481d4b0ff2eb396a9f297f552984c9bb72f6864a37dcd8fca1d9ccceda3ef18d8f121938dbe4fdf2b870fe75"

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

if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh libiconv; then
  if ! $BASE_DIR/libiconv-1.17.sh 2> /dev/null; then
    echo "$PROGRAM_NAME $PROGRAM_VERSION needs libiconv which failed to install"
    exit 1
  fi
fi

SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/download-file.sh \
  "https://pkgconfig.freedesktop.org/releases/${PROGRAM_FULL}.tar.gz" \
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
CFLAGS="-Wno-int-conversion -I$BUILD_DIR/libiconv-1.17/include" \
  LDFLAGS="-L$BUILD_DIR/libiconv-1.17/lib" \
  ../$PROGRAM_FULL/configure --prefix=$PROGRAM_INSTALL_PREFIX \
  --with-internal-glib
make -j$(sysctl -n hw.ncpu)
make -j$(sysctl -n hw.ncpu) check
make -j$(sysctl -n hw.ncpu) install
cd $SOURCES_DIR
rm -rf $PROGRAM_FULL
rm -rf $PROGRAM_NAME-build
if [ -L $INSTALL_DIR/$PROGRAM_NAME ]; then
    rm $INSTALL_DIR/$PROGRAM_NAME
fi
ln -s ../build/$PROGRAM_FULL $INSTALL_DIR/$PROGRAM_NAME
SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/apply_installation.sh $PROGRAM_NAME $INSTALL_DIR