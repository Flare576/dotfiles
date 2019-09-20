#!/bin/sh
# Setup other symlinks
echo "Setting up symlnks and creating placeholder files"
touch $HOME/dotfiles/.doNotCommit
touch $HOME/dotfiles/.gitconfig.personal

ln -Fs $HOME/dotfiles/.doNotCommit $HOME
ln -Fs $HOME/dotfiles/.gitconfig.personal $HOME
ln -Fs $HOME/dotfiles/.zshenv $HOME
ln -Fs $HOME/dotfiles/.gitconfig $HOME
ln -Fs $HOME/dotfiles/.gitignore $HOME
ln -Fs $HOME/dotfiles/.zshrc.kubeHelper $HOME
ln -Fs $HOME/dotfiles/.cheat $HOME
ln -Fs $HOME/dotfiles/scripts/idea /usr/local/bin/
# Pull "Every Day" scripts - already on path from .zshenv
git clone git@github.com:Flare576/scripts.git $HOME/scripts