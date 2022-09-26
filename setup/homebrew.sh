#!/bin/bash
# takes 1 param: true to upgrade installed brews

isLinux=0; [ -f "/etc/os-release" ] && isLinux=1
# Install Homebrew
if test ! $(which brew); then
  echo "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

# Install Good Stuff
brews=(
  bat                             # enhanced version of the cat command
  cheat                           # provides cheat sheets for many commands, try 'cheat tar'
  fzf                             # FuzzyFind lets you search through piped-in data (useful with history)
  git                             # it's git
  hub                             # overlay to git, adds github-specific calls/functionality
  nvm                             # Node Version Manager - makes having mulitple projects easier
  shellcheck                      # helps debugging/formatting shell scripts
  the_silver_searcher             # provides enhanced search support with 'ag'
  universal-ctags                 # generates indexes used by vim for "intellisense"-like features
  watch                           # repeatedly call a command and monitor output
  jq                              # work with JSON with a command-line query language
  watson                          # Great time tracker
  k9s                             # Any project using K8s
  lazydocker                      # Any project using straight Docker
  awscli                          # Amazon Web Service CLI
  rpg-cli                         # A bit of fun for folder management
)

echo "Installing brews"
brew update
for formula in "${brews[@]}"
do
  echo "Working on $formula"
  if brew ls --versions "$formula" >/dev/null; then
    if [[ "$1" == "update" ]]; then
      HOMEBREW_NO_AUTO_UPDATE=1 brew upgrade "$formula"
    fi
  else
    HOMEBREW_NO_INSTALL_CLEANUP=1 HOMEBREW_NO_AUTO_UPDATE=1 brew install "$formula"
  fi
done

#TODO check terminal plist for themes and call switch-theme -s if not found
#TODO ... but that only works for osx :/ keep thinkning
#TODO add that sort of check to the setup script and just always call it here!

echo "Grabbing Cheatsheets and zsh tab completion"
communityDir=$HOME/dotfiles/cheat/community

if [ -d "$communityDir" ]; then
  pushd "$communityDir" && git pull -f && popd
else
  git clone https://github.com/cheat/cheatsheets.git "$communityDir"
fi

# Jetbrains Mono is a great font for terminals; install it so it's available on this system
if [ "$isLinux" -eq "1" ] ; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"
else
  if brew ls --versions homebrew/cask-fonts/font-jetbrains-mono >/dev/null; then
    if [[ "$1" == "update" ]]; then
      brew upgrade --cask homebrew/cask-fonts/font-jetbrains-mono
    fi
  else
    brew install --cask homebrew/cask-fonts/font-jetbrains-mono
  fi
fi
