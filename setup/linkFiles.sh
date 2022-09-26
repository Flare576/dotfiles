#!/bin/bash
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

if [ "$1" = "delete" ]; then
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
