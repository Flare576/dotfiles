#!/bin/bash
source "$(dirname "$0")/utils.sh"

usage="$(basename "$0") [-hvdu]
Sets up simlinks for tools/processes not explicitly handled in the APPS/* scripts.

- ~/.doNotCommit.d
- ~/.gitconfig.personal
- ~/.gitconfig
- ~/.gitignore
- ~/.config/lazydocker
- ~/.config/ctags

  -h Show this help
  -v Display version
  -d Uninstall
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

# Setup other symlinks
links=(
  .doNotCommit.d
  .gitconfig.personal
  .gitconfig
  .gitignore
# Link individual settings items; there will be ".config" files with secrets :/
  .config/lazydocker
  .config/ctags
  # Don't link this file - it has secrets
  # .config/git-clone/config
)

if [ "$doDestroy" == "true" ]; then
  echo "Removing symlinks"
  for link in "${links[@]}";
  do
    rm -rf "$HOME/$link"
  done
  exit
fi

echo "Setting up symlnks and creating placeholder files"
mkdir -p "$HOME/.config" &> /dev/null
mkdir -p "$HOME/dotfiles/.doNotCommit.d" &> /dev/null

touch "$HOME/dotfiles/.gitconfig.personal"

for link in "${links[@]}";
do
  echo "Linking $link"
  ln -fs "$HOME/dotfiles/$link" "$HOME/$link"
done
