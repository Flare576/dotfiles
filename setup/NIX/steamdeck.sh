#!/bin/bash
# If you just updated SteamOS, you'll **probably** need to run this script again.
# I'm trying to get it setup so that pacman installs to $HOME so you don't need to re-install apps, but it's
# Iterative becuse I can't really format my Steam Deck
#
# This script is designed to setup a new Steam Deck from scratch. If you just want pieces of my dot files, check the
# Setup Scripts referenced here or read the Project ReadMe!
#
# Pull the rest of the project
cd $HOME
if [ ! -d dotfiles ]; then
  init="true"
  git clone https://github.com/Flare576/dotfiles.git
fi

# Install safety precautions around this repo
#bash $HOME/dotfiles/setup/secureRepo.sh

# Configure Pacman
echo "Configuring Pacman"
export USERROOT="$HOME/.root"
mkdir -p "$USERROOT/etc"
mkdir -p "$USERROOT/var/lib/pacman"

# Copy the pacman config file from the original system
pacman_conf="$USERROOT/etc/pacman.conf"
cp /etc/pacman.conf "$pacman_conf"

# Create the keyring directory
gpgdir="$USERROOT/etc/pacman.d/gnupg"
mkdir -p "$gpgdir"

# Initialize the keyring
sudo pacman-key --gpgdir "$gpgdir" --conf "$pacman_conf" --init

# Populate the keyring
sudo pacman-key --gpgdir "$gpgdir" --conf "$pacman_conf" --populate archlinux
sudo pacman-key --gpgdir "$gpgdir" --conf "$pacman_conf" --populate holo

sudo steamos-readonly disable
sudo pacman -r $USERROOT --gpgdir $USERROOT/etc/pacman.d/gnupg -Sy
sudo pacman -r $USERROOT --gpgdir $USERROOT/etc/pacman.d/gnupg -S coreutils tar less findutils diffutils grep sed gawk util-linux procps-ng base-devel
sudo steamos-readonly enable

# Probably should just install yay here... TBD
# Oh, but need to figure out how to do makepkg install to pacman's --root

# Pass in "init" to wire up the homedir links/paths/etc.
if [ -n "$init" ]; then
  # Link dotFiles
  echo "Linking dotfiles"
  bash $HOME/dotfiles/setup/linkFiles.sh

  cat > ~/.doNotCommit.d/.doNotCommit.steamdeck <<EOF
export USERROOT="\$HOME/.root"
export PATH=\$PATH:"\$USERROOT/usr/bin"
export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:"\$USERROOT/lib":"\$USERROOT/lib64"
EOF
  bash $HOME/dotfiles/setup/installer.sh -p steamdeck
  # We DON'T want to default to zsh - we want deck to launch to bash
  bash $HOME/dotfiles/setup/installer.sh -m omz
  # Leaving a note - installing shellcheck required
  # clone https://aur.archlinux.org/shellcheck-bin.git
  # cd shellcheck-bin
  # makepkg -s
  # and then opening the tar that got created/downloaded, and dropping the exec into my path
else
  # Just update
  bash $HOME/dotfiles/setup/installer.sh -u -p steamdeck
  # We DON'T want to default to zsh - we want deck to launch to bash
  bash $HOME/dotfiles/setup/installer.sh -u -m omz
fi
