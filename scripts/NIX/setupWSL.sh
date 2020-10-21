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

fontUrl="https://github.com/JetBrains/JetBrainsMono/releases/download/v2.001/JetBrains.Mono.2.001.zip"
fontTmpDir=/tmp/fonts
fontTmpName=jetbrainsMono.zip
fontTmp="$fontTmpDir/$fontTmpName"
target=/mnt/c/flarescript_temp

echo "First, warning: This concept is under-developed.

After these scripts finish, see dotfiles/scripts/finalizeWSL.md."

mkdir -p "$target"
curl -L -o "$fontTmp" "$fontZip"
unzip -d "$fontTmpDir" "$fontTmp"
cp "$fontTmpDir/JetBrains Mono 2.001/ttf/JetBrainsMono-Regular.ttf" "$target"

wslttyUrl="https://api.github.com/repos/mintty/wsltty/releases/latest"
latestAsset=$(curl "$wslttyUrl" | jq '.assets[] | select(.name | test("64.exe"))')
latestName=$(echo "$latestAsset" | jq  -r '.name')
latestUrl=$(echo "$latestAsset" | jq -r '.browser_download_url')
curl -sL -o "$target/$latestName" "$latestUrl"
echo "got $latestName and $latestUrl"
