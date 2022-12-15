#!/bin/bash
# This script is designed to remove custom/personal items from a mac, undoing the original dotfiles install.

if ! command -v brew &> /dev/null ; then
  echo "Run this where brew is available to clean everything."
  exit
fi
read -p "Are you sure you want to delete all your stuff? (Y/n)" doit

if ! [[ $doit =~ ^[yY] ]] ; then
  echo "Phew. Dodged a bullet there, huh?"
  exit
fi

read -p "No, like, [31mEVERYTHING[0m, even .doNotCommit, which isn't recoverable? (Y/n)" doit
echo

if ! [[ $doit =~ ^[yY] ]] ; then
  echo "Aren't you glad I asked twice?"
  exit
fi

echo "Don't say I didn't give you a chance"

cd $HOME

# For now, not altering setupGit.sh as it's configured to also be stand-alone; just nuke the certs above

bash $HOME/dotfiles/setup/OSX/systemSettings.sh -d
bash $HOME/dotfiles/setup/installer.sh -d
bash $HOME/dotfiles/setup/linkFiles.sh -d

[ -f "$HOME/personaldot/setup/decom.sh" ] && bash $HOME/personaldot/setup/decom.sh
rm -rf dotfiles .ssh cheat personaldot .config

brew remove --force --ignore-dependencies $(brew list --formula)
brew remove --cask --force $(brew list)

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall.sh)"
sudo rm -rf /opt/homebrew
# Note: Linux will need to remove JetBrains font; not installed via homebrew

