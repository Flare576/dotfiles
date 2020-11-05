#!/bin/bash
apps=(
  1password
  1password-cli
  boop
  firefox
  google-chrome
  docker
  launchbar
  postman
  slack
  spotify
  vlc
)

echo "Installing Homebrew Casks"
brew cask install --appdir="/Applications" ${apps[@]}
