#!/bin/bash

if [[ "$1" == "delete" ]]; then
  # TODO: manage removing pipenv files once I start using it
  rootdir="$(pyenv root)"
  echo "Removing $rootdir"
  rm -rf "$rootdir"
  if ! command -v brew &> /dev/null ; then
    echo "Uninstalling pyenv and pipenv"
    brew uninstall pyenv pipenv &> /dev/null
  fi
  exit
fi

echo "Installing latest version of pyenv and pipenv"
if ! command -v brew &> /dev/null ; then
  HOMEBREW_NO_INSTALL_UPGRADE=0 brew install pipenv pyenv
fi

echo "Install latest stable version of Python3"
stable=$(pyenv install --list | grep -v '-' | grep -v 'b' | grep '^3' | tail -1)
pyenv install $stable
pyenv global $stable
