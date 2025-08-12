#!/bin/bash
# This script is designed to setup a new Steam Deck from scratch. If you just want pieces of my dot files, check the
# Setup Scripts referenced here or read the Project ReadMe!
#
# Explanation
# 1. Clone flare576/dotfiles to $HOME
# 2. Link 'dotfiles' (.zshrc, .zshenv, etc.) from $HOME into **dotfiles**
# 3. distrobox comes pre-installed as of SteamOS 3.5, but the script checks for it anyway and installs from flatpak
# 4. If no container
#   a. Create archlinux:latest
#   b. Update pacman
#   c. Install basic needs
#   d. Export "ZSH" to host
#   e. Install steamdeck profile apps
# 5. If container already exists
#   a. Update pacman
#   b. Update/Install basic needs
#   c. Update steamdeck profile apps
#
# After, open Konsole, type `zsh`, and you'll be in the issolated container. Try calling tmux next!

# Pull the rest of the project
cd $HOME
if [ ! -d dotfiles ]; then
  echo "Cloning flare576/dotfiles locally"
  git clone https://github.com/Flare576/dotfiles.git
  echo "Setting up Talisman as git hook"
  # Install safety precautions around this repo
  bash $HOME/dotfiles/setup/secureRepo.sh
fi

# `linkFiles` intelligently detects existing links/files, so you can run it every time
echo "Linking dotfiles"
bash $HOME/dotfiles/setup/linkFiles.sh

echo "Verifying Distrobox"

export DOT_CONTAINER="dot_utils"

if ! command -v distrobox &> /dev/null; then
  echo "Installing distrobox"
  flatpak install -y --noninteractive flathub org.distrobox.Distrobox
fi

echo "Verifying '$DOT_CONTAINER' container"

CORE="coreutils tar less findutils diffutils grep sed gawk util-linux procps-ng base-devel git zsh"

if ! distrobox list | grep -q "$DOT_CONTAINER"; then
  echo "Creating distrobox container '$DOT_CONTAINER'..."
  distrobox create --name "$DOT_CONTAINER" --image archlinux:latest
  echo "Initializing '$DOT_CONTAINER'"
  distrobox enter "$DOT_CONTAINER" -- \
    bash -c '
      sudo pacman -Syu --noconfirm
      sudo pacman -S --noconfirm '"$CORE"'
      # Wire up zsh as the entry point
      distrobox-export --bin "/usr/bin/zsh"
      bash $HOME/dotfiles/setup/installer.sh -p steamdeck
      # Setup yay
      git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
      cd /tmp/yay-bin
      makepkg -si
    '
  # May need to write the location that distrobox exports to to .bashrc
  if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.bashrc"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
  fi
  echo "Done! You may need to open a new Konsole window"
else
  echo "Updating '$DOT_CONTAINER'..."
  distrobox enter "$DOT_CONTAINER" -- \
    bash -c '
      sudo pacman -Syu --noconfirm
      # Base Utils
      sudo pacman -S --noconfirm '"$CORE"'
      # update yay apps
      yay

      bash $HOME/dotfiles/setup/installer.sh -u -p steamdeck
    '
fi
