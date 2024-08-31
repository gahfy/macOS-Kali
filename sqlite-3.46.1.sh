#!/bin/zsh
set -e
touch $HOME/.zshrc
source $HOME/.zshrc

# No runtime dependencies

## TO BE EDITED ACCORDING TO YOUR PREFERENCES
PROGRAM_VERSION="3.46.1"
PROGRAM_WEB_VERSION="3460100"
PROGRAM_NAME="sqlite"
SHA512_SUM="a5ba5af9c8d6440d39ba67e3d5903c165df3f1d111e299efbe7c1cca4876d4d5aecd722e0133670daa6eb5cbf8a85c6a3d9852ab507a393615fb5245a3e1a743"

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
if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh readline; then
  if ! $BASE_DIR/readline-8.2.13.sh 2> /dev/null; then
    echo "$PROGRAM_NAME $PROGRAM_VERSION needs readline which failed to install"
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
  "https://www.sqlite.org/2024/sqlite-autoconf-${PROGRAM_WEB_VERSION}.tar.gz" \
  "sqlite-autoconf-${PROGRAM_WEB_VERSION}.tar.gz" \
  "$SHA512_SUM"
cd $SOURCES_DIR
tar -xf sqlite-autoconf-${PROGRAM_WEB_VERSION}.tar.gz
cp $BASE_DIR/patches/$PROGRAM_FULL.patch $SOURCES_DIR/$PROGRAM_FULL.patch
patch --directory=sqlite-autoconf-${PROGRAM_WEB_VERSION}/ --strip=1 < $SOURCES_DIR/$PROGRAM_FULL.patch
if [ -d "$SOURCES_DIR/$PROGRAM_NAME-build" ]; then
  echo "Removing build directory"
  rm -rf $SOURCES_DIR/$PROGRAM_NAME-build
fi
mkdir -p $PROGRAM_NAME-build
cd $PROGRAM_NAME-build
CFLAGS="-I$BUILD_DIR/zlib-1.3.1/include -I$BUILD_DIR/readline-8.2.13/include -D_DARWIN_C_SOURCE -DNCURSES_WIDECHAR -I$BUILD_DIR/ncurses-6.5/include -I$BUILD_DIR/ncurses-6.5/include/ncurses -DSQLITE_ENABLE_API_ARMOR=1 -DSQLITE_ENABLE_COLUMN_METADATA=1 -DSQLITE_ENABLE_DBSTAT_VTAB=1 -DSQLITE_ENABLE_FTS3=1 -DSQLITE_ENABLE_FTS3_PARENTHESIS=1 -DSQLITE_ENABLE_FTS5=1 -DSQLITE_ENABLE_JSON1=1 -DSQLITE_ENABLE_MEMORY_MANAGEMENT=1 -DSQLITE_ENABLE_RTREE=1 -DSQLITE_ENABLE_STAT4=1 -DSQLITE_ENABLE_UNLOCK_NOTIFY=1 -DSQLITE_MAX_VARIABLE_NUMBER=250000 -DSQLITE_USE_URI=1"
  CPPFLAGS="-I$BUILD_DIR/zlib-1.3.1/include -I$BUILD_DIR/readline-8.2.13/include -D_DARWIN_C_SOURCE -DNCURSES_WIDECHAR -I$BUILD_DIR/ncurses-6.5/include -I$BUILD_DIR/ncurses-6.5/include/ncurses -DSQLITE_ENABLE_API_ARMOR=1 -DSQLITE_ENABLE_COLUMN_METADATA=1 -DSQLITE_ENABLE_DBSTAT_VTAB=1 -DSQLITE_ENABLE_FTS3=1 -DSQLITE_ENABLE_FTS3_PARENTHESIS=1 -DSQLITE_ENABLE_FTS5=1 -DSQLITE_ENABLE_JSON1=1 -DSQLITE_ENABLE_MEMORY_MANAGEMENT=1 -DSQLITE_ENABLE_RTREE=1 -DSQLITE_ENABLE_STAT4=1 -DSQLITE_ENABLE_UNLOCK_NOTIFY=1 -DSQLITE_MAX_VARIABLE_NUMBER=250000 -DSQLITE_USE_URI=1"
  LDFLAGS="-L$BUILD_DIR/zlib-1.3.1/lib -L$BUILD_DIR/readline-8.2.13/lib -L$BUILD_DIR/ncurses-6.5/lib -Wl,-search_paths_first" \
  ../sqlite-autoconf-${PROGRAM_WEB_VERSION}/configure --prefix=$PROGRAM_INSTALL_PREFIX \
  --enable-dynamic-extensions \
  --enable-readline \
  --enable-session
make -j$(sysctl -n hw.ncpu)
make -j$(sysctl -n hw.ncpu) check
make -j$(sysctl -n hw.ncpu) install
cd $SOURCES_DIR
rm -rf sqlite-autoconf-${PROGRAM_WEB_VERSION}
rm -rf $PROGRAM_NAME-build
if [ -L $INSTALL_DIR/$PROGRAM_NAME ]; then
    rm $INSTALL_DIR/$PROGRAM_NAME
fi
ln -s ../build/$PROGRAM_FULL $INSTALL_DIR/$PROGRAM_NAME
SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/apply_installation.sh $PROGRAM_NAME $INSTALL_DIR