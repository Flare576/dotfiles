#!/bin/bash
# Setup other symlinks
echo "Setting up symlnks and creating placeholder files"
touch $HOME/dotfiles/.doNotCommit
touch $HOME/dotfiles/.gitconfig.personal

echo "Linking .doNotCommit"
ln -fs $HOME/dotfiles/.doNotCommit $HOME
echo "Linking .ctags.dir"
ln -fs $HOME/dotfiles/.ctags.dir $HOME/.ctags.d
echo "Linking .gitconfig.personal"
ln -fs $HOME/dotfiles/.gitconfig.personal $HOME
echo "Linking .zshenv"
ln -fs $HOME/dotfiles/.zshenv $HOME
echo "Linking .gitconfig"
ln -fs $HOME/dotfiles/.gitconfig $HOME
echo "Linking .gitignore"
ln -fs $HOME/dotfiles/.gitignore $HOME
echo "Linking .zshrc.kubeHelper"
ln -fs $HOME/dotfiles/.zshrc.kubeHelper $HOME
echo "Linking .tmux.conf"
ln -fs $HOME/dotfiles/.tmux.conf $HOME
