#!/bin/bash
isLinux=0; [ -f "/etc/os-version" ] && isLinux=1
echo "Setup Oh My Zshell"

# Install and setup Oh My Zshell
pip3 install --user powerline-status
curl -sL http://install.ohmyz.sh | sh
cd $HOME/.oh-my-zsh/themes
curl -LSso cobalt2.zsh-theme https://raw.githubusercontent.com/wesbos/Cobalt2-iterm/master/cobalt2.zsh-theme
cd $HOME/.oh-my-zsh/custom/plugins/
git clone https://github.com/lukechilds/zsh-better-npm-completion

cd /tmp
git clone https://github.com/powerline/fonts
cd fonts
./install.sh

# Sometimes Z doesn't setup its file
touch $HOME/.z

ln -fs $HOME/dotfiles/.zshrc $HOME

echo "Making Zsh default"
if [ "$isLinux" -eq "1" ] ; then
  chsh -s $(which zsh)
else
  sudo dscl . -create /Users/$USER UserShell /usr/local/bin/zsh
fi
