#!/bin/bash
# Make working on images suck less
# from initial prompt:
# apt update &> /dev/null;apt install -y curl &> /dev/null;bash -c "$(curl -sSL https://raw.githubusercontent.com/Flare576/dotfiles/master/scripts/NIX/startImageDebug.sh)"

# nvm: curl -sL https://raw.githubusercontent.com/creationix/nvm/v0.35.3/install.sh -o install_nvm.sh

# To make things fast, trying to avoid homebrew
starting=$(date +%s%N)
packages=(
  curl
  sudo
  zsh
  bat
  git/focal
  git-secrets
  hub
  silversearcher-ag
  vim
  jq
  tmux
  python3-pip
  universal-ctags
)

echo "Installing ${packages[@]}"

export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true
# universal-ctags uses tzdata, which wants configuration info
echo "tzdata tzdata/Areas select US
tzdata tzdata/Zones/US select Central" | debconf-set-selections

apt update &> /dev/null
apt install -y ${packages[@]} &> /dev/null

which git

# Pull the rest of the project
cd $HOME
echo "Cloning dotfiles"
git clone https://github.com/Flare576/dotfiles.git &> /dev/null

# Install safety precautions around this repo
bash $HOME/dotfiles/scripts/setupRepo.sh

# Link dotFiles
echo "Linking dotfiles"
bash $HOME/dotfiles/scripts/setupLinks.sh

# Setup Scripts
echo "Cloning bash/nodejs scripts"
bash $HOME/dotfiles/scripts/setupScripts.sh 'true'

# Setup Oh-My-Zsh
echo "Configuring ZSH"
bash $HOME/dotfiles/scripts/setupOmz.sh

# Setup VIM
echo "Installing vim plugins"
bash $HOME/dotfiles/scripts/setupVim.sh 'true'

# Finish with a CTA!
ending=$(date +%s%N)
sec=1000000000
duration=$((ending - starting))
seconds=$(( duration / sec ))
millis=$(( (duration - (seconds * sec)) / 1000000 ))

echo "

[31;47m⏱  TIME ⏱ [0m
Finished in ${seconds}.${millis}s.
Type [91;47mzsh[0m then either [93;47mst light[0m or [37;40mst dark[0m to get stated."
