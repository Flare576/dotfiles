#!/bin/bash
source "$(dirname "$0")/../utils.sh"

usage="$(basename "$0") [-hvd]
Installs/Updates NVM
NVM is the Node Version Manager
  -h Show this help
  -v Display version
  -d Uninstall NVM
"
while getopts ':hvd' option; do
  case "$option" in
    h) echo "$usage"
      exit
      ;;
    v) echo "$VERSION"
      exit
      ;;
    d) doDestroy="true"
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

if ! dotInstall nvm "manual"; then
  cloneOrUpdateGit "nvm-sh/nvm" "$HOME/.nvm"
fi
