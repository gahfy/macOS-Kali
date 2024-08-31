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

  if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh util-linux; then
    if ! TEMP=$IS_TEMP $BASE_DIR/util-linux-2.40.2.sh 2> /dev/null; then
      echo "$TEMP_PREFIX$PROGRAM_NAME $PROGRAM_VERSION needs util-linux which failed to install"
      exit 1
    fi
  fi

  if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh libffi; then
    if ! TEMP=$IS_TEMP $BASE_DIR/libffi-3.4.6.sh 2> /dev/null; then
      echo "$TEMP_PREFIX$PROGRAM_NAME $PROGRAM_VERSION needs libffi which failed to install"
      exit 1
    fi
  fi

  if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh libnsl; then
    if ! TEMP=$IS_TEMP $BASE_DIR/libnsl-2.0.1.sh 2> /dev/null; then
      echo "$TEMP_PREFIX$PROGRAM_NAME $PROGRAM_VERSION needs libnsl which failed to install"
      exit 1
    fi
  fi

  if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh sqlite; then
    if ! TEMP=$IS_TEMP $BASE_DIR/sqlite-3.46.1.sh 2> /dev/null; then
      echo "$TEMP_PREFIX$PROGRAM_NAME $PROGRAM_VERSION needs sqlite which failed to install"
      exit 1
    fi
  fi

  if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh tcl-tk; then
    if ! TEMP=$IS_TEMP $BASE_DIR/tcl-tk-8.6.14.sh 2> /dev/null; then
      echo "$TEMP_PREFIX$PROGRAM_NAME $PROGRAM_VERSION needs tcl-tk which failed to install"
      exit 1
    fi
  fi

  if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh gdbm; then
    if ! TEMP=$IS_TEMP $BASE_DIR/gdbm-1.24.sh 2> /dev/null; then
      echo "$TEMP_PREFIX$PROGRAM_NAME $PROGRAM_VERSION needs gdbm which failed to install"
      exit 1
    fi
  fi

  if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh zlib; then
    if ! TEMP=$IS_TEMP $BASE_DIR/zlib-1.3.1.sh 2> /dev/null; then
      echo "$TEMP_PREFIX$PROGRAM_NAME $PROGRAM_VERSION needs zlib which failed to install"
      exit 1
    fi
  fi

  if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh bzip2; then
    if ! TEMP=$IS_TEMP $BASE_DIR/bzip2-1.0.8.sh 2> /dev/null; then
      echo "$TEMP_PREFIX$PROGRAM_NAME $PROGRAM_VERSION needs bzip2 which failed to install"
      exit 1
    fi
  fi

  if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh libxcrypt; then
    if ! TEMP=$IS_TEMP $BASE_DIR/libxcrypt-4.4.36.sh 2> /dev/null; then
      echo "$TEMP_PREFIX$PROGRAM_NAME $PROGRAM_VERSION needs libxcrypt which failed to install"
      exit 1
    fi
  fi

  if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh readline; then
    if ! TEMP=$IS_TEMP $BASE_DIR/readline-8.2.13.sh 2> /dev/null; then
      echo "$TEMP_PREFIX$PROGRAM_NAME $PROGRAM_VERSION needs readline which failed to install"
      exit 1
    fi
  fi

  if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh libedit; then
    if ! TEMP=$IS_TEMP $BASE_DIR/libedit-3.1.2024.08.08.sh 2> /dev/null; then
      echo "$TEMP_PREFIX$PROGRAM_NAME $PROGRAM_VERSION needs libedit which failed to install"
      exit 1
    fi
  fi

  if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh ncurses; then
    if ! TEMP=$IS_TEMP $BASE_DIR/ncurses-6.5.sh 2> /dev/null; then
      echo "$TEMP_PREFIX$PROGRAM_NAME $PROGRAM_VERSION needs ncurses which failed to install"
      exit 1
    fi
  fi

  if ! SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/utils/detect-installation.sh libb2; then
    if ! TEMP=$IS_TEMP $BASE_DIR/libb2-0.98.1.sh 2> /dev/null; then
      echo "$TEMP_PREFIX$PROGRAM_NAME $PROGRAM_VERSION needs libb2 which failed to install"
      exit 1
    fi
  fi
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
if ((IS_TEMP == 0)); then
  CFLAGS="-Wno-error=incompatible-function-pointer-types -I${BUILD_DIR}/libxcrypt-4.4.36/include" \
    LIBUUID_CFLAGS="-I${BUILD_DIR}/util-linux-2.40.2/include/uuid" \
    LIBUUID_LIBS="-L${BUILD_DIR}/util-linux-2.40.2/lib -luuid" \
    LIBFFI_CFLAGS="-I${BUILD_DIR}/libffi-3.4.6/include" \
    LIBFFI_LIBS="-L${BUILD_DIR}/libffi-3.4.6/lib -lffi" \
    LIBNSL_CFLAGS="-I${BUILD_DIR}/libnsl-2.0.1/include -I${BUILD_DIR}/libtirpc-1.3.5/include/tirpc" \
    LIBNSL_LIBS="-L${BUILD_DIR}/libnsl-2.0.1/lib -L${BUILD_DIR}/libtirpc-1.3.5/lib -lnsl -ltirpc" \
    LIBSQLITE3_CFLAGS="-I${BUILD_DIR}/sqlite-3.46.1/include" \
    LIBSQLITE3_LIBS="-L${BUILD_DIR}/sqlite-3.46.1/lib -lsqlite3" \
    TCLTK_CFLAGS="-I${BUILD_DIR}/tcl-tk-8.6.14/include -I${BUILD_DIR}/zlib-1.3.1/include" \
    TCLTK_LIBS="-L${BUILD_DIR}/tcl-tk-8.6.14/lib -ltk8.6 -ltkstub8.6 -ltcl8.6 -ltclstub8.6" \
    GDBM_CFLAGS="-I${BUILD_DIR}/gdbm-1.24/include" \
    GDBM_LIBS="-L${BUILD_DIR}/gdbm-1.24/lib -lgdbm" \
    ZLIB_CFLAGS="-I${BUILD_DIR}/zlib-1.3.1/include" \
    ZLIB_LIBS="-L${BUILD_DIR}/zlib-1.3.1/lib -lz" \
    BZIP2_CFLAGS="-I${BUILD_DIR}/bzip2-1.0.8/include" \
    BZIP2_LIBS="-L${BUILD_DIR}/bzip2-1.0.8/lib -lbz2" \
    LIBCRYPT_CFLAGS="-I${BUILD_DIR}/libxcrypt-4.4.36/include" \
    LIBCRYPT_LIBS="-L${BUILD_DIR}/libxcrypt-4.4.36/lib -lcrypt" \
    LIBREADLINE_CFLAGS="-D_DARWIN_C_SOURCE -DNCURSES_WIDECHAR -I${BUILD_DIR}/readline-8.2.13/include -I${BUILD_DIR}/ncurses-6.5/include/ncursesw -I${BUILD_DIR}/ncurses-6.5/include" \
    LIBREADLINE_LIBS="-L${BUILD_DIR}/readline-8.2.13/lib -lreadline" \
    LIBEDIT_CFLAGS="-I${BUILD_DIR}/temp-libedit-3.1.2024.08.08/include -I${BUILD_DIR}/temp-libedit-3.1.2024.08.08/include/editline" \
    LIBEDIT_LIBS="-L${BUILD_DIR}/temp-libedit-3.1.2024.08.08/lib -ledit" \
    CURSES_CFLAGS="-D_DARWIN_C_SOURCE -DNCURSES_WIDECHAR -I${BUILD_DIR}/ncurses-6.5/include/ncursesw -I${BUILD_DIR}/ncurses-6.5/include" \
    CURSES_LIBS="-L${BUILD_DIR}/ncurses-6.5/lib -Wl,-search_paths_first -lncursesw" \
    PANEL_CFLAGS="-D_DARWIN_C_SOURCE -DNCURSES_WIDECHAR -I${BUILD_DIR}/ncurses-6.5/include/ncursesw -I${BUILD_DIR}/ncurses-6.5/include" \
    PANEL_LIBS="-L${BUILD_DIR}/ncurses-6.5/lib -Wl,-search_paths_first -lpanelw" \
    LIBB2_CFLAGS="-I${BUILD_DIR}/libb2-0.98.1/include" \
    LIBB2_LIBS="-L${BUILD_DIR}/libb2-0.98.1/lib -lb2" \
    LIBLZMA_CFLAGS="-I${BUILD_DIR}/${TEMP_PREFIX}xz-5.6.2/include" \
    LIBLZMA_LIBS="-L${BUILD_DIR}/${TEMP_PREFIX}xz-5.6.2/lib -llzma" \
    ../$PROGRAM_FULL/configure --prefix=$PROGRAM_INSTALL_PREFIX \
    --with-openssl=${BUILD_DIR}/${TEMP_PREFIX}openssl-3.3.1 --enable-optimizations \
    --enable-framework=$PROGRAM_INSTALL_PREFIX
else
  CFLAGS="-Wno-error=incompatible-function-pointer-types" \
    LIBLZMA_CFLAGS="-I${BUILD_DIR}/${TEMP_PREFIX}xz-5.6.2/include" \
    LIBLZMA_LIBS="-L${BUILD_DIR}/${TEMP_PREFIX}xz-5.6.2/lib -llzma" \
    ../$PROGRAM_FULL/configure --prefix=$PROGRAM_INSTALL_PREFIX \
    --with-openssl=${BUILD_DIR}/${TEMP_PREFIX}openssl-3.3.1 --enable-optimizations \
    --enable-framework=$PROGRAM_INSTALL_PREFIX
fi
make -j$(sysctl -n hw.ncpu)
make install
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