#!/bin/bash
# This script is designed to remove custom/personal items from a mac, undoing the original dotfiles install.

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

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall.sh)"
cd $HOME

# For now, not altering setupGit.sh as it's configured to also be stand-alone; just nuke the certs above

bash $HOME/dotfiles/scripts/setupLinks.sh "delete"
bash $HOME/dotfiles/scripts/setupScripts.sh "delete"
bash $HOME/dotfiles/scripts/setupOmz.sh "delete"
bash $HOME/dotfiles/scripts/OSX/setupDockAndSystem.sh "delete"
bash $HOME/dotfiles/scripts/setupVim.sh "delete"
bash $HOME/dotfiles/scripts/setupJira.sh "delete"

rm -rf dotfiles $zshTabComplete .ssh cheat

# Note: Linux will need to remove JetBrains font; not installed via homebrew
