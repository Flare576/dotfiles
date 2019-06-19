#!/bin/sh
# Install Homebrew
if test ! $(which brew); then
  echo "Installing Homebrew"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Install Good Stuff
brews=(
  bat
  cask
  pyenv
  git
  hub
  nvm
  the_silver_searcher
  zsh
  shellcheck
  git-secrets
  lastpass-cli
  mas
  watch
  kubectx
  vim
)

echo "Installing brews"
brew update
brew install ${brews[@]}

#K9s is an amazing Kubernetes manager
brew tap derailed/k9s && brew install k9s
