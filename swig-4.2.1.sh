#!/bin/zsh
set -e
touch $HOME/.zshrc
source $HOME/.zshrc

## Runtime dependencies: PCRE2 and zlib

## TO BE EDITED ACCORDING TO YOUR PREFERENCES
IS_TEMP="${TEMP:-0}"
PROGRAM_VERSION="4.2.1"
PROGRAM_NAME="swig"
SHA512_SUM="019dee5a46d57e1030eef47cd5d007ccaadbdcd4e53cd30d7c795f0118ecf4406a78185534502c81c5f6d7bac0713256e7e19b20b5a2d14e2c552219edbaf5cf"

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
if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh ${TEMP_PREFIX}pcre2; then
  if ! TEMP=$IS_TEMP $BASE_DIR/pcre2-10.44.sh 2> /dev/null; then
    echo "$TEMP_PREFIX$PROGRAM_NAME $PROGRAM_VERSION needs ${TEMP_PREFIX}pcre2 which failed to install"
    exit 1
  fi
fi
if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh ${TEMP_PREFIX}zlib; then
  if ! TEMP=$IS_TEMP $BASE_DIR/zlib-1.3.1.sh 2> /dev/null; then
    echo "$TEMP_PREFIX$PROGRAM_NAME $PROGRAM_VERSION needs ${TEMP_PREFIX}zlib which failed to install"
    exit 1
  fi
fi

SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/download-file.sh \
  "https://sourceforge.net/projects/swig/files/swig/$PROGRAM_FULL/$PROGRAM_FULL.tar.gz" \
  "$PROGRAM_FULL.tar.gz" \
  "$SHA512_SUM"
cd $SOURCES_DIR
tar -xf $PROGRAM_FULL.tar.gz
echo 'diff --git a/Makefile.in b/Makefile.in' > $PROGRAM_FULL.patch
echo '--- a/Makefile.in' >> $PROGRAM_FULL.patch
echo '+++ b/Makefile.in' >> $PROGRAM_FULL.patch
echo '@@ -36,7 +36,7 @@' >> $PROGRAM_FULL.patch
echo ' 	@cd $(SOURCE) && $(MAKE)' >> $PROGRAM_FULL.patch
echo ' ' >> $PROGRAM_FULL.patch
echo ' ccache:' >> $PROGRAM_FULL.patch
echo '-	test -z "$(ENABLE_CCACHE)" || (cd $(CCACHE) && $(MAKE))' >> $PROGRAM_FULL.patch
echo '+	test -z "$(ENABLE_CCACHE)" || (cd $(CCACHE) && CFLAGS="-I'"$BUILD_DIR"'/'"$TEMP_PREFIX"'zlib-1.3.1/include" LDFLAGS="-L'"$BUILD_DIR"'/'"$TEMP_PREFIX"'zlib-1.3.1/lib" $(MAKE))' >> $PROGRAM_FULL.patch
echo ' ' >> $PROGRAM_FULL.patch
echo ' libfiles: $(srcdir)/Lib/swigwarn.swg' >> $PROGRAM_FULL.patch
echo ' ' >> $PROGRAM_FULL.patch
echo '' >> $PROGRAM_FULL.patch
patch --directory=$PROGRAM_FULL/ --strip=1 < $PROGRAM_FULL.patch
if [ -d "$SOURCES_DIR/$PROGRAM_NAME-build" ]; then
  echo "Removing build directory"
  rm -rf $SOURCES_DIR/$PROGRAM_NAME-build
fi
mkdir -p $PROGRAM_NAME-build
cd $PROGRAM_NAME-build
../$PROGRAM_FULL/configure --prefix=$PROGRAM_INSTALL_PREFIX \
  --with-pcre2-prefix=$BUILD_DIR/${TEMP_PREFIX}pcre2-10.44
make -j$(sysctl -n hw.ncpu)
make -j$(sysctl -n hw.ncpu) install
cd $SOURCES_DIR
rm -rf $PROGRAM_FULL
rm -rf $PROGRAM_NAME-build
if [ -L $INSTALL_DIR/$PROGRAM_NAME ]; then
    rm $INSTALL_DIR/$PROGRAM_NAME
fi
ln -s ../build/$TEMP_PREFIX$PROGRAM_FULL $INSTALL_DIR/$PROGRAM_NAME
SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/apply_installation.sh $PROGRAM_NAME $INSTALL_DIR