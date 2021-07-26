#!/bin/bash
# takes 1 param: true to upgrade installed brews

# uctags="universal-ctags/universal-ctags/universal-ctags"
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
  pyenv # Handles Python venvs
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
)

if [ "$isLinux" -ne "1" ] ; then
  brews+=(cask kubectx mas)
else
  brew install --HEAD --without-xml $uctags
  # all of this because the current brew install can't find a dependency
  # pushd /tmp
  # prefix=$(brew install --HEAD $uctags |
  #   sed -e 's/^.*\/configure --prefix=//' -e 'tx' -e 'd' -e ':x'
  # )
  # git clone https://github.com/universal-ctags/ctags.git
  # pushd ctags
  # mkdir -p "$prefix"
  # ./autogen.sh
  # ./configure --prefix="$prefix"
  # make
  # make install
  # brew link $uctags
  # popd
  # popd
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
zshTabComplete=$HOME/.oh-my-zsh/completions/cheat

if [ -d "$communityDir" ]; then
  pushd "$communityDir" && git pull -f && popd
  pushd "$zshTabComplete" && git pull -f && popd
else
  git clone https://github.com/cheat/cheatsheets.git "$communityDir"
  git clone https://github.com/cheat/cheat.git "$zshTabComplete"
  ln -sf "$zshTabComplete/cheat/cheat.zsh" "$zshTabComplete/_cheat.zsh"
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
