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
  zsh                             # Preferred shell
  python                          # must preceed vim
  pipenv                          # Handles pip dependencies, uses pyenv for pinned core python versions
  bat                             # enhanced version of the cat command
  cheat                           # provides cheat sheets for many commands, try 'cheat tar'
  git                             # it's git
  hub                             # overlay to git, adds github-specific calls/functionality
  nvm                             # Node Version Manager - makes having mulitple projects easier
  shellcheck                      # helps debugging/formatting shell scripts
  tmux                            # terminal multi-panel/window tool
  the_silver_searcher             # provides enhanced search support with 'ag'
  vim                             # it's vim
  watch                           # repeatedly call a command and monitor output
  jq                              # work with JSON with a command-line query language
  watson                          # Great time tracker
  k9s                             # Any project using K8s
  lazydocker                      # Any project using straight Docker
  awscli                          # Amazon Web Service CLI
  rpg-cli                         # A bit of fun for folder management
  flare576/scripts/monitorjobs    # AWS-cli based job monitoring
  flare576/scripts/git-clone      # Manage multiple git accounts for cloning projects
  flare576/scripts/gac            # 'gac' git overlay for add/commit
  flare576/scripts/dvol           # manage Docker Volumes outside of project docker-compose files
  flare576/scripts/newScript      # facilitate creating new scripts in varius languages
  flare576/scripts/vroom          # wrapper for 'make' command to start/manage project execution
  flare576/scripts/switch-theme   # tool for changing tmux, vim, bat, zhs, etc. themes 
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
    HOMEBREW_NO_INSTALL_CLEANUP=1 HOMEBREW_NO_AUTO_UPDATE=1 brew install "$formula"
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
