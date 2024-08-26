#!/bin/zsh
set -e
touch $HOME/.zshrc
source $HOME/.zshrc

## No runtime dependencies

## TO BE EDITED ACCORDING TO YOUR PREFERENCES
IS_TEMP="${TEMP:-0}"
PROGRAM_VERSION_MAJOR="75"
PROGRAM_VERSION="75.1"
PROGRAM_NAME="icu4c"
WEB_VERSION="75-1"
WEB_FILE_VERSION="75_1"
WEB_FILENAME="$PROGRAM_NAME-$WEB_FILE_VERSION"
SHA512_SUM="70ea842f0d5f1f6c6b65696ac71d96848c4873f4d794bebc40fd87af2ad4ef064c61a786bf7bc430ce4713ec6deabb8cc1a8cc0212eab148cee2d498a3683e45"

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
  "https://github.com/unicode-org/icu/releases/download/release-${WEB_VERSION}/${WEB_FILENAME}-src.tgz" \
  "${WEB_FILENAME}-src.tar.gz" \
  "$SHA512_SUM"
cd $SOURCES_DIR
tar -xf ${WEB_FILENAME}-src.tar.gz
if [ -d "$SOURCES_DIR/$PROGRAM_NAME-build" ]; then
  echo "Removing build directory"
  rm -rf $SOURCES_DIR/$PROGRAM_NAME-build
fi
mkdir -p $PROGRAM_NAME-build
cd $PROGRAM_NAME-build
../icu/source/configure --prefix=$PROGRAM_INSTALL_PREFIX \
  --enable-static \
  --with-library-bits=64 \
  --disable-tests
make -j$(sysctl -n hw.ncpu)
make -j$(sysctl -n hw.ncpu) check
make -j$(sysctl -n hw.ncpu) install
install_name_tool -change libicutu.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicutu.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/bin/derb
install_name_tool -change libicui18n.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicui18n.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/bin/derb
install_name_tool -change libicuuc.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicuuc.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/bin/derb
install_name_tool -change libicudata.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicudata.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/bin/derb
install_name_tool -change libicutu.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicutu.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/bin/genbrk
install_name_tool -change libicui18n.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicui18n.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/bin/genbrk
install_name_tool -change libicuuc.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicuuc.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/bin/genbrk
install_name_tool -change libicudata.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicudata.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/bin/genbrk
install_name_tool -change libicutu.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicutu.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/bin/gencfu
install_name_tool -change libicui18n.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicui18n.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/bin/gencfu
install_name_tool -change libicuuc.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicuuc.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/bin/gencfu
install_name_tool -change libicudata.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicudata.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/bin/gencfu
install_name_tool -change libicutu.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicutu.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/bin/gencnval
install_name_tool -change libicui18n.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicui18n.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/bin/gencnval
install_name_tool -change libicuuc.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicuuc.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/bin/gencnval
install_name_tool -change libicudata.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicudata.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/bin/gencnval
install_name_tool -change libicutu.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicutu.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/bin/gendict
install_name_tool -change libicui18n.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicui18n.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/bin/gendict
install_name_tool -change libicuuc.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicuuc.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/bin/gendict
install_name_tool -change libicudata.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicudata.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/bin/gendict
install_name_tool -change libicutu.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicutu.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/bin/genrb
install_name_tool -change libicui18n.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicui18n.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/bin/genrb
install_name_tool -change libicuuc.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicuuc.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/bin/genrb
install_name_tool -change libicudata.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicudata.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/bin/genrb
install_name_tool -change libicutu.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicutu.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/bin/icuexportdata
install_name_tool -change libicui18n.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicui18n.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/bin/icuexportdata
install_name_tool -change libicuuc.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicuuc.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/bin/icuexportdata
install_name_tool -change libicudata.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicudata.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/bin/icuexportdata
install_name_tool -change libicutu.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicutu.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/bin/icuinfo
install_name_tool -change libicui18n.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicui18n.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/bin/icuinfo
install_name_tool -change libicuuc.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicuuc.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/bin/icuinfo
install_name_tool -change libicudata.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicudata.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/bin/icuinfo
install_name_tool -change libicutu.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicutu.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/bin/makeconv
install_name_tool -change libicui18n.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicui18n.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/bin/makeconv
install_name_tool -change libicuuc.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicuuc.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/bin/makeconv
install_name_tool -change libicudata.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicudata.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/bin/makeconv
install_name_tool -change libicutu.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicutu.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/bin/pkgdata
install_name_tool -change libicui18n.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicui18n.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/bin/pkgdata
install_name_tool -change libicuuc.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicuuc.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/bin/pkgdata
install_name_tool -change libicudata.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicudata.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/bin/pkgdata
install_name_tool -change libicui18n.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicui18n.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/bin/uconv
install_name_tool -change libicuuc.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicuuc.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/bin/uconv
install_name_tool -change libicudata.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicudata.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/bin/uconv
install_name_tool -id $PROGRAM_INSTALL_PREFIX/lib/libicudata.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicudata.${PROGRAM_VERSION}.dylib
install_name_tool -id $PROGRAM_INSTALL_PREFIX/lib/libicui18n.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicui18n.${PROGRAM_VERSION}.dylib
install_name_tool -change libicuuc.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicuuc.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicui18n.${PROGRAM_VERSION}.dylib
install_name_tool -change libicudata.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicudata.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicui18n.${PROGRAM_VERSION}.dylib
install_name_tool -id $PROGRAM_INSTALL_PREFIX/lib/libicuio.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicuio.${PROGRAM_VERSION}.dylib
install_name_tool -change libicuuc.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicuuc.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicuio.${PROGRAM_VERSION}.dylib
install_name_tool -change libicudata.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicuuc.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicuio.${PROGRAM_VERSION}.dylib
install_name_tool -change libicui18n.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicuuc.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicuio.${PROGRAM_VERSION}.dylib
install_name_tool -change libicuuc.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicuuc.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicuio.${PROGRAM_VERSION}.dylib
install_name_tool -id $PROGRAM_INSTALL_PREFIX/lib/libicuuc.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicuuc.${PROGRAM_VERSION}.dylib
install_name_tool -change libicudata.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicudata.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicuuc.${PROGRAM_VERSION}.dylib
install_name_tool -change libicudata.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicudata.${PROGRAM_VERSION_MAJOR}.dylib $PROGRAM_INSTALL_PREFIX/lib/libicuuc.${PROGRAM_VERSION}.dylib
cd $SOURCES_DIR
rm -rf icu
rm -rf $PROGRAM_NAME-build
if [ -L $INSTALL_DIR/$PROGRAM_NAME ]; then
    rm $INSTALL_DIR/$PROGRAM_NAME
fi
ln -s ../build/$TEMP_PREFIX$PROGRAM_FULL $INSTALL_DIR/$PROGRAM_NAME
SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/apply_installation.sh $PROGRAM_NAME $INSTALL_DIR