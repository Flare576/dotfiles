#!/bin/sh
# This script is designed to setup a new Mac from scratch. If you just want pieces of my dot files, check the Setup
# Scripts referenced here or read the Project ReadMe!

# Install Homebrew
if test ! $(which brew); then
  echo "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

echo "Installing git for project clone"
brew install git

# Pull the rest of the project
cd $HOME
git clone https://github.com/Flare576/dotfiles.git

# Install Homebrew and applications
bash $HOME/dotfiles/setup/homebrew.sh

# You'll need passwords and stuff
brew install --cask 1password
# manual bits: setup 1password, git, jira, aws, spotify, firefox, slack, launchbar
# sudo: omz/zsh, homebrew, docker, 
# clone needs to be done for "fixing" dotfiles folder and fro getting personaldots
# should be possilble


# Install safety precautions around this repo
bash $HOME/dotfiles/setup/secureRepo.sh

# Link dotFiles
bash $HOME/dotfiles/setup/linkFiles.sh

# Setup Scripts
# this is now only jiraCookies, mmb, gmb
bash $HOME/dotfiles/setup/scripts.sh

# Setup VIM
bash $HOME/dotfiles/setup/vim.sh

# Setup background and dock settings
bash /Users/flare576/dotfiles/setup/OSX/systemSettings.sh

# Setup Oh-My-Zsh
bash $HOME/dotfiles/setup/omz.sh

# Setup Jira
bash $HOME/dotfiles/setup/jira.sh

# Setup application
bash $HOME/dotfiles/setup/OSX/casks.sh
