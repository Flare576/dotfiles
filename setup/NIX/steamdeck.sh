#!/bin/bash
# This script is designed to setup a new Steam Deck from scratch. If you just want pieces of my dot files, check the
# Setup Scripts referenced here or read the Project ReadMe!
#
# Pull the rest of the project
cd $HOME
git clone https://github.com/Flare576/dotfiles.git

# Install safety precautions around this repo
bash $HOME/dotfiles/setup/secureRepo.sh

# Configure Pacman
echo "Configuring Pacman"
sudo steamos-readonly disable
sudo pacman-key --init > /dev/null
sudo pacman-key --populate archlinux > /dev/null
sudo pacman-key --populate holo > /dev/null
sudo pacman -Sy > /dev/null
sudo steamos-readonly enable

# Install Applications
bash $HOME/dotfiles/setup/installer.sh -p steamdeck

# Link dotFiles
echo "Linking dotfiles"
bash $HOME/dotfiles/setup/linkFiles.sh
