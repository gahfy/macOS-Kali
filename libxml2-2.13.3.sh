#!/bin/zsh
set -e
touch $HOME/.zshrc
source $HOME/.zshrc

## Runtime dependencies: zlib, xz, icu4c, libiconv, readline and ncurses

## TO BE EDITED ACCORDING TO YOUR PREFERENCES
IS_TEMP="${TEMP:-0}"
PROGRAM_VERSION_MINOR="2.13"
PROGRAM_VERSION="2.13.3"
PROGRAM_NAME="libxml2"
SHA512_SUM="682da3fc0e15852c3963207edb66aa201cabe9ec16f1fb2ca97d6d1273daa33fff6ed70e91589204cc09bf49961dc163b5e3d9ee38fdedac957453b0fd64b36d"

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
if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh ${TEMP_PREFIX}zlib; then
  if ! TEMP=$IS_TEMP $BASE_DIR/zlib-1.3.1.sh 2> /dev/null; then
    echo "$TEMP_PREFIX$PROGRAM_NAME $PROGRAM_VERSION needs ${TEMP_PREFIX}zlib which failed to install"
    exit 1
  fi
fi
if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh ${TEMP_PREFIX}xz; then
  if ! TEMP=$IS_TEMP $BASE_DIR/xz-5.6.2.sh 2> /dev/null; then
    echo "$TEMP_PREFIX$PROGRAM_NAME $PROGRAM_VERSION needs ${TEMP_PREFIX}xz which failed to install"
    exit 1
  fi
fi
if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh ${TEMP_PREFIX}icu4c; then
  if ! TEMP=$IS_TEMP $BASE_DIR/icu4c-75.1.sh 2> /dev/null; then
    echo "$TEMP_PREFIX$PROGRAM_NAME $PROGRAM_VERSION needs ${TEMP_PREFIX}icu4c which failed to install"
    exit 1
  fi
fi
if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh ${TEMP_PREFIX}libiconv; then
  if ! TEMP=$IS_TEMP $BASE_DIR/libiconv-1.17.sh 2> /dev/null; then
    echo "$TEMP_PREFIX$PROGRAM_NAME $PROGRAM_VERSION needs ${TEMP_PREFIX}libiconv which failed to install"
    exit 1
  fi
fi
if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh ${TEMP_PREFIX}readline; then
  if ! TEMP=$IS_TEMP $BASE_DIR/readline-8.2.13.sh 2> /dev/null; then
    echo "$TEMP_PREFIX$PROGRAM_NAME $PROGRAM_VERSION needs ${TEMP_PREFIX}readline which failed to install"
    exit 1
  fi
fi
if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh ${TEMP_PREFIX}ncurses; then
  if ! TEMP=$IS_TEMP $BASE_DIR/ncurses-6.5.sh 2> /dev/null; then
    echo "$TEMP_PREFIX$PROGRAM_NAME $PROGRAM_VERSION needs ${TEMP_PREFIX}ncurses which failed to install"
    exit 1
  fi
fi
if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh ${TEMP_PREFIX}Python; then
  if ! TEMP=$IS_TEMP $BASE_DIR/Python-3.12.5.sh 2> /dev/null; then
    echo "$TEMP_PREFIX$PROGRAM_NAME $PROGRAM_VERSION needs ${TEMP_PREFIX}ncurses which failed to install"
    exit 1
  fi
fi

SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/download-file.sh \
  "https://download.gnome.org/sources/libxml2/${PROGRAM_VERSION_MINOR}/$PROGRAM_FULL.tar.xz" \
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
CFLAGS="-D_DARWIN_C_SOURCE -DNCURSES_WIDECHAR -I$BUILD_DIR/${TEMP_PREFIX}ncurses-6.5/include/ncursesw -I$BUILD_DIR/${TEMP_PREFIX}ncurses-6.5/include" \
  LDFLAGS="-L$BUILD_DIR/${TEMP_PREFIX}ncurses-6.5/lib -Wl,-search_paths_first" \
  PYTHON_CFLAGS="-I$BUILD_DIR/${TEMP_PREFIX}Python-3.12.5/Python.framework/Versions/3.12/include/python3.12" \
  PYTHON_LIBS="-L$BUILD_DIR/${TEMP_PREFIX}Python-3.12.5/Python.framework/Versions/3.12/lib" \
  Z_CFLAGS="-I$BUILD_DIR/${TEMP_PREFIX}zlib-1.3.1/include" \
  Z_LIBS="-L$BUILD_DIR/${TEMP_PREFIX}zlib-1.3.1/lib" \
  LZMA_CFLAGS="-I$BUILD_DIR/${TEMP_PREFIX}xz-5.6.2/include" \
  LZMA_LIBS="-L$BUILD_DIR/${TEMP_PREFIX}xz-5.6.2/lib" \
  ICU_CFLAGS="-I$BUILD_DIR/${TEMP_PREFIX}icu4c-75.1/include" \
  ICU_LIBS="-L$BUILD_DIR/${TEMP_PREFIX}icu4c-75.1/lib -licuuc" \
  ../$PROGRAM_FULL/configure --prefix=$PROGRAM_INSTALL_PREFIX \
  --with-readline=$BUILD_DIR/${TEMP_PREFIX}readline-8.2.13 \
  --with-history \
  --with-icu \
  --with-iconv=$BUILD_DIR/${TEMP_PREFIX}libiconv-1.17 \
  --with-lzma=$BUILD_DIR/${TEMP_PREFIX}xz-5.6.2 \
  --with-zlib=$BUILD_DIR/${TEMP_PREFIX}zlib-1.3.1 \
  --with-python \
  --enable-static
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