#!/bin/bash
# Setup other symlinks
echo "Setting up symlnks and creating placeholder files"
touch $HOME/dotfiles/.doNotCommit
touch $HOME/dotfiles/.gitconfig.personal

ln -fs $HOME/dotfiles/.doNotCommit $HOME
ln -fs $HOME/dotfiles/.ctags.dir $HOME/.ctags.d
ln -fs $HOME/dotfiles/.gitconfig.personal $HOME
ln -fs $HOME/dotfiles/.zshenv $HOME
ln -fs $HOME/dotfiles/.gitconfig $HOME
ln -fs $HOME/dotfiles/.gitignore $HOME
ln -fs $HOME/dotfiles/.zshrc.kubeHelper $HOME
ln -fs $HOME/dotfiles/.cheat $HOME
