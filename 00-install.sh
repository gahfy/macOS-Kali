#!/bin/zsh
set -e

BASE_DIR=$(realpath $(dirname "$0"))
SOFTWARES_DIR="${SOFTWARES_DIR:-$HOME/.softwares}"

SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/01-setup.sh
SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/02-install-temp.sh
SOFTWARES_DIR=$SOFTWARES_DIR $BASE_DIR/03-install-base.sh