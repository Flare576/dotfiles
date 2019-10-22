#!/bin/sh
# This script is designed to setup a new Linux Mint from scratch. If you just want pieces of my dot files, check the
# Setup Scripts referenced here or read the Project ReadMe!

# Install Homebrew
if test ! $(which brew); then
  echo "Installing Homebrew requirements"
  sudo apt-get -y install build-essential curl file git
  echo "Installing Homebrew"
  yes '' | sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
  # Temporarily set environment variables: dotfile profile will set in future sessions
  eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
fi

# Pull the rest of the project
cd $HOME
git clone https://github.com/Flare576/dotfiles.git
cd dotfiles
git switch mintyFresh
cd ..

# Install Homebrew and applications
sh $HOME/dotfiles/scripts/setupHomebrew.sh

# Install safety precautions around this repo
sh $HOME/dotfiles/scripts/setupRepo.sh

# Link dotFiles
sh $HOME/dotfiles/scripts/setupLinks.sh

# Setup GIT
sh $HOME/dotfiles/scripts/setupGit.sh

# Setup Oh-My-Zsh
sh $HOME/dotfiles/scripts/setupOmz.sh

# Setup application
sh $HOME/dotfiles/scripts/setupCasks.sh

# Configure iTerm2
sh $HOME/dotfiles/scripts/setupIterm.sh

# Setup background and dock settings
sh $HOME/dotfiles/scripts/setupDockAndSystem.sh

# Setup VIM
sh $HOME/dotfiles/scripts/setupVim.sh

# Setup Jira
sh $HOME/dotfiles/scripts/setupJira.sh

# Force setup of apps
open -a Spotify
read -p "Once you setup Spotify, press enter."
open -a Dropbox
read -p "Once you setup Dropbox, press enter."

