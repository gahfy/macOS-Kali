#!/bin/zsh
set -e
touch $HOME/.zshrc
source $HOME/.zshrc

# Runtime dependencies: libiconv

## TO BE EDITED ACCORDING TO YOUR PREFERENCES
PROGRAM_VERSION="8.9.1"
PROGRAM_NAME="curl"
SHA512_SUM="a0fe234402875db194aad4e4208b7e67e7ffc1562622eea90948d4b9b0122c95c3dde8bbe2f7445a687cb3de7cb09f20e5819d424570442d976aa4c913227fc7"

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

if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh m4; then
  if ! $BASE_DIR/m4-1.4.19.sh 2> /dev/null; then
    echo "$PROGRAM_NAME $PROGRAM_VERSION needs m4 which failed to install"
    exit 1
  fi
fi

if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh libiconv; then
  if ! $BASE_DIR/libiconv-1.17.sh 2> /dev/null; then
    echo "$PROGRAM_NAME $PROGRAM_VERSION needs texinfo which failed to install"
    exit 1
  fi
fi

SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/download-file.sh \
  "https://curl.se/download/${PROGRAM_FULL}.tar.xz" \
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
CFLAGS="-I${BUILD_DIR}/krb5-1.21.3/include -I${BUILD_DIR}/cyrus-sasl-2.1.28/include" \
  CPPFLAGS="-I${BUILD_DIR}/krb5-1.21.3/include -I${BUILD_DIR}/cyrus-sasl-2.1.28/include" \
  LDFLAGS="-L${BUILD_DIR}/krb5-1.21.3/lib -L${BUILD_DIR}/cyrus-sasl-2.1.28/lib" \
  ../$PROGRAM_FULL/configure --prefix=$PROGRAM_INSTALL_PREFIX \
  --with-openssl=$BUILD_DIR/libressl-3.9.2 \
  --with-zlib=$BUILD_DIR/zlib-1.3.1 \
  --with-brotli=$BUILD_DIR/brotli-1.1.0 \
  --with-zstd=$BUILD_DIR/zstd-1.5.6 \
  --with-libssh2=$BUILD_DIR/libssh2-1.11.0 \
  --with-libidn2=$BUILD_DIR/libidn2-2.3.7 \
  --with-nghttp2=$BUILD_DIR/nghttp2-1.63.0 \
  --with-ngtcp2=$BUILD_DIR/ngtcp-1.7.0 \
  --with-nghttp3=$BUILD_DIR/nghttp3-1.5.0 \
  --with-gssapi
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