#!/bin/bash
source "$(dirname "$0")/../utils.sh"

applications=(
  awscli               # Amazon Web Service CLI
  bat                  # enhanced version of the cat command
  fzf                  # FuzzyFind lets you search through piped-in data (useful with history)
  git                  # it's git
  hub                  # overlay to git, adds github-specific calls/functionality
  jq                   # work with JSON with a command-line query language
  k9s                  # Any project using K8s
  lazydocker           # Any project using straight Docker
  rpg-cli              # A bit of fun for folder management
  shellcheck           # helps debugging/formatting shell scripts
  the_silver_searcher  # provides enhanced search support with 'ag'
  universal-ctags      # generates indexes used by vim for "intellisense"-like features
  watch                # repeatedly call a command and monitor output
  watson               # Great time tracker
)

usage="$(basename "$0") [-hvmd]
Installs tools I want on work machines ${applications[@]}:
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
   dotRemove "$app"
  done
  bash "$HOME/dotfiles/setup/APPS/jira.sh" -d
  exit
fi


for app in "${applications[@]}"
do
 dotInstall "$app"
done

bash "$HOME/dotfiles/setup/APPS/jira.sh"
