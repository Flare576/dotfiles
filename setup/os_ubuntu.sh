#!/bin/bash
# This script is designed to setup a new Linux Ubuntu from scratch. If you just want pieces of my dot files, check the
# Setup Scripts referenced here or read the Project ReadMe!
#
# It should be noted that this file will allow you to install as root; this is to allow me to setup new Docker images

# Pull the rest of the project
cd $HOME
git clone https://github.com/Flare576/dotfiles.git

# Install safety precautions around this repo
bash $HOME/dotfiles/setup/secureRepo.sh

# Install Applications
bash $HOME/dotfiles/setup/installer.sh -p personal

# Link dotFiles
echo "Linking dotfiles"
bash $HOME/dotfiles/setup/linkFiles.sh
