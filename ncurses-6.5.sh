#!/bin/zsh
set -e
touch $HOME/.zshrc
source $HOME/.zshrc

## No runtime dependencies

## TO BE EDITED ACCORDING TO YOUR PREFERENCES
IS_TEMP="${TEMP:-0}"
VERSION_MAJOR="1"
PROGRAM_VERSION="6.5"
PROGRAM_NAME="ncurses"
SHA512_SUM="fc5a13409d2a530a1325776dcce3a99127ddc2c03999cfeb0065d0eee2d68456274fb1c7b3cc99c1937bc657d0e7fca97016e147f93c7821b5a4a6837db821e8"

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
  "https://ftp.gnu.org/gnu/ncurses/${PROGRAM_FULL}.tar.gz" \
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
mkdir -p $PROGRAM_INSTALL_PREFIX/lib/pkgconfig
../ncurses-6.5/configure --prefix=$PROGRAM_INSTALL_PREFIX \
  --enable-pc-files \
  --with-pkg-config-libdir=$PROGRAM_INSTALL_PREFIX/lib/pkgconfig \
  --enable-sigwinch \
  --enable-symlinks \
  --enable-widec \
  --with-shared \
  --with-cxx-shared \
  --with-gpm=no \
  --without-ada
make -j$(sysctl -n hw.ncpu)
make -j$(sysctl -n hw.ncpu) install
ln -s ncursesw6-config $PROGRAM_INSTALL_PREFIX/bin/ncurses6-config
ln -s ncursesw $PROGRAM_INSTALL_PREFIX/include/ncurses
ln -s libformw.6.dylib $PROGRAM_INSTALL_PREFIX/lib/libform.6.dylib
ln -s libformw.a $PROGRAM_INSTALL_PREFIX/lib/libform.a
ln -s libformw.dylib $PROGRAM_INSTALL_PREFIX/lib/libform.dylib
ln -s libformw_g.a $PROGRAM_INSTALL_PREFIX/lib/libform_g.a
ln -s libmenuw.6.dylib $PROGRAM_INSTALL_PREFIX/lib/libmenu.6.dylib
ln -s libmenuw.a $PROGRAM_INSTALL_PREFIX/lib/libmenu.a
ln -s libmenuw.dylib $PROGRAM_INSTALL_PREFIX/lib/libmenu.dylib
ln -s libmenuw_g.a $PROGRAM_INSTALL_PREFIX/lib/libmenu_g.a
ln -s libncurses++w.6.dylib $PROGRAM_INSTALL_PREFIX/lib/libncurses++.6.dylib
ln -s libncurses++w.a $PROGRAM_INSTALL_PREFIX/lib/libncurses++.a
ln -s libncurses++w.dylib $PROGRAM_INSTALL_PREFIX/lib/libncurses++.dylib
ln -s libncurses++w_g.a $PROGRAM_INSTALL_PREFIX/lib/libncurses++_g.a
ln -s libncursesw.6.dylib $PROGRAM_INSTALL_PREFIX/lib/libncurses.6.dylib
ln -s libncursesw.a $PROGRAM_INSTALL_PREFIX/lib/libncurses.a
ln -s libncursesw.dylib $PROGRAM_INSTALL_PREFIX/lib/libncurses.dylib
ln -s libncursesw_g.a $PROGRAM_INSTALL_PREFIX/lib/libncurses_g.a
ln -s libpanelw.6.dylib $PROGRAM_INSTALL_PREFIX/lib/libpanel.6.dylib
ln -s libpanelw.a $PROGRAM_INSTALL_PREFIX/lib/libpanel.a
ln -s libpanelw.dylib $PROGRAM_INSTALL_PREFIX/lib/libpanel.dylib
ln -s libpanelw_g.a $PROGRAM_INSTALL_PREFIX/lib/libpanel_g.a
ln -s formw.pc $PROGRAM_INSTALL_PREFIX/lib/pkgconfig/form.pc
ln -s menuw.pc $PROGRAM_INSTALL_PREFIX/lib/pkgconfig/menu.pc
ln -s ncurses++w.pc $PROGRAM_INSTALL_PREFIX/lib/pkgconfig/ncurses++.pc
ln -s ncursesw.pc $PROGRAM_INSTALL_PREFIX/lib/pkgconfig/ncurses.pc
ln -s panelw.pc $PROGRAM_INSTALL_PREFIX/lib/pkgconfig/panel.pc
cd $SOURCES_DIR
rm -rf $PROGRAM_FULL
rm -rf $PROGRAM_NAME-build
if [ -L $INSTALL_DIR/$PROGRAM_NAME ]; then
    rm $INSTALL_DIR/$PROGRAM_NAME
fi
ln -s ../build/$TEMP_PREFIX$PROGRAM_FULL $INSTALL_DIR/$PROGRAM_NAME
SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/apply_installation.sh $PROGRAM_NAME $INSTALL_DIR