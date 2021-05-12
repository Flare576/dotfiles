#!/bin/sh
# This script is designed to remove custom/personal items from a mac, undoing the original dotfiles install.

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall.sh)"
cd $HOME

# For now, not altering setupGit.sh as it's configured to also be stand-alone; just nuke the certs above

bash $HOME/dotfiles/scripts/setupLinks.sh "delete"
bash $HOME/dotfiles/scripts/setupScripts.sh "delete"
bash $HOME/dotfiles/scripts/setupOmz.sh "delete"
bash $HOME/dotfiles/scripts/OSX/setupDockAndSystem.sh "delete"
bash $HOME/dotfiles/scripts/setupVim.sh "delete"

rm -rf dotfiles $zshTabComplete .ssh

# Note: Linux will need to remove JetBrains font; not installed via homebrew
