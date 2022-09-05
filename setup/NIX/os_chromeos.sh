#!/bin/sh
# This script is designed to setup a new Chromebook from scratch. If you just want pieces of my dot files, check the
# Setup Scripts referenced here or read the Project ReadMe!

# Ensure git is available, or install it via native method
if ! command -v git &> /dev/null; then
  sudo apt-get update
  sudo apt-get --no-install-recommends --no-install-suggests -y install build-essential curl file git
fi

# Pull the rest of the project
cd $HOME
#git clone https://github.com/Flare576/dotfiles.git

# Install Homebrew and applications
bash $HOME/dotfiles/setup/homebrew.sh -m

# Install safety precautions around this repo
bash $HOME/dotfiles/setup/secureRepo.sh

# Link dotFiles
bash $HOME/dotfiles/setup/linkFiles.sh

# Setup Scripts
bash $HOME/dotfiles/setup/scripts.sh

# Setup VIM
bash $HOME/dotfiles/setup/vim.sh

# Setup tmux
bash $HOME/dotfiles/setup/tmux.sh

# Setup Oh-My-Zsh
bash $HOME/dotfiles/setup/omz.sh

# Setup Python
bash $HOME/dotfiles/setup/python.sh

# Setup terminal (need to verify still required)
# bash /home/flare576/dotfiles/setup/NIX/chrome_gnome.sh
