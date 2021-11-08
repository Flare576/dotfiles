#!/bin/bash
# Setup other symlinks
links=(
  .doNotCommit.d
  .gitconfig.personal
  .zshenv
  .gitconfig
  .gitignore
  .zshrc.kubeHelper
  .zshrc.awsHelper
  .zshrc.rpg
  .tmux.conf
  cheat
# Link individual settings items; there will be ".config" files with secrets :/
  .config/lazydocker
  .config/git-clone
  .config/theme
)

if [ "$1" = "delete" ]; then
  echo "Removing symlinks"
  for link in "${links[@]}";
  do
    rm -rf "$HOME/$link"
  done
  rm -rf "$HOME/.ctags.d"
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

echo "Linking .ctags.dir"
ln -fs "$HOME/dotfiles/.ctags.dir" "$HOME"/.ctags.d
