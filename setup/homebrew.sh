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
  pipenv # Handles pip dependencies, uses pyenv for pinned core python versions
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
  watson # Great time tracker
  k9s # Any project using K8s
  lazydocker # Any project using straight Docker
  rpg-cli
  flare576/scripts/monitorjobs
  flare576/scripts/git-clone
  flare576/scripts/gac
  flare576/scripts/dvol
  flare576/scripts/newScript
  flare576/scripts/vroom
  flare576/scripts/switch-theme
)

if [ "$isLinux" -ne "1" ] ; then
  brews+=(cask kubectx mas)
fi

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
    HOMEBREW_NO_AUTO_UPDATE=1 brew install "$formula"
  fi
done

echo "Grabbing Cheatsheets and zsh tab completion"
communityDir=$HOME/dotfiles/cheat/community

if [ -d "$communityDir" ]; then
  pushd "$communityDir" && git pull -f && popd
else
  git clone https://github.com/cheat/cheatsheets.git "$communityDir"
fi

if brew ls --versions universal-ctags >/dev/null; then
  if [[ "$1" == "update" ]]; then
    brew upgrade --fetch-HEAD universal-ctags
  fi
else
  brew tap universal-ctags/universal-ctags
  HOMEBREW_NO_AUTO_UPDATE=1 brew install --HEAD universal-ctags
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
