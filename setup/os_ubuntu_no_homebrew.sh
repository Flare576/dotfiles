#!/bin/bash
# Make working on images suck less
# from initial prompt:
# apt-get update &> /dev/null;apt-get install -y --no-install-recommends ca-certificates curl &> /dev/null;bash -c "$(curl -sSL https://raw.githubusercontent.com/Flare576/dotfiles/main/setup/os_ubuntu_no_homebrew.sh)"

# To make things fast, trying to avoid homebrew
starting=$(date +%s%N)
packages=(
  curl
  sudo
  zsh
  bat
  git
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

apt-get update &> /dev/null
for pack in ${packages[@]};
do
  echo "Installing $pack"
  apt-get install --no-install-recommends -y $pack &> /dev/null
done

# Pull the rest of the project
cd $HOME
echo "Cloning dotfiles"
git clone -q https://github.com/Flare576/dotfiles.git

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

# Finish with a CTA!
ending=$(date +%s%N)
sec=1000000000
duration=$((ending - starting))
seconds=$(( duration / sec ))
millis=$(( (duration - (seconds * sec)) / 1000000 ))

echo "[31;47m⏱  TIME ⏱ [0m
Finished in ${seconds}.${millis}s.
Type [91;47mzsh[0m then either [93;47mst light[0m or [37;40mst dark[0m to get stated."
