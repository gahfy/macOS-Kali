#!/bin/zsh
set -e

SOFTWARES_DIR="${SOFTWARES_DIR:-$HOME/.softwares}"

touch $HOME/.zshrc && \
mkdir -p $SOFTWARES_DIR/sources && \
mkdir -p $SOFTWARES_DIR/build && \
mkdir -p $SOFTWARES_DIR/install