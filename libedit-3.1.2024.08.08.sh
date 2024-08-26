
#!/bin/zsh

#!/bin/zsh
set -e
touch $HOME/.zshrc
source $HOME/.zshrc

## Runtime dependencies : ncurses

## TO BE EDITED ACCORDING TO YOUR PREFERENCES
IS_TEMP="${TEMP:-0}"
PROGRAM_VERSION="3.1.2024.08.08"
WEB_VERSION="20240808-3.1"
PROGRAM_NAME="libedit"
WEB_FILENAME="$PROGRAM_NAME-$WEB_VERSION"
SHA512_SUM="b11d64947f9484bb2320b0fbcfdc94466993af1dfa0d853853b73c222e95d6c1e78d88d0c305929b95bf7a85009129475c9fef0ac8595b43d75543d85052a4ff"

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
if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh ${TEMP_PREFIX}ncurses > /dev/null; then
  if ! TEMP=$IS_TEMP $BASE_DIR/ncurses-6.5.sh 2> /dev/null; then
    echo "$TEMP_PREFIX$PROGRAM_NAME $PROGRAM_VERSION needs ${TEMP_PREFIX}ncurses which failed to install"
    exit 1
  fi
fi

SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/download-file.sh \
  "https://thrysoee.dk/editline/$WEB_FILENAME.tar.gz" \
  "$WEB_FILENAME.tar.gz" \
  "$SHA512_SUM"
cd $SOURCES_DIR
tar -xf $WEB_FILENAME.tar.gz
if [ -d "$SOURCES_DIR/$PROGRAM_NAME-build" ]; then
  echo "Removing build directory"
  rm -rf $SOURCES_DIR/$PROGRAM_NAME-build
fi
mkdir -p $PROGRAM_NAME-build
cd $PROGRAM_NAME-build
CFLAGS="-I$BUILD_DIR/${TEMP_PREFIX}ncurses-6.5/include/ncursesw -I$BUILD_DIR/${TEMP_PREFIX}ncurses-6.5/include -D_DARWIN_C_SOURCE -DNCURSES_WIDECHAR" \
  LDFLAGS="-L$BUILD_DIR/${TEMP_PREFIX}ncurses-6.5/lib -Wl,-search_paths_first"
../$WEB_FILENAME/configure --prefix=$PROGRAM_INSTALL_PREFIX
make -j$(sysctl -n hw.ncpu)
make -j$(sysctl -n hw.ncpu) check
make -j$(sysctl -n hw.ncpu) install
cd $SOURCES_DIR
rm -rf $WEB_FILENAME
rm -rf $PROGRAM_NAME-build
if [ -L $INSTALL_DIR/$PROGRAM_NAME ]; then
    rm $INSTALL_DIR/$PROGRAM_NAME
fi
ln -s ../build/$TEMP_PREFIX$PROGRAM_FULL $INSTALL_DIR/$PROGRAM_NAME
SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/apply_installation.sh $PROGRAM_NAME $INSTALL_DIR