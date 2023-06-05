#!/bin/bash
source "$(dirname "$0")/../utils.sh"

usage="$(basename "$0") [-hvdu]
Installs/Updates NVM
NVM is the Node Version Manager
  -h Show this help
  -v Display version
  -d Uninstall
  -u Update if installed
"
while getopts ':hvadmu' option; do
  case "$option" in
    h) echo "$usage"
      exit
      ;;
    v) echo "$VERSION"
      exit
      ;;
    d) doDestroy="true"
      ;;
    u) doUpdate="true"
      ;;
    a) echo "Ignoring -a, no all settings"
      ;;
    m) echo "Ignoring -m, no minimal settings"
      ;;
    *) echo "Unknown Option '$option', exiting"
      exit
      ;;
  esac
done
shift $((OPTIND -1))

if [ "$doDestroy" == "true" ]; then
  if ! dotRemove nvm "manual"; then
    echo "Removing ~/.nvm"
    rm -rf "$HOME/.nvm"
  fi
  exit
fi

if [ "$doUpdate" == "true" ] && ! command -v nvm; then
  exit
fi

if ! dotInstall nvm "manual"; then
  cloneOrUpdateGit "nvm-sh/nvm" "$HOME/.nvm"
fi
