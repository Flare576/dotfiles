#!/bin/bash

if [[ "$1" == "delete" ]]; then
  echo "Removing ~/.tmux/ and ~/.tmux.conf"
  rm -rf "$HOME/.tmux" "$HOME/.tmux.conf"
  if command -v brew &> /dev/null ; then
    echo "Uninstalling tmux"
    brew uninstall tmux &> /dev/null
else
  echo "Homebrew not found"
  fi
  exit
fi

echo "Installing latest version of tmux"
if command -v brew &> /dev/null ; then
  HOMEBREW_NO_INSTALL_UPGRADE=0 brew install tmux
else
  echo "Homebrew not found"
fi

echo "Linking .tmux.conf, setting up plugins"
ln -fs $HOME/dotfiles/.tmux.conf $HOME

# TMUX Plugin Manager manages plugins: https://github.com/tmux-plugins/tpm

TMUX_PLUGINS="$HOME/.tmux/plugins"
TMP_DIR="$TMUX_PLUGINS/tpm"
mkdir -p "$TMUX_PLUGINS"
if [ -d "$TMP_DIR" ]; then
  pushd "$TMP_DIR" &> /dev/null
  git pull &> /dev/null
  popd &> /dev/null
else
  git clone https://github.com/tmux-plugins/tpm "$TMP_DIR" &> /dev/null
fi

# Install plugins defined in .tmux.conf
$HOME/.tmux/plugins/tpm/bin/install_plugins &> /dev/null
