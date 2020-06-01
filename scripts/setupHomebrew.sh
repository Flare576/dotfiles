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
  python
  pipenv
  bat
  cheat
  git-secrets
  hub
  nvm
  shellcheck
  the_silver_searcher
  vim
  watch
)

if [ "$isLinux" -ne "1" ] ; then
  brews+=(cask git kubectx mas)
fi

echo "Installing brews"
brew update
brew install ${brews[@]}

echo "Grabbing Cheatsheets"
git clone https://github.com/cheat/cheatsheets.git $HOME/dotfiles/.cheat.community/


# K9s is an amazing Kubernetes manager
brew tap derailed/k9s && brew install k9s

# Looking forward to this being on normal tap
if [ "$isLinux" -eq "1" ] ; then
  sudo apt-get install python-setuptools
fi
brew install --HEAD universal-ctags/universal-ctags/universal-ctags
