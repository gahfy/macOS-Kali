#!/bin/zsh
set -e
touch $HOME/.zshrc
source $HOME/.zshrc

## TO BE EDITED ACCORDING TO YOUR PREFERENCES
IS_TEMP="${TEMP:-0}"
PROGRAM_VERSION_MINOR="3.12"
PROGRAM_VERSION="3.12.5"
PROGRAM_NAME="Python"
SHA512_SUM="7a1c30d798434fe24697bc253f6010d75145e7650f66803328425c8525331b9fa6b63d12a652687582db205f8d4c8279c8f73c338168592481517b063351c921"

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
  other_checks
fi
if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh ${TEMP_PREFIX}xz; then
  if ! TEMP=$IS_TEMP $BASE_DIR/xz-1.3.1.sh 2> /dev/null; then
    echo "$TEMP_PREFIX$PROGRAM_NAME $PROGRAM_VERSION needs ${TEMP_PREFIX}xz which failed to install"
    exit 1
  fi
fi
if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh ${TEMP_PREFIX}openssl; then
  if ! TEMP=$IS_TEMP $BASE_DIR/openssl-3.3.1.sh 2> /dev/null; then
    echo "$TEMP_PREFIX$PROGRAM_NAME $PROGRAM_VERSION needs ${TEMP_PREFIX}openssl which failed to install"
    exit 1
  fi
fi

SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/download-file.sh \
  "https://www.python.org/ftp/python/$PROGRAM_VERSION/$PROGRAM_FULL.tar.xz" \
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
OLD_PATH=$PATH
export PATH="$PROGRAM_INSTALL_PREFIX/bin:$PATH"
LIBLZMA_CFLAGS="-I${BUILD_DIR}/${TEMP_PREFIX}xz-5.6.2/include" \
  LIBLZMA_LIBS="-L${BUILD_DIR}/${TEMP_PREFIX}xz-5.6.2/lib" \
  ../$PROGRAM_FULL/configure --prefix=$PROGRAM_INSTALL_PREFIX \
  --with-openssl=${BUILD_DIR}/${TEMP_PREFIX}openssl-3.3.1 --enable-optimizations \
  --enable-framework=$PROGRAM_INSTALL_PREFIX
make -j$(sysctl -n hw.ncpu)
if ((IS_TEMP == 0)); then
  make -j$(sysctl -n hw.ncpu) test
fi
make install
export PATH=$OLD_PATH
cd $SOURCES_DIR
rm -rf $PROGRAM_FULL
rm -rf $PROGRAM_NAME-build
if [ -L $INSTALL_DIR/$PROGRAM_NAME ]; then
    rm $INSTALL_DIR/$PROGRAM_NAME
fi
ln -s ../build/$TEMP_PREFIX$PROGRAM_FULL $INSTALL_DIR/$PROGRAM_NAME

touch $HOME/.zshrc
line=""
current_line=$(echo 'export CMAKE_FRAMEWORK_PATH="'"$INSTALL_DIR/$PROGRAM_NAME"':$CMAKE_FRAMEWORK_PATH"')
if ! grep -Fxq "$current_line" $HOME/.zshrc; then
  line="$line"$'\n'"$current_line"
fi
current_line=$(echo 'export PATH="'"$INSTALL_DIR/$PROGRAM_NAME"'/Python.framework/Versions/'"$PROGRAM_VERSION_MINOR"'/bin:$PATH"')
if ! grep -Fxq "$current_line" $HOME/.zshrc; then
  line="$line"$'\n'"$current_line"
fi
current_line=$(echo 'export PKG_CONFIG_PATH="'"$INSTALL_DIR/$PROGRAM_NAME"'/Python.framework/Versions/'"$PROGRAM_VERSION_MINOR"'/lib/pkgconfig:$PKG_CONFIG_PATH"')
if ! grep -Fxq "$current_line" $HOME/.zshrc; then
  line="$line"$'\n'"$current_line"
fi
current_line=$(echo 'export MANPATH="'"$INSTALL_DIR/$PROGRAM_NAME"'/Python.framework/Versions/'"$PROGRAM_VERSION_MINOR"'/share/man:$MANPATH"')
if ! grep -Fxq "$current_line" $HOME/.zshrc; then
  line="$line"$'\n'"$current_line"
fi

if [ -n "$line" ]; then
  echo '' >> $HOME/.zshrc
  echo "## Python$line" >> $HOME/.zshrc
fi