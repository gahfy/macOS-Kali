#!/bin/zsh
set -e
touch $HOME/.zshrc
source $HOME/.zshrc

# Runtime dependencies: libiconv

## TO BE EDITED ACCORDING TO YOUR PREFERENCES
PROGRAM_VERSION="7.1"
PROGRAM_NAME="texinfo"
SHA512_SUM="ceab03e8422d800b08c7b44e8263b0a1f35bb7758d83a81136df6f3304a14daecda98a12a282afb85406d2ca2f665b2295e10b6f4064156ea1285d80d5d355db"

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

SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/download-file.sh \
  "https://ftp.gnu.org/gnu/texinfo/${PROGRAM_FULL}.tar.xz" \
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
../$PROGRAM_FULL/configure --prefix=$PROGRAM_INSTALL_PREFIX
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