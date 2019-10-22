#!/bin/bash
isLinux=0; [ -f "/etc/os-version" ] && isLinux=1
# Install Homebrew
if test ! $(which brew); then
  echo "Installing Homebrew"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi


# Install Good Stuff
brews=(
  bat
  git
  git-secrets
  hub
  nvm
  pipenv
  python
  shellcheck
  the_silver_searcher
  vim
  watch
  zsh
)

if [ "$isLinux" -eq "0" ] ; then
  echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.doNotCommit
else
  brews+=(cask kubectx mas)
fi

echo "Installing brews"
brew update
brew install ${brews[@]}

# K9s is an amazing Kubernetes manager
# brew tap derailed/k9s && brew install k9s

# Looking forward to this being on normal tap
# choked in Mint
# brew install --HEAD universal-ctags/universal-ctags/universal-ctags
