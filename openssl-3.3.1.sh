#!/bin/zsh
set -e
touch $HOME/.zshrc
source $HOME/.zshrc

## No runtime dependencies

## TO BE EDITED ACCORDING TO YOUR PREFERENCES
IS_TEMP="${TEMP:-0}"
PROGRAM_VERSION="3.3.1"
PROGRAM_NAME="openssl"
SHA512_SUM="d3682a5ae0721748c6b9ec2f1b74d2b1ba61ee6e4c0d42387b5037a56ef34312833b6abb522d19400b45d807dd65cc834156f5e891cb07fbaf69fcf67e1c595d"

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
if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh mozilla-ca; then
  if ! TEMP=0 $BASE_DIR/mozilla-ca-2024.07.02.sh 2> /dev/null; then
    echo "$TEMP_PREFIX$PROGRAM_NAME $PROGRAM_VERSION needs Mozilla CA which failed to install"
    exit 1
  fi
fi

SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/download-file.sh \
  "https://github.com/openssl/openssl/releases/download/$PROGRAM_FULL/$PROGRAM_FULL.tar.gz" \
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
../$PROGRAM_FULL/Configure --prefix=$PROGRAM_INSTALL_PREFIX
make -j$(sysctl -n hw.ncpu)
make -j$(sysctl -n hw.ncpu) test
make -j$(sysctl -n hw.ncpu) install
cd $SOURCES_DIR
rm -rf $PROGRAM_FULL
rm -rf $PROGRAM_NAME-build
if [ -L $INSTALL_DIR/$PROGRAM_NAME ]; then
    rm $INSTALL_DIR/$PROGRAM_NAME
fi
ln -s ../build/$TEMP_PREFIX$PROGRAM_FULL $INSTALL_DIR/$PROGRAM_NAME
ln -s $INSTALL_DIR/mozilla-ca/cacert.pem $INSTALL_DIR/openssl/ssl/cert.pem