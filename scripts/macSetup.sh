#!/bin/bash
# Install Homebrew
if test ! $(which brew); then
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Install Good Stuff
brews=(
  bat
  cask
  pyenv
  git
  hub
  nvm
  the_silver_searcher
  zsh
  shellcheck
  git-secrets
  mas
)

brew update
brew install ${brews[@]}
brew install --with-override-system-vi vim
pyenv install 3.7.2
pyenv global 3.7.2

# Pull the rest of the project
cd $HOME
git clone https://github.com/Flare576/dotfiles.git
# Link dotFiles
sh $HOME/dotfiles/scripts/linkFiles.sh

cd dotfiles
git secrets --install
git secrets --register-aws

# Setup GIT
sh $HOME/dotfiles/scripts/gitSetup.sh

# Setup Oh-My-Zsh
sh $HOME/dotfiles/scripts/omzSetup.sh

# Specify the preferences directory for iTerm2
defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "${HOME}/dotfiles/"
# Tell iTerm2 to use the custom preferences in the directory
defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true

apps=(
  homebrew/cask-versions/docker-edge
  dropbox
  firefox
  iterm2
  launchbar
  slack
  steam
  spotify
  vlc
  google-chrome
)

brew cask install --appdir="/Applications" ${apps[@]}

# Setup background and dock settings
sh $HOME/dotfiles/scripts/dockAndSystem.sh

# Setup VIM
sh $HOME/dotfiles/scripts/vimSetup.sh

# Setup Jira
sh $HOME/dotfiles/scripts/jiraSetup.sh

# Setup iTerm Location stuff
sh $HOME/dotfiles/scripts/itermLayout.sh

# Force setup of apps
open -a Spotify
read -p "Once you setup Spotify, press enter."
open -a Dropbox
read -p "Once you setup Dropbox, press enter."

