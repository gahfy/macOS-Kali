#!/bin/zsh
set -e
touch $HOME/.zshrc
source $HOME/.zshrc

## TO BE EDITED ACCORDING TO YOUR PREFERENCES
PROGRAM_VERSION="1.5.1"
PROGRAM_NAME="meson"
SHA512_SUM="3239d6f3d64dcedddd456dc451278a37aa6c4460708b0efdff1b04b6e8844c20f5f882060de311c59a678bebd51ee09e1906c9384d4b0c85b28015fd1713ab0a"

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

if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh temp-Python && ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh Python; then
  if ! TEMP=1 $BASE_DIR/Python-3.12.5.sh 2> /dev/null; then
    echo "$PROGRAM_NAME $PROGRAM_VERSION needs Python (at least temporary version) which failed to install"
    exit 1
  fi
fi
if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh setuptools; then
  if ! TEMP=1 $BASE_DIR/setuptools-73.0.0.sh 2> /dev/null; then
    echo "$PROGRAM_NAME $PROGRAM_VERSION needs setuptools which failed to install"
    exit 1
  fi
fi

SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/download-file.sh \
  "https://github.com/mesonbuild/meson/releases/download/${PROGRAM_VERSION}/${PROGRAM_FULL}.tar.gz" \
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
pip3 install ../$PROGRAM_FULL --prefix=$PROGRAM_INSTALL_PREFIX
cd $SOURCES_DIR
rm -rf $PROGRAM_FULL
rm -rf $PROGRAM_NAME-build
if [ -L $INSTALL_DIR/$PROGRAM_NAME ]; then
    rm $INSTALL_DIR/$PROGRAM_NAME
fi
ln -s ../build/$PROGRAM_FULL $INSTALL_DIR/$PROGRAM_NAME
SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/apply_installation.sh $PROGRAM_NAME $INSTALL_DIR