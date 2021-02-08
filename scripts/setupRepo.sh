#!/bin/bash
echo "Securing DotFiles repo"

cd $HOME/dotfiles
git secrets --install
git secrets --register-aws

echo "Ensuring dotfiles use ssh"
sed -i'' -e 's/https:\/\/github.com\//git@github.com:/' $HOME/dotfiles/.git/config
