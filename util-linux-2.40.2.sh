#!/bin/zsh
set -e
touch $HOME/.zshrc
source $HOME/.zshrc

# Runtime dependencies: ncurses

## TO BE EDITED ACCORDING TO YOUR PREFERENCES
PROGRAM_VERSION_MINOR="2.40"
PROGRAM_VERSION="2.40.2"
PROGRAM_NAME="util-linux"
SHA512_SUM="ffe20b915a518a150401d429b0338bc7022190e4ca0ef91a6d9eea345db8c1e11ad01784163b8fcf978506f3f5cad473f29d5d4ef93a4c66a5ae0ebd9fb0c8f2"

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

if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh ncurses; then
  if ! $BASE_DIR/ncurses6.5.sh 2> /dev/null; then
    echo "$PROGRAM_NAME $PROGRAM_VERSION needs ncurses which failed to install"
    exit 1
  fi
fi

SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/download-file.sh \
  "https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v${PROGRAM_VERSION_MINOR}/${PROGRAM_FULL}.tar.xz" \
  "$PROGRAM_FULL.tar.xz" \
  "$SHA512_SUM"
cd $SOURCES_DIR
tar -xf $PROGRAM_FULL.tar.xz
cp $BASE_DIR/patches/$PROGRAM_FULL.patch $SOURCES_DIR/$PROGRAM_FULL.patch
patch --directory=$PROGRAM_FULL/ --strip=1 < $SOURCES_DIR/$PROGRAM_FULL.patch
if [ -d "$SOURCES_DIR/$PROGRAM_NAME-build" ]; then
  echo "Removing build directory"
  rm -rf $SOURCES_DIR/$PROGRAM_NAME-build
fi
mkdir -p $PROGRAM_NAME-build
cd $PROGRAM_NAME-build
../$PROGRAM_FULL/configure --prefix=$PROGRAM_INSTALL_PREFIX \
  --disable-use-tty-group --disable-liblastlog2
make -j$(sysctl -n hw.ncpu)
make -j$(sysctl -n hw.ncpu) install
cd $SOURCES_DIR
rm -rf $PROGRAM_FULL
rm -rf $PROGRAM_NAME-build
if [ -L $INSTALL_DIR/$PROGRAM_NAME ]; then
    rm $INSTALL_DIR/$PROGRAM_NAME
fi
ln -s ../build/$PROGRAM_FULL $INSTALL_DIR/$PROGRAM_NAME
SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/apply_installation.sh $PROGRAM_NAME $INSTALL_DIR