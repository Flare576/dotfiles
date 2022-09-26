#!/bin/bash
source "$(dirname "$0")/../utils.sh"

applications=(
  watson                          # Great time tracker
  k9s                             # Any project using K8s
  lazydocker                      # Any project using straight Docker
  awscli                          # Amazon Web Service CLI
)

usage="$(basename "$0") [-hvmd]
Installs tools I want on work machines (no overlap of set_core):
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
