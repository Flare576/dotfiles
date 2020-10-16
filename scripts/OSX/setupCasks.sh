#!/bin/bash
apps=(
  1password
  1password-cli
  homebrew/cask-versions/docker-edge
  dropbox
  postman
  firefox
  iterm2
  launchbar
  slack
  steam
  spotify
  vlc
  google-chrome
)

echo "Installing Homebrew Casks"
brew cask install --appdir="/Applications" ${apps[@]}
