#!/bin/bash
echo "Securing DotFiles repo"

cd $HOME/dotfiles
git secrets --install
git secrets --register-aws

read -p "Setup git/dotfiles? (Y/n)" doit
echo

if [[ $doit =~ ^[yY] ]] ; then
  clone -f
fi
