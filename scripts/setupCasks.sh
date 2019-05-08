#!/bin/sh
apps=(
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

brew cask install --appdir="/Applications" ${apps[@]}
