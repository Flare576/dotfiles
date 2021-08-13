#!/bin/bash
echo "Securing DotFiles repo"

cd $HOME/dotfiles
git secrets --install
git secrets --register-aws
