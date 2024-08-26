#!/bin/zsh
set -e
touch $HOME/.zshrc
source $HOME/.zshrc

## Runtime dependencies: ncurses

## TO BE EDITED ACCORDING TO YOUR PREFERENCES
IS_TEMP="${TEMP:-0}"
PROGRAM_VERSION="8.2.13"
PROGRAM_NAME="readline"
SHA512_SUM="53476c88fedcc8831bc4926c32943700dc6e99b1aa17b68fb1e59d885c609db9e335314428f98d962e4f06a1ef5433e763ec1b6fa41ee5580c05ec5380ba563a"

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
if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh ${TEMP_PREFIX}ncurses; then
  if ! TEMP=$IS_TEMP $BASE_DIR/ncurses-6.5.sh 2> /dev/null; then
    echo "$TEMP_PREFIX$PROGRAM_NAME $PROGRAM_VERSION needs ${TEMP_PREFIX}ncurses which failed to install"
    exit 1
  fi
fi

SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/download-file.sh \
  "https://ftp.gnu.org/gnu/readline/${PROGRAM_FULL}.tar.gz" \
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
CFLAGS="-D_DARWIN_C_SOURCE -DNCURSES_WIDECHAR -I$BUILD_DIR/${TEMP_PREFIX}ncurses-6.5/include/ncursesw -I$BUILD_DIR/${TEMP_PREFIX}ncurses-6.5/include" \
  LDFLAGS="-L$BUILD_DIR/${TEMP_PREFIX}ncurses-6.5/lib -Wl,-search_paths_first" \
  ../$PROGRAM_FULL/configure --prefix=$PROGRAM_INSTALL_PREFIX \
  --with-curses
make -j$(sysctl -n hw.ncpu)
make -j$(sysctl -n hw.ncpu) check
make -j$(sysctl -n hw.ncpu) install
cd $SOURCES_DIR
rm -rf $PROGRAM_FULL
rm -rf $PROGRAM_NAME-build
if [ -L $INSTALL_DIR/$PROGRAM_NAME ]; then
    rm $INSTALL_DIR/$PROGRAM_NAME
fi
ln -s ../build/$TEMP_PREFIX$PROGRAM_FULL $INSTALL_DIR/$PROGRAM_NAME
SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/apply_installation.sh $PROGRAM_NAME $INSTALL_DIR