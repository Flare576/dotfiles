#!/bin/bash
# Install Homebrew
if test ! $(which brew); then
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
  kubens
)

brew update
brew install ${brews[@]}
brew install --with-override-system-vim vim
