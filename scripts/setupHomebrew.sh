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
  ctags-exuberant
  git
  git-secrets
  hub
  kubectx
  lastpass-cli
  mas
  nvm
  pipenv
  python
  shellcheck
  the_silver_searcher
  vim
  watch
  zsh
)

echo "Installing brews"
brew update
brew install ${brews[@]}

#K9s is an amazing Kubernetes manager
brew tap derailed/k9s && brew install k9s
