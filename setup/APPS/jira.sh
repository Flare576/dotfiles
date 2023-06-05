#!/bin/bash
# https://github.com/Netflix-Skunkworks/go-jira
source "$(dirname "$0")/../utils.sh"

usage="$(basename "$0") [-hvdu]
Links Jira configs and Installs/Upgrades Go-Jira.
Go-Jira is a CLI for Atlassian's Jira project management system.
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
  rm -rf "$HOME/.jira.d"
  if ! dotRemove flare576/scripts/jira-cli "manual"; then
    rm /usr/local/bin/jira
  fi
  exit
fi

if [ "$doUpdate" == "true" ] && ! command -v jira; then
  exit
fi

if [ "$doUpdate" != "true" ]; then
  read -p "Are you actively working on JIRA instance? (Y/n)" doit
  echo
fi

if [ "$doUpdate" == "true" ] || [[ $doit =~ ^[yY] ]] ; then
  if ! dotInstall flare576/scripts/jira-cli "manual"; then
    # Note: This installs go-jira, but not my extensions. Next time I'm setting up a Linux box I'll be able to experiment
    DLURL=$(latestGit "go-jira/jira" "jira-linux-amd64")
    curl -sL ${DLURL} -o /tmp/jira-linux-amd64 \
    && chmod +x /tmp/jira-linux-amd64 \
    && mv /tmp/jira-linux-amd64 /usr/local/bin/jira
  fi
fi

if [[ $doit =~ ^[yY] ]] ; then
  jira-setup
fi
