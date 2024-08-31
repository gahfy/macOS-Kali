#!/bin/zsh
set -e
touch $HOME/.zshrc
source $HOME/.zshrc

# Runtime dependencies: ncurses and libiconv

## TO BE EDITED ACCORDING TO YOUR PREFERENCES
PROGRAM_VERSION="2.0.1"
PROGRAM_NAME="libnsl"
SHA512_SUM="0ffdf15b4380fc89bf11f4f64b74ed999099c0ab3ee39cafd52f933a5000f9b1ed3987c8c13533a7cd92474aadd4cc9909a2e1eabc9143f0cb11746385e5fc57"

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

if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh libtirpc; then
  if ! $BASE_DIR/libtirpc-1.3.5.sh 2> /dev/null; then
    echo "$PROGRAM_NAME $PROGRAM_VERSION needs libtirpc which failed to install"
    exit 1
  fi
fi

SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/download-file.sh \
  "https://github.com/thkukuk/libnsl/releases/download/v${PROGRAM_VERSION}/${PROGRAM_FULL}.tar.xz" \
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
CFLAGS="-I$BUILD_DIR/gettext-0.22.5/include" \
  LDFLAGS="-L$BUILD_DIR/gettext-0.22.5/lib" \
  TIRPC_CFLAGS="-I$BUILD_DIR/libtirpc-1.3.5/include/tirpc" \
  TIRPC_LIBS="-L$BUILD_DIR/libtirpc-1.3.5/lib" \
  ../$PROGRAM_FULL/configure --prefix=$PROGRAM_INSTALL_PREFIX \
  --with-libintl-prefix="$BUILD_DIR/gettext-0.22.5" \
  --with-libiconv-prefix="$BUILD_DIR/libiconv-1.17"
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