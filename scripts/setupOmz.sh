#!/bin/sh
# Install and setup Oh My Zshell
pip install --user powerline-status
curl -sL http://install.ohmyz.sh | sh
cd $HOME/.oh-my-zsh/themes
curl -LSso cobalt2.zsh-theme https://raw.githubusercontent.com/wesbos/Cobalt2-iterm/master/cobalt2.zsh-theme
cd /tmp
git clone https://github.com/powerline/fonts
cd fonts
./install.sh

# Sometimes Z doesn't setup its file
touch $HOME/.z

ln -Fs $HOME/dotfiles/.zshrc $HOME

