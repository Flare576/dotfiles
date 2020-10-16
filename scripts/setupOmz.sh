#!/bin/bash
isLinux=0; [ -f "/etc/os-release" ] && isLinux=1
echo "Setup Oh My Zshell"

# Install and setup Oh My Zshell
curl -sL http://install.ohmyz.sh | sh
cd $HOME/.oh-my-zsh/themes
curl -LSso cobalt2.zsh-theme https://raw.githubusercontent.com/wesbos/Cobalt2-iterm/master/cobalt2.zsh-theme
cd $HOME/.oh-my-zsh/custom/plugins/

# Jetbrains Mono is slick, simple, and works
if [ "$isLinux" -eq "1" ] ; then
  mkdir -p /tmp/fonts
  curl -L -o /tmp/fonts/jetbrainsMono.zip "https://github.com/JetBrains/JetBrainsMono/releases/download/v2.001/JetBrains.Mono.2.001.zip"
  unzip -d /tmp/fonts /tmp/fonts/jetbrainsMono.zip
  sudo mv /tmp/fonts/JetBrains\ Mono\ 2.001/ttf/JetBrainsMono-Medium.ttf /usr/share/fonts
else
  brew tap homebrew/cask-fonts
  brew cask install font-jetbrains-mono
fi

# NVM and Node Optimizations
git clone https://github.com/lukechilds/zsh-better-npm-completion
git clone https://github.com/lukechilds/zsh-nvm

cd /tmp
git clone https://github.com/powerline/fonts
cd fonts
./install.sh

# Sometimes Z doesn't setup its file
touch $HOME/.z

ln -fs $HOME/dotfiles/.zshrc $HOME

echo "Making Zsh default"
if [ "$isLinux" -eq "1" ] ; then
  which zsh | sudo tee -a /etc/shells
  chsh -s $(which zsh)
else
  sudo dscl . -create /Users/$USER UserShell /usr/local/bin/zsh
fi
