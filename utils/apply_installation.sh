#!/bin/zsh
set -e

PROGRAM_NAME=$1
INSTALL_DIR=$2

touch $HOME/.zshrc

line=""
if [ -d "$INSTALL_DIR/$PROGRAM_NAME/bin" ]; then
  current_line=$(echo 'export PATH="'"$INSTALL_DIR/$PROGRAM_NAME"'/bin:$PATH"')
  if ! grep -Fxq "$current_line" $HOME/.zshrc; then
    line="$line"$'\n'"$current_line"
  fi
fi
if [ -d "$INSTALL_DIR/$PROGRAM_NAME/lib" ]; then
  if [ -d "$INSTALL_DIR/$PROGRAM_NAME/lib/pkgconfig" ]; then
    current_line=$(echo 'export PKG_CONFIG_PATH="'"$INSTALL_DIR/$PROGRAM_NAME"'/lib/pkgconfig:$PKG_CONFIG_PATH"')
    if ! grep -Fxq "$current_line" $HOME/.zshrc; then
      line="$line"$'\n'"$current_line"
    fi
  fi

  PYTHON_DIR=$(find $INSTALL_DIR/$PROGRAM_NAME/lib -maxdepth 1 -name 'python*')

  if [ -n "$PYTHON_DIR" ]; then
    if [ -d "$PYTHON_DIR/site-packages" ]; then
      current_line=$(echo 'export PYTHONPATH="'"$PYTHON_DIR"'/site-packages:$PYTHONPATH"')
      if ! grep -Fxq "$current_line" $HOME/.zshrc; then
        line="$line"$'\n'"$current_line"
      fi
    fi
  fi
fi

if [ -d "$INSTALL_DIR/$PROGRAM_NAME/man" ]; then
  current_line=$(echo 'export MANPATH="'"$INSTALL_DIR/$PROGRAM_NAME"'/man:$MANPATH"')
  if ! grep -Fxq "$current_line" $HOME/.zshrc; then
    line="$line"$'\n'"$current_line"
  fi
fi

if [ -d "$INSTALL_DIR/$PROGRAM_NAME/share" ]; then
  if [ -d "$INSTALL_DIR/$PROGRAM_NAME/share/aclocal" ]; then
    current_line=$(echo 'export ACLOCAL_PATH="'"$INSTALL_DIR/$PROGRAM_NAME"'/share/aclocal:$ACLOCAL_PATH"')
    if ! grep -Fxq "$current_line" $HOME/.zshrc; then
      line="$line"$'\n'"$current_line"
    fi
  fi
  if [ -d "$INSTALL_DIR/$PROGRAM_NAME/share/info" ]; then
    current_line=$(echo 'export INFOPATH="'"$INSTALL_DIR/$PROGRAM_NAME"'/share/info:$INFOPATH"')
    if ! grep -Fxq "$current_line" $HOME/.zshrc; then
      line="$line"$'\n'"$current_line"
    fi
  fi
  if [ -d "$INSTALL_DIR/$PROGRAM_NAME/share/man" ]; then
    current_line=$(echo 'export MANPATH="'"$INSTALL_DIR/$PROGRAM_NAME"'/share/man:$MANPATH"')
    if ! grep -Fxq "$current_line" $HOME/.zshrc; then
      line="$line"$'\n'"$current_line"
    fi
  fi

  ## vimrc
  if [ -d "$INSTALL_DIR/$PROGRAM_NAME/share/vim" ]; then
    if [ -d "$INSTALL_DIR/$PROGRAM_NAME/share/vim/vimfiles" ]; then
      touch $HOME/.vimrc
      vimline=""
      current_line=$(echo "set runtimepath^=$INSTALL_DIR/$PROGRAM_NAME/share/vim/vimfiles")
      if ! grep -Fxq "$current_line" $HOME/.vimrc; then
        vimline="$vimline"$'\n'"$current_line"
      fi
      if [ -n "$vimline" ]; then
        echo '' >> $HOME/.zshrc
      echo '" '"$PROGRAM_NAME" >> $HOME/.vimrc
      fi
      echo ''  >> $HOME/.vimrc
      echo '" '"$PROGRAM_NAME$vimline" >> $HOME/.vimrc
    fi
  fi
fi

if [ -n "$line" ]; then
  echo '' >> $HOME/.zshrc
  echo "## $PROGRAM_NAME$line" >> $HOME/.zshrc
fi