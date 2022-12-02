#!/bin/sh
# This script is designed to setup a new Mac from scratch. If you just want pieces of my dot files, check the Setup
# Scripts referenced here or read the Project ReadMe!

# Install Homebrew
if test ! $(which brew); then
  echo "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  # Apple Silicon Macs have new directory
  [ -f "/opt/homebrew/bin/brew" ] && eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo "Installing git for project clone"
brew install git

# Pull the rest of the project
cd $HOME
git clone https://github.com/Flare576/dotfiles.git

# Install safety precautions around this repo
bash $HOME/dotfiles/setup/secureRepo.sh

# Link dotFiles
bash $HOME/dotfiles/setup/linkFiles.sh

# Setup background and dock settings
bash $HOME/dotfiles/setup/OSX/systemSettings.sh

# Clean dock
bash $HOME/dotfiles/setup/OSX/cleanDock.sh

# Install applications
bash $HOME/dotfiles/setup/installer.sh -p "work"

# Setup application
bash $HOME/dotfiles/setup/OSX/casks.sh
