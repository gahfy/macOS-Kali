#!/bin/zsh
set -e
touch $HOME/.zshrc
source $HOME/.zshrc

## Runtime dependencies: zlib and lz4

## TO BE EDITED ACCORDING TO YOUR PREFERENCES
PROGRAM_VERSION="1.7.0"
PROGRAM_NAME="ngtcp2"
SHA512_SUM="6efa42d17772fde00d9d0a67f2cbcf0704a8462c7305a5e3f213d1e98c9302a1ceee847081ecef358c7a421db56236e571a1ad9ff7fa5f5037987c5cb14e517d"

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
    echo "$TEMP_PREFIX$PROGRAM_NAME $PROGRAM_VERSION needs LLVM (at least temporary version) which failed to install"
    exit 1
  fi
fi

SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/download-file.sh \
  "https://github.com/ngtcp2/ngtcp2/releases/download/v${PROGRAM_VERSION}/${PROGRAM_FULL}.tar.xz" \
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
LIBEV_CFLAGS="-I${BUILD_DIR}/libev-4.33/include" \
  LIBEV_LIBS="-L${BUILD_DIR}/libev-4.33/lib -lev" \
  JEMALLOC_CFLAGS="-I${BUILD_DIR}/jemalloc-5.3.0/include" \
  JEMALLOC_LIBS="-L${BUILD_DIR}/jemalloc-5.3.0/lib -ljemalloc" \
  OPENSSL_CFLAGS="-I${BUILD_DIR}/libressl-3.9.2/include" \
  OPENSSL_LIBS="-L${BUILD_DIR}/libressl-3.9.2/lib -lssl -lcrypto" \
  LIBNGHTTP3_CFLAGS="-I${BUILD_DIR}/nghttp3-1.5.0/include" \
  LIBNGHTTP3_LIBS="-L${BUILD_DIR}/nghttp3-1.5.0/lib -lnghttp3" \
  LIBBROTLIENC_CFLAGS="-I${BUILD_DIR}/brotli-1.1.0/include" \
  LIBBROTLIENC_LIBS="-L${BUILD_DIR}/brotli-1.1.0/lib -lbrotlienc" \
  LIBBROTLIDEC_CFLAGS="-I${BUILD_DIR}/brotli-1.1.0/include" \
  LIBBROTLIDEC_LIBS="-L${BUILD_DIR}/brotli-1.1.0/lib -lbrotlidec" \
  ../$PROGRAM_FULL/configure --prefix=$PROGRAM_INSTALL_PREFIX
make
make check
make install
cd $SOURCES_DIR
rm -rf $PROGRAM_FULL
rm -rf $PROGRAM_NAME-build
if [ -L $INSTALL_DIR/$PROGRAM_NAME ]; then
    rm $INSTALL_DIR/$PROGRAM_NAME
fi
ln -s ../build/$PROGRAM_FULL $INSTALL_DIR/$PROGRAM_NAME
SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/apply_installation.sh $PROGRAM_NAME $INSTALL_DIR