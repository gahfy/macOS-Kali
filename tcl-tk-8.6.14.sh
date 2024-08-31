#!/bin/zsh
set -e
touch $HOME/.zshrc
source $HOME/.zshrc

# Runtime dependencies: zlib

## TO BE EDITED ACCORDING TO YOUR PREFERENCES
PROGRAM_VERSION_MINOR="8.6"
PROGRAM_VERSION="8.6.14"
PROGRAM_NAME="tcl-tk"
TCL_SHA512_SUM="706603faa94153fcea2e2b2c594fb9d9862ce1aa3a65b864f14ce0757ea97c4106f065d1696e35f8cacc577db3d82ef1e93385c71a2399416816c4e1582237b0"
TK_SHA512_SUM="756903dfa56cf77c7934bb3680c9bef6027f99196f4e6a2e823b85c342ca860cbb4b42154f576cc88f7f1265d28ce2d84ab5f52f848b16cca0cf9af4c770183f"

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

if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh zlib; then
  if ! $BASE_DIR/zlib-1.3.1.sh 2> /dev/null; then
    echo "$PROGRAM_NAME $PROGRAM_VERSION needs zlib which failed to install"
    exit 1
  fi
fi

SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/download-file.sh \
  "http://prdownloads.sourceforge.net/tcl/tcl${PROGRAM_VERSION}-src.tar.gz" \
  "tcl${PROGRAM_VERSION}-src.tar.gz" \
  "$TCL_SHA512_SUM"
SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/download-file.sh \
  "http://prdownloads.sourceforge.net/tcl/tk${PROGRAM_VERSION}-src.tar.gz" \
  "tk${PROGRAM_VERSION}-src.tar.gz" \
  "$TK_SHA512_SUM"
cd $SOURCES_DIR
tar -xf tcl${PROGRAM_VERSION}-src.tar.gz
if [ -d "$SOURCES_DIR/tcl-build" ]; then
  echo "Removing build directory"
  rm -rf $SOURCES_DIR/tcl-build
fi
mkdir -p tcl-build
cd tcl-build
CFLAGS="-I$BUILD_DIR/zlib-1.3.1/include" \
  LDFLAGS="-L$BUILD_DIR/zlib-1.3.1/lib" \
  ../tcl${PROGRAM_VERSION}/unix/configure --prefix=$PROGRAM_INSTALL_PREFIX \
  --enable-threads \
  --enable-64bit
make -j$(sysctl -n hw.ncpu)
make -j$(sysctl -n hw.ncpu) install
make -j$(sysctl -n hw.ncpu) install-private-headers
install_name_tool -id $PROGRAM_INSTALL_PREFIX/lib/itcl4.2.4/libitcl4.2.4.dylib $PROGRAM_INSTALL_PREFIX/lib/itcl4.2.4/libitcl4.2.4.dylib
install_name_tool -id $PROGRAM_INSTALL_PREFIX/lib/sqlite3.44.2/libsqlite3.44.2.dylib $PROGRAM_INSTALL_PREFIX/lib/sqlite3.44.2/libsqlite3.44.2.dylib
install_name_tool -id $PROGRAM_INSTALL_PREFIX/lib/tdbc1.1.7/libtdbc1.1.7.dylib $PROGRAM_INSTALL_PREFIX/lib/tdbc1.1.7/libtdbc1.1.7.dylib
install_name_tool -id $PROGRAM_INSTALL_PREFIX/lib/tdbcmysql1.1.7/libtdbcmysql1.1.7.dylib $PROGRAM_INSTALL_PREFIX/lib/tdbcmysql1.1.7/libtdbcmysql1.1.7.dylib
install_name_tool -id $PROGRAM_INSTALL_PREFIX/lib/tdbcodbc1.1.7/libtdbcodbc1.1.7.dylib $PROGRAM_INSTALL_PREFIX/lib/tdbcodbc1.1.7/libtdbcodbc1.1.7.dylib
install_name_tool -id $PROGRAM_INSTALL_PREFIX/lib/tdbcpostgres1.1.7/libtdbcpostgres1.1.7.dylib $PROGRAM_INSTALL_PREFIX/lib/tdbcpostgres1.1.7/libtdbcpostgres1.1.7.dylib
install_name_tool -id $PROGRAM_INSTALL_PREFIX/lib/thread2.8.9/libthread2.8.9.dylib $PROGRAM_INSTALL_PREFIX/lib/thread2.8.9/libthread2.8.9.dylib
make -j$(sysctl -n hw.ncpu) test
ln -s tclsh${PROGRAM_VERSION_MINOR} $PROGRAM_INSTALL_PREFIX/bin/tclsh
cd $SOURCES_DIR
tar -xf tk${PROGRAM_VERSION}-src.tar.gz
if [ -d "$SOURCES_DIR/tk-build" ]; then
  echo "Removing build directory"
  rm -rf $SOURCES_DIR/tk-build
fi
mkdir -p tk-build
cd tk-build
CFLAGS="-I$BUILD_DIR/zlib-1.3.1/include" \
  LDFLAGS="-L$BUILD_DIR/build/zlib-1.3.1/lib" \
  ../tk${PROGRAM_VERSION}/unix/configure --prefix=$PROGRAM_INSTALL_PREFIX \
  --enable-threads \
  --enable-64bit \
  --without-x \
  --with-tcl=$PROGRAM_INSTALL_PREFIX/lib \
  --enable-aqua=yes
make -j$(sysctl -n hw.ncpu)
make -j$(sysctl -n hw.ncpu) install
make -j$(sysctl -n hw.ncpu) install-private-headers
cd $SOURCES_DIR
ln -s wish${PROGRAM_VERSION_MINOR} $PROGRAM_INSTALL_PREFIX/bin/wish
rm -rf tcl${PROGRAM_VERSION}
rm -rf tk${PROGRAM_VERSION}
rm -rf tcl-build
rm -rf tk-build
ln -s ../build/${PROGRAM_FULL} $INSTALL_DIR/${PROGRAM_NAME}
SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/apply_installation.sh $PROGRAM_NAME $INSTALL_DIR