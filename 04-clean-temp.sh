#!/bin/zsh
set -e

BASEDIR=$(dirname "$0")
SOFTWARES_DIR="${SOFTWARES_DIR:-$HOME/.softwares}"
BUILD_DIR="$SOFTWARES_DIR/build"

install_name_tool -change $BUILD_DIR/temp-llvm-18.1.8/lib/libomp.dylib $BUILD_DIR/llvm-18.1.8/lib/libomp.dylib $BUILD_DIR/libb2-0.98.1/lib/libb2.1.dylib
rm -rf $BUILD_DIR/temp-*