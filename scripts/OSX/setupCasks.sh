#!/bin/bash
apps=(
  1password
  1password-cli
  homebrew/docker
  postman
  firefox
  launchbar
  slack
  spotify
  vlc
  google-chrome
)

echo "Installing Homebrew Casks"
brew cask install --appdir="/Applications" ${apps[@]}
