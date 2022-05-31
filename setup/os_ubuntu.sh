#!/bin/bash
# This script is designed to setup a new Linux Ubuntu from scratch. If you just want pieces of my dot files, check the
# Setup Scripts referenced here or read the Project ReadMe!
#
# It should be noted that this file will allow you to install as root; this is to allow me to setup new Docker images

# Install Homebrew
if ! command -v brew &> /dev/null ; then
  # If user is root, double-check. Installing quickly on a remote box is a use case of mine
  if [[ "${EUID:-${UID}}" == "0" ]]; then
    echo -n "You're [31mroot[39m right now, and homebrew won't work. Setup user? (y/n) "
    read iamroot
    if [[ ! "$iamroot" =~ ^[yY] ]] ; then
      abort "I am (g)root. Try os_ubuntu_no_homebrew.sh"
    fi
    apt-get update
    export DEBIAN_FRONTEND=noninteractive
    apt-get --no-install-recommends --no-install-suggests -y install build-essential ca-certificates curl file git sudo
    echo -n "Enter new username "
    read newname
    useradd -s /bin/bash -m $newname
    passwd $newname
    usermod -aG sudo $newname
    echo "Switching to new user; re-run this command"
    su $newname 
    return
  else
    echo "Installing Homebrew requirements"
    apt update
    if command -v sudo &> /dev/null ; then
      apt -y install sudo
    fi
    sudo apt-get --no-install-recommends --no-install-suggests -y install build-essential ca-certificates curl file git
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
bash $HOME/dotfiles/setup/homebrew.sh

# Install safety precautions around this repo
bash $HOME/dotfiles/setup/secureRepo.sh

# Link dotFiles
echo "Linking dotfiles"
bash $HOME/dotfiles/setup/linkFiles.sh

# Setup Scripts
echo "Cloning bash/nodejs scripts"
bash $HOME/dotfiles/setup/scripts.sh 'true'

# Setup Oh-My-Zsh
echo "Configuring ZSH"
bash $HOME/dotfiles/setup/omz.sh

# Setup VIM
echo "Installing vim plugins"
bash $HOME/dotfiles/setup/vim.sh 'true'

# Setup Jira
bash $HOME/dotfiles/setup/jira.sh