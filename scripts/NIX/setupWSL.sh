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

echo -e "\e[37;41mAfter these scripts finish, see dotfiles/scripts/finalizeWSL.md to complete installation.\e[39;49m"

fontUrl="https://github.com/JetBrains/JetBrainsMono/releases/download/v2.221/JetBrainsMono-2.221.zip"
fontTmpDir=/tmp/fonts
fontTmpName=jetbrainsMono.zip
fontTmp="$fontTmpDir/$fontTmpName"
target=/mnt/c/flarescript_temp

mkdir -p "$target"

# JetBrains Font
echo "Downloading JetBrains Mono font"
mkdir -p "$fontTmpDir"
curl -sL -o "$fontTmp" "$fontUrl"
unzip -qq -o -d "$fontTmpDir" "$fontTmp"
cp "$fontTmpDir/fonts/ttf/JetBrainsMono-Regular.ttf" "$target"

# MinTTY (WSLTTY)
echo "Downloading WSLtty"
wslttyUrl="https://api.github.com/repos/mintty/wsltty/releases/latest"
latestAsset=$(curl -sL "$wslttyUrl" | jq '.assets[] | select(.name | test("64.exe"))')
latestName=$(echo "$latestAsset" | jq  -r '.name')
latestUrl=$(echo "$latestAsset" | jq -r '.browser_download_url')
curl -sL -o "$target/$latestName" "$latestUrl"

theme_target="$APPDATA\\wsltty\\themes"
theme_target=${theme_target/C:\\/\/mnt/c/}
theme_target=${theme_target//\\/\/}
mkdir -p "$theme_target"
pushd "$theme_target" > /dev/null
cp "$HOME/dotfiles/themes/"*.minttyrc .
ln -s solarized_dark.minttyrc flare.mintty &> /dev/null
pushd .. > /dev/null
echo "# To use common configuration in %APPDATA%\mintty, simply remove this file
Font=JetBrains Mono
FontHeight=14
FontWeight=400
CtrlShiftShortcuts=yes
ClipShortcuts=yes
ComposeKey=alt
CursorType=block
Transparency=off
AltFnShortcuts=yes
ZoomShortcuts=no
ScrollMod=off
Term=xterm-256color
ThemeFile=flare.minttyrc
Columns=150" > config
popd > /dev/null
popd > /dev/null
