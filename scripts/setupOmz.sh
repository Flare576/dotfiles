#!/bin/bash
isLinux=0; [ -f "/etc/os-release" ] && isLinux=1
echo "Setup Oh My Zshell"

# Install and setup Oh My Zshell
if [ -d "/mnt/c" ] ; then
  read -p "Are you running in Windows Submodule for Linux (WSL)? (Y/n)" inwsl
  if [[ "$inwsl" =~ ^[yY] ]] ; then
    echo "You'll need to install Powerline fonts for Windows. Open Powershell **AS ADMINISTRATOR**, and copy-pasta:
    https://raw.githubusercontent.com/powerline/fonts/master/Inconsolata/Inconsolata%20for%20Powerline.otf

    powershell -command \"& { iwr https://github.com/powerline/fonts/archive/master.zip -OutFile ~\fonts.zip }\"
    Expand-Archive -Path ~\\fonts.zip -DestinationPath ~
    Set-ExecutionPolicy Bypass
    ~\\fonts-master\install.ps1
    Set-ExecutionPolicy Default
    rm -r ~\\fonts-master
    rm ~\\fonts.zip

    Then, click the Ubuntu logo in the top-left, choose Properties, and set the Font to 'DejaVu Sans Mono for Powerline'."
  fi
fi
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
  which zsh | sudo tee -a /etc/shells
  chsh -s $(which zsh)
else
  sudo dscl . -create /Users/$USER UserShell /usr/local/bin/zsh
fi
