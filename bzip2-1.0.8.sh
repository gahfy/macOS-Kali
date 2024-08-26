#!/bin/zsh
set -e
touch $HOME/.zshrc
source $HOME/.zshrc

## No runtime dependencies

## TO BE EDITED ACCORDING TO YOUR PREFERENCES
IS_TEMP="${TEMP:-0}"
PROGRAM_VERSION_MAJOR="1"
PROGRAM_VERSION="1.0.8"
PROGRAM_NAME="bzip2"
SHA512_SUM="083f5e675d73f3233c7930ebe20425a533feedeaaa9d8cc86831312a6581cefbe6ed0d08d2fa89be81082f2a5abdabca8b3c080bf97218a1bd59dc118a30b9f3"

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

SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/download-file.sh \
  "https://sourceware.org/pub/bzip2/$PROGRAM_FULL.tar.gz" \
  "$PROGRAM_FULL.tar.gz" \
  "$SHA512_SUM"
cd $SOURCES_DIR
tar -xf $PROGRAM_FULL.tar.gz
cp $BASE_DIR/patches/$PROGRAM_FULL.patch $SOURCES_DIR/$PROGRAM_FULL.patch
patch --directory=$PROGRAM_FULL/ --strip=1 < $SOURCES_DIR/$PROGRAM_FULL.patch
cd $PROGRAM_FULL
make -j$(sysctl -n hw.ncpu)
make -j$(sysctl -n hw.ncpu) check
make -j$(sysctl -n hw.ncpu) install PREFIX=$PROGRAM_INSTALL_PREFIX
make -j$(sysctl -n hw.ncpu) -f Makefile-libbz2_so
mv $SOURCES_DIR/${PROGRAM_FULL}/libbz2.${PROGRAM_VERSION}.dylib $PROGRAM_INSTALL_PREFIX/lib/libbz2.${PROGRAM_VERSION}.dylib
install_name_tool -id $PROGRAM_INSTALL_PREFIX/lib/libbz2.${PROGRAM_VERSION}.dylib $PROGRAM_INSTALL_PREFIX/lib/libbz2.${PROGRAM_VERSION}.dylib
ln -s libbz2.${PROGRAM_VERSION}.dylib $PROGRAM_INSTALL_PREFIX/lib/libbz2.${PROGRAM_VERSION_MAJOR}.dylib
ln -s libbz2.${PROGRAM_VERSION}.dylib $PROGRAM_INSTALL_PREFIX/lib/libbz2.dylib
mkdir -p $PROGRAM_INSTALL_PREFIX/lib/pkgconfig
echo 'prefix='"$PROGRAM_INSTALL_PREFIX" > $PROGRAM_INSTALL_PREFIX/lib/pkgconfig/bzip2.pc
echo 'exec_prefix=${prefix}' >> $PROGRAM_INSTALL_PREFIX/lib/pkgconfig/bzip2.pc
echo 'bindir=${exec_prefix}/bin' >> $PROGRAM_INSTALL_PREFIX/lib/pkgconfig/bzip2.pc
echo 'libdir=${exec_prefix}/lib' >> $PROGRAM_INSTALL_PREFIX/lib/pkgconfig/bzip2.pc
echo 'includedir=${prefix}/include' >> $PROGRAM_INSTALL_PREFIX/lib/pkgconfig/bzip2.pc
echo '' >> $PROGRAM_INSTALL_PREFIX/lib/pkgconfig/bzip2.pc
echo 'Name: bzip2' >> $PROGRAM_INSTALL_PREFIX/lib/pkgconfig/bzip2.pc
echo 'Description: Lossless, block-sorting data compression' >> $PROGRAM_INSTALL_PREFIX/lib/pkgconfig/bzip2.pc
echo 'Version: '"$PROGRAM_VERSION" >> $PROGRAM_INSTALL_PREFIX/lib/pkgconfig/bzip2.pc
echo 'Libs: -L${libdir} -lbz2' >> $PROGRAM_INSTALL_PREFIX/lib/pkgconfig/bzip2.pc
echo 'Cflags: -I${includedir}' >> $PROGRAM_INSTALL_PREFIX/lib/pkgconfig/bzip2.pc

cd $SOURCES_DIR
rm -rf $PROGRAM_FULL
if [ -L $INSTALL_DIR/$PROGRAM_NAME ]; then
    rm $INSTALL_DIR/$PROGRAM_NAME
fi
ln -s ../build/$TEMP_PREFIX$PROGRAM_FULL $INSTALL_DIR/$PROGRAM_NAME
SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/apply_installation.sh $PROGRAM_NAME $INSTALL_DIR