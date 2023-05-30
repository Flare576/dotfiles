#!/bin/bash
source "$(dirname "$0")/../utils.sh"
communityDir=$HOME/dotfiles/cheat/community

usage="$(basename "$0") [-hvdu]
Links Cheat configs and Installs/Upgrades Cheat and community cheat sheets.
Cheat is a tool that prints out notes you've taken (or borrowed) about commands, tools, etc. - try 'cheat tar'
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
  echo "Removing ~/cheat"
  rm -rf "$HOME/cheat"
  rm -rf "$communityDir"
  if ! dotRemove cheat "manual"; then
    rm /usr/local/bin/cheat
  fi
  exit
fi

if [ "$doUpdate" == "true" ] && ! command -v cheat; then
  exit
fi

if ! dotInstall cheat "manual"; then
  DLURL=$(latestGit "cheat/cheat" "cheat-linux-amd64.gz")
  curl -sL ${DLURL} -o /tmp/cheat-linux-amd64.gz \
  && gunzip /tmp/cheat-linux-amd64.gz \
  && chmod +x /tmp/cheat-linux-amd64 \
  && mv /tmp/cheat-linux-amd64 /usr/local/bin/cheat
fi

echo "Linking cheat and updating community sheets"
ln -fs "$HOME/dotfiles/cheat" "$HOME"

if [ -d "$communityDir" ]; then
  pushd "$communityDir" &> /dev/null || exit
  git pull -f
  popd &> /dev/null || exit
else
  git clone https://github.com/cheat/cheatsheets.git "$communityDir"
fi

