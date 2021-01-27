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

next_steps=/mnt/c/flarescript_temp
mkdir -p "$next_steps"

# JetBrains Font
workspace=/tmp/fonts
mkdir -p "$workspace"

zip_path="$workspace/jetbrainsMono.zip"
echo "Downloading JetBrains Mono font"
curl -sL -o "$zip_path" "https://github.com/JetBrains/JetBrainsMono/releases/download/v2.221/JetBrainsMono-2.221.zip"
unzip -qq -o -d "$workspace" "$zip_path"
cp "$workspace/fonts/ttf/JetBrainsMono-Regular.ttf" "$next_steps"

# MinTTY (WSLTTY)
echo "Downloading WSLtty"
wslttyUrl="https://api.github.com/repos/mintty/wsltty/releases/latest"
latestAsset=$(curl -sL "$wslttyUrl" | jq '.assets[] | select(.name | test("64.exe"))')
latestName=$(echo "$latestAsset" | jq  -r '.name')
latestUrl=$(echo "$latestAsset" | jq -r '.browser_download_url')
curl -sL -o "$next_steps/$latestName" "$latestUrl"

echo "Downloading/configuring mintty tools (so fresh) and themes (so clean)"
mintty_home="$(wslpath $APPDATA)/mintty"
script_config="$HOME/dotfiles/.doNotCommit"
themes_dir="$HOME/dotfiles/themes"

mkdir -p "$mintty_home/themes"
pushd "$mintty_home" > /dev/null
git clone "https://github.com/mintty/utils.git" &> /dev/null
cp "$themes_dir"/**/*.minttyrc "$mintty_home/themes"
echo "Font=JetBrains Mono
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
Columns=150" > "$mintty_home/config"

if ! grep -q 'mintty' $script_config ; then
  echo "PATH=$mintty_home/utils:\$PATH" >> "$script_config"
fi
