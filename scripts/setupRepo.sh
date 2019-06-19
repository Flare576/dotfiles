#!/bin/sh
echo "Cloning DotFiles repo"

cd $HOME/dotfiles
git secrets --install
git secrets --register-aws
