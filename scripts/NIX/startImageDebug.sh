#!/bin/bash
# Make working on images suck less

# nvm: curl -sL https://raw.githubusercontent.com/creationix/nvm/v0.35.3/install.sh -o install_nvm.sh

# To make things fast, trying to avoid homebrew
apt update;apt install -y curl zsh bat git/focal git-secrets hub silversearcher-ag vim jq

# Pull the rest of the project
cd $HOME
git clone https://github.com/Flare576/dotfiles.git

# Install safety precautions around this repo
bash $HOME/dotfiles/scripts/setupRepo.sh

# Link dotFiles
bash $HOME/dotfiles/scripts/setupLinks.sh

# Setup Scripts
bash $HOME/dotfiles/scripts/setupScripts.sh 'true'

# Setup Oh-My-Zsh
bash $HOME/dotfiles/scripts/setupOmz.sh

# Setup VIM
bash $HOME/dotfiles/scripts/setupVim.sh 'true'
