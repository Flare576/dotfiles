#!/bin/sh
# This script is designed to setup a new Ubuntu Linux from scratch. If you just want pieces of my dot files, check the
# Setup Scripts referenced here or read the Project ReadMe!

# Install Homebrew
if test ! $(which brew); then
  echo "Installing Homebrew requirements"
  # sudo apt-get -y install build-essential curl file git
  echo "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
  echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile
  brew install llvm
fi
# Pull the rest of the project
cd $HOME
git clone https://github.com/Flare576/dotfiles.git

# Install Homebrew and applications
bash $HOME/dotfiles/scripts/setupHomebrew.sh

# Install safety precautions around this repo
bash $HOME/dotfiles/scripts/setupRepo.sh

# Link dotFiles
bash $HOME/dotfiles/scripts/setupLinks.sh

# Setup Scripts
bash $HOME/dotfiles/scripts/setupScripts.sh

# Setup GIT
bash $HOME/dotfiles/scripts/setupGit.sh

# Setup Oh-My-Zsh
bash $HOME/dotfiles/scripts/setupOmz.sh

# Setup terminal
bash $HOME/dotfiles/scripts/setupGnome.sh

# Setup VIM
bash $HOME/dotfiles/scripts/setupVim.sh

# Setup Jira
bash $HOME/dotfiles/scripts/setupJira.sh
