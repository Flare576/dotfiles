#!/bin/bash
isLinux=0; [ -f "/etc/os-release" ] && isLinux=1
# Install Homebrew
if test ! $(which brew); then
  echo "Installing Homebrew"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Install Good Stuff
brews=(
  zsh
  python # must preceed vim
  pipenv
  bat
  cheat
  git-secrets
  hub
  nvm
  shellcheck
  tmux
  the_silver_searcher
  vim
  watch
  jq
  k9s # Any project using K8s
  lazydocker # Any project using straight Docker
)

if [ "$isLinux" -ne "1" ] ; then
  brews+=(cask git kubectx mas)
fi

echo "Installing brews"
brew update
brew install ${brews[@]}

echo "Grabbing Cheatsheets"
git clone https://github.com/cheat/cheatsheets.git $HOME/dotfiles/.cheat.community/

brew install --HEAD universal-ctags/universal-ctags/universal-ctags

  # Jetbrains Mono is a great font for terminals; install it so it's available on this system
if [ "$isLinux" -eq "1" ] ; then
  # I don't remember what these are for, commenting out to see what breaks
  # sudo apt-get install python-setuptools
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"
else
  brew cask install homebrew/cask-fonts/font-jetbrains-mono
fi
