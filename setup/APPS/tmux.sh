#!/bin/bash
source "$(dirname "$0")/../utils.sh"
usage="$(basename "$0") [-hvd]
Links dotfile configs and installs/updates Tmux and associated plugins.
Tmux, or Terminal Multiplexer, lets you setup windows and panes in a terminal session, similar to iTerm but for any terminal emulator.
  -h Show this help
  -v Display version
  -d Uninstall tmux/plugins
"
while getopts ':hvd' option; do
  case "$option" in
    h) echo "$usage"
      exit
      ;;
    v) echo "$VERSION"
      exit
      ;;
    d) doDestroy="true"
      ;;
    *) echo "Unknown Option '$option', exiting"
      exit
      ;;
  esac
done
shift $((OPTIND -1))

if [ "$doDestroy" == "true" ]; then
  echo "Removing ~/.tmux/ and ~/.tmux.conf"
  rm -rf "$HOME/.tmux" "$HOME/.tmux.conf"
  dotRemove tmux
  exit
fi

dotInstall tmux

echo "Linking .tmux.conf, setting up plugins"
ln -fs "$HOME/dotfiles/.tmux.conf" "$HOME"

# TMUX Plugin Manager manages plugins: https://github.com/tmux-plugins/tpm

TMUX_PLUGINS="$HOME/.tmux/plugins"
mkdir -p "$TMUX_PLUGINS"
pushd "$TMUX_PLUGINS" &> /dev/null || exit
cloneOrUpdateGit tmux-plugins/tpm
popd &> /dev/null || exit

# Install plugins defined in .tmux.conf
"$HOME/.tmux/plugins/tpm/bin/install_plugins" &> /dev/null
