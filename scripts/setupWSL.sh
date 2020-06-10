#!/bin/bash
if [ ! -d "/mnt/c" ] ; then
  echo "This script is designed to help install mintty on WSL.
  It doesn't look like you have a C:\\ drive mounted, which means I'm useless :(.
  Feel free to checkout https://github.com/mintty/wsltty "
  exit
fi

if [ ! -f "/etc/os-release" ] ; then
  read -p "It doesn't look like you're running Linux... Continue? (Y/n) " rusure
  if [[ ! "$ursure" =~ ^[yY] ]] ; then
    exit
  fi
fi

target=/mnt/c/flarescript_temp

echo "First, warning: This concept is under-developed.

After these scripts finish, see dotfiles/scripts/finalizeWSL.md."

mkdir -p "$target"
curl -s -o "$target/Inconsolata.otf" "https://raw.githubusercontent.com/powerline/fonts/master/Inconsolata/Inconsolata%20for%20Powerline.otf"
curl -s -o "$target/Inconsolata_bold.ttf" "https://raw.githubusercontent.com/powerline/fonts/master/Inconsolata/Inconsolata%20Bold%20for%20Powerline.ttf"
latestAsset=$(curl https://api.github.com/repos/mintty/wsltty/releases/latest | jq '.assets[] | select(.name | test("64.exe"))')
latestName=$(echo "$latestAsset" | jq  -r '.name')
latestUrl=$(echo "$latestAsset" | jq -r '.browser_download_url')
curl -sL -o "$target/$latestName" "$latestUrl"
echo "got $latestName and $latestUrl"
