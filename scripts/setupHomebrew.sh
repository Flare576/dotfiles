#!/bin/bash
# takes 1 param: true to upgrade installed brews

isLinux=0; [ -f "/etc/os-release" ] && isLinux=1
# Install Homebrew
if test ! $(which brew); then
  echo "Installing Homebrew"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Install Good Stuff
brews=(
  zsh
  python # must preceed vim
  pipenv
  bat
  cheat
  git
  git-secrets
  hub
  nvm
  shellcheck
  tmux
  the_silver_searcher
  vim
  watch
  jq
  k9s # Any project using K8s
  lazydocker # Any project using straight Docker
)

if [ "$isLinux" -ne "1" ] ; then
  brews+=(cask kubectx mas)
else
  # without python-setuptools
  if command -v sudo &> /dev/null ; then
    sudo apt-get -y install libxml2-dev libyaml-de
  else
    apt-get -y install libxml2-dev libyaml-dev
  fi
fi

echo "Installing brews"
brew update
for formula in "${brews[@]}"
do
  echo "Working on $formula"
  if brew ls --versions "$formula" >/dev/null; then
    if [ "$1" == "true" ]; then
      HOMEBREW_NO_AUTO_UPDATE=1 brew upgrade "$formula"
    fi
  else
    HOMEBREW_NO_AUTO_UPDATE=1 brew install "$formula"
  fi
done

echo "Grabbing Cheatsheets"
communityDir=$HOME/dotfiles/cheat/community

if [ -d "$communityDir" ]; then
  pushd "$communityDir"
  git pull -f
  popd
else
  git clone https://github.com/cheat/cheatsheets.git "$communityDir"
fi

uctags="universal-ctags/universal-ctags/universal-ctags"

if brew ls --versions "$uctags" >/dev/null; then
  if [ "$1" == "true" ]; then
    brew upgrade --fetch-HEAD "$uctags"
  fi
fi

  # Jetbrains Mono is a great font for terminals; install it so it's available on this system
if [ "$isLinux" -eq "1" ] ; then
  # I don't remember what these are for, commenting out to see what breaks
  # This is very likely for universal-ctags
  # sudo apt-get install python-setuptools
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"
else
  brew cask install homebrew/cask-fonts/font-jetbrains-mono
fi
