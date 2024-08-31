#!/bin/zsh
set -e
touch $HOME/.zshrc
source $HOME/.zshrc

# Runtime dependencies: ncurses and libiconv

## TO BE EDITED ACCORDING TO YOUR PREFERENCES
PROGRAM_VERSION="18.1.40"
PROGRAM_NAME="berkeley-db"
SHA512_SUM="53787164fb8a198a0178c7f58d891c2b0943d1c52b11fe9de525938469327e85664f0bc63e33d740c171bc370954710a6b3e8b9be2a08237fb9757a795c5b19e"

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

if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh libedit; then
  if ! $BASE_DIR/libedit-3.1.2024.08.08.sh 2> /dev/null; then
    echo "$PROGRAM_NAME $PROGRAM_VERSION needs libedit which failed to install"
    exit 1
  fi
fi

if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh bison; then
  if ! $BASE_DIR/bison-3.8.2.sh 2> /dev/null; then
    echo "$PROGRAM_NAME $PROGRAM_VERSION needs bison which failed to install"
    exit 1
  fi
fi

SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/download-file.sh \
  "https://download.oracle.com/berkeley-db/db-${PROGRAM_VERSION}.tar.gz" \
  "db-${PROGRAM_VERSION}.tar.gz" \
  "$SHA512_SUM"
cd $SOURCES_DIR
tar -xf db-${PROGRAM_VERSION}.tar.gz
cd db-${PROGRAM_VERSION}/build_unix
  CFLAGS="-I$BUILD_DIR/temp-openssl-3.3.1/include" \
  LDFLAGS="-L$BUILD_DIR/temp-openssl-3.3.1/lib" \
  ../dist/configure --prefix=$PROGRAM_INSTALL_PREFIX \
  --enable-cxx \
  --enable-compat185 \
  --enable-sql \
  --enable-sql_codegen \
  --enable-dbm
make
make check
make install DOCLIST=license
cd $SOURCES_DIR
rm -rf db-${PROGRAM_VERSION}
if [ -L $INSTALL_DIR/$PROGRAM_NAME ]; then
    rm $INSTALL_DIR/$PROGRAM_NAME
fi
ln -s ../build/$PROGRAM_FULL $INSTALL_DIR/$PROGRAM_NAME
SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/apply_installation.sh $PROGRAM_NAME $INSTALL_DIR