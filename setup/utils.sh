#!/bin/bash
# This file defines some common functions used throughout the setup scripts and defines the global version of the scripts
# shellcheck disable=SC2034
VERSION=3.2.0
# shellcheck disable=SC2034
isLinux=0; [ -f "/etc/os-release" ] && isLinux="true"

function cloneOrUpdateGit() {
  project="${1#*/}"
  folder="${2-$project}"
  if [ -d "$folder" ]; then
    echo "Updating $project"
    pushd "$folder" &> /dev/null || exit
    git pull
    popd &> /dev/null || exit
  else
    echo "Cloning $project"
    git clone -q "https://github.com/$1" "$folder"
  fi
}

# Extending to support ecosystems
function dotRemove() {
  if [[ "$1" == *:* ]]; then
    IFS=':' read -ra pieces <<< "$1"
    eco="${pieces[0]}"
    package="${pieces[1]}"
    echo "Uninstalling $package"
    if [ "$eco" == "python" ]; then
      uv tool uninstall "$package"
    elif [ "$eco" == "npm" ]; then
      npm uninstall -g "$package"
    fi
  else
    brewPackage="$1"
    [ -n "$2" ] && linuxPackage="$2" || linuxPackage="$brewPackage"

    if command -v brew &> /dev/null ; then
      echo "Uninstalling $brewPackage"
      brew uninstall "$brewPackage"
    elif command -v apt-get &> /dev/null ; then
      [ "$linuxPackage" == "manual" ] && return 1
      echo "Uninstalling $linuxPackage"
      apt-get remove -qqq "$linuxPackage"
    elif [ -n "$CONTAINER_ID" ]; then
      [ "$linuxPackage" == "manual" ] && return 1
      echo "Uninstalling $linuxPackage"
      sudo pacman -R --noconfirm "$linuxPackage"
    else
      echo "Unsure how to uninstall"
    fi
  fi
}

function dotInstall() {
  if [[ "$1" == *:* ]]; then
    IFS=':' read -ra pieces <<< "$1"
    eco="${pieces[0]}"
    package="${pieces[1]}"
    if [ "$eco" == "python" ]; then
      echo "Installing latest version of $package with uv"
      # shellcheck disable=SC1091
      command -v uv &> /dev/null || . "$HOME/.local/bin/env"
      if command -v "$package" &> /dev/null; then
        uv tool upgrade "$package"
      else
        uv tool install "$package"
      fi
    elif [ "$eco" == "npm" ]; then
      echo "Installing latest version of $package with npm"
      if ! command -v npm &> /dev/null; then
        NVM_DIR="${NVM_DIR:-"$HOME/.nvm"}"
        # shellcheck disable=SC1091
        . "$NVM_DIR/nvm.sh"
      fi
      npm install -g "$package"
    fi
  else
    brewPackage="$1"
    [ -n "$2" ] && linuxPackage="$2" || linuxPackage="$brewPackage"

    if command -v brew &> /dev/null ; then
      echo "Installing latest version of $brewPackage"
      brew install "$brewPackage"
    elif command -v apt-get &> /dev/null ; then
      [ "$linuxPackage" == "manual" ] && return 1
      echo "Installing latest version of $linuxPackage"
      apt-get update -qq;
      apt-get install -qqq --no-install-recommends "$linuxPackage"
    elif [ -n "$CONTAINER_ID" ]; then
      [ "$linuxPackage" == "manual" ] && return 1
      echo "Installing latest version of $linuxPackage"
      sudo pacman -Syu --noconfirm
      sudo pacman -S --noconfirm "$linuxPackage"
    else
      echo "Unsure how to install"
    fi
  fi
}

# requires `jq` to be available
function latestGit() {
  repository="$1" # should be user/project formatted
  filter="$2" # artifact to look for
  curl --silent "https://api.github.com/repos/$repository/releases/latest" | jq -r '.assets[].browser_download_url' | grep "$filter"
}
