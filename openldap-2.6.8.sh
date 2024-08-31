#!/bin/zsh
set -e
touch $HOME/.zshrc
source $HOME/.zshrc

# Runtime dependencies: cyrus-sasl and libressl

## TO BE EDITED ACCORDING TO YOUR PREFERENCES
PROGRAM_VERSION="2.6.8"
PROGRAM_NAME="openldap"
SHA512_SUM="c86bda8a0af2645e586d56a1494a5bd486ec5dd55c47859dbabcc2bb6ddc0a8307e23c6b58228d49ee3c8bc5e4d6ead305863442efdcee3dc2ab9953097b5a77"

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

if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh libressl; then
  if ! $BASE_DIR/libressl-3.9.2.sh 2> /dev/null; then
    echo "$PROGRAM_NAME $PROGRAM_VERSION needs libiconv which failed to install"
    exit 1
  fi
fi

if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh cyrus-sasl; then
  if ! $BASE_DIR/cyrus-sasl-2.1.28.sh 2> /dev/null; then
    echo "$PROGRAM_NAME $PROGRAM_VERSION needs cyrus-sasl which failed to install"
    exit 1
  fi
fi

SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/download-file.sh \
  "https://www.openldap.org/software/download/OpenLDAP/openldap-release/${PROGRAM_FULL}.tgz" \
  "$PROGRAM_FULL.tgz" \
  "$SHA512_SUM"
cd $SOURCES_DIR
tar -xf $PROGRAM_FULL.tgz
cp $BASE_DIR/patches/$PROGRAM_FULL.patch $SOURCES_DIR/$PROGRAM_FULL.patch
patch --directory=$PROGRAM_FULL/ --strip=1 < $SOURCES_DIR/$PROGRAM_FULL.patch
if [ -d "$SOURCES_DIR/$PROGRAM_NAME-build" ]; then
  echo "Removing build directory"
  rm -rf $SOURCES_DIR/$PROGRAM_NAME-build
fi
mkdir -p $PROGRAM_NAME-build
cd $PROGRAM_NAME-build
CFLAGS="-I${BUILD_DIR}/cyrus-sasl-2.1.28/include -I${BUILD_DIR}/libressl-3.9.2/include" \
  CPPFLAGS="-I${BUILD_DIR}/cyrus-sasl-2.1.28/include -I${BUILD_DIR}/libressl-3.9.2/include" \
  LDFLAGS="-L${BUILD_DIR}/cyrus-sasl-2.1.28/lib -L${BUILD_DIR}/libressl-3.9.2/lib" \
  ../$PROGRAM_FULL/configure --prefix=$PROGRAM_INSTALL_PREFIX \
  --enable-accesslog \
  --enable-auditlog \
  --enable-bdb=no \
  --enable-constraint \
  --enable-dds \
  --enable-deref \
  --enable-dyngroup \
  --enable-dynlist \
  --enable-hdb=no \
  --enable-memberof \
  --enable-ppolicy \
  --enable-proxycache \
  --enable-refint \
  --enable-retcode \
  --enable-seqmod \
  --enable-translucent \
  --enable-unique \
  --enable-valsort \
  --with-tls=openssl
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