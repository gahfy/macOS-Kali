#!/bin/zsh
set -e
touch $HOME/.zshrc
source $HOME/.zshrc

## TO BE EDITED ACCORDING TO YOUR PREFERENCES
PROGRAM_VERSION="73.0.0"
PROGRAM_NAME="setuptools"
SHA512_SUM="9f7b75abec18c2e011533d9389bf36c5124bb4be5e250f19f04fb73aeb4f54e65d490209305134a6bf196604be0a96b07d5bb2acefc2dce293c5dc0dadebe3dc"

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

SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/download-file.sh \
  "https://github.com/pypa/setuptools/archive/refs/tags/v${PROGRAM_VERSION}.tar.gz" \
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