#!/bin/sh
# This script is designed to setup a new Linux Ubuntu from scratch. If you just want pieces of my dot files, check the
# Setup Scripts referenced here or read the Project ReadMe!
#
# It should be noted that this file will allow you to install as root; this is to allow me to setup new Docker images

# Install Homebrew
if ! command -v brew &> /dev/null ; then
  # If user is root, double-check. Installing quickly on a remote box is a use case of mine
  if [[ "${EUID:-${UID}}" == "0" ]]; then
    echo -n "You're [31mroot[39m right now... that OK? (y/n) "
    read iamroot
    if [[ ! "$iamroot" =~ ^[yY] ]] ; then
      abort "I am (g)root"
    fi
    apt-get update
    export DEBIAN_FRONTEND=noninteractive
    apt-get --no-install-recommends --no-install-suggests -y install build-essential curl file git sudo
    yes '' | bash -c "$(
      curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh |
      sed 's/"${EUID:-${UID}}" == "0"/"true" == "false"/'
    )"
    eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >> /root/.profile
  else
    echo "Installing Homebrew requirements"
    apt update
    if command -v sudo &> /dev/null ; then
      apt -y install sudo
    fi
    sudo apt-get --no-install-recommends --no-install-suggests -y install build-essential curl file git
    echo "Installing Homebrew"
    yes '' | bash -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
  fi
  eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
  echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile
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
# bash $HOME/dotfiles/scripts/setupGnome.sh

# Setup VIM
bash $HOME/dotfiles/scripts/setupVim.sh

# Setup Jira
bash $HOME/dotfiles/scripts/setupJira.sh
