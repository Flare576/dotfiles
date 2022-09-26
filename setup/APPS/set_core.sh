#!/bin/bash
source "$(dirname "$0")/../utils.sh"

applications=(
  bat                  # enhanced version of the cat command
  fzf                  # FuzzyFind lets you search through piped-in data (useful with history)
  git                  # it's git
  hub                  # overlay to git, adds github-specific calls/functionality
  shellcheck           # helps debugging/formatting shell scripts
  the_silver_searcher  # provides enhanced search support with 'ag'
  universal-ctags      # generates indexes used by vim for "intellisense"-like features
  watch                # repeatedly call a command and monitor output
  jq                   # work with JSON with a command-line query language
  rpg-cli              # A bit of fun for folder management
)

usage="$(basename "$0") [-hvmd]
Installs tools I want on every machine I work on: ${applications[@]}
Options:
  -h Show this help
  -v Display version
  -m Install minimal versions of tools/apps
  -d Unlink files and Uninstall zsh/omz/plugins
"

while getopts ':hvdm' option; do
  case "$option" in
    h) echo "$usage"
      exit
      ;;
    v) echo "$VERSION"
      exit
      ;;
    d) doDestroy="true"
      ;;
    m) minimal="-m"
      ;;
    *) echo "Unknown Option '$option', exiting"
      exit
      ;;
  esac
done
shift $((OPTIND -1))

if [ "$doDestroy" == "true" ]; then
  for app in "${applications[@]}"
  do
    case "$app" in
      "the_silver_searcher") dotRemove "$app" "silversearcher-ag"
        ;;
      *) dotRemove "$app"
        ;;
    esac
  done
  rm -rf "$communityDir"
  bash "$HOME/dotfiles/setup/APPS/cheat.sh" -d
  bash "$HOME/dotfiles/setup/APPS/omz.sh" -d
  bash "$HOME/dotfiles/setup/APPS/python.sh" -d
  bash "$HOME/dotfiles/setup/APPS/scripts.sh" -d
  bash "$HOME/dotfiles/setup/APPS/tmux.sh" -d
  bash "$HOME/dotfiles/setup/APPS/vim.sh" -d
  exit
fi


for app in "${applications[@]}"
do
  case "$app" in
    "the_silver_searcher") dotInstall "$app" "silversearcher-ag"
      ;;
    *) dotInstall "$app"
      ;;
  esac
done

# Jetbrains Mono is a great font for terminals; install it so it's available on this system
if [ "$isLinux" == "true" ] ; then
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

bash "$HOME/dotfiles/setup/APPS/cheat.sh"
bash "$HOME/dotfiles/setup/APPS/omz.sh"
bash "$HOME/dotfiles/setup/APPS/python.sh"
bash "$HOME/dotfiles/setup/APPS/scripts.sh"
bash "$HOME/dotfiles/setup/APPS/tmux.sh"
bash "$HOME/dotfiles/setup/APPS/vim.sh" $minimal
