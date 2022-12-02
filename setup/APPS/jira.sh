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
while getopts ':hvdu' option; do
  case "$option" in
    h) echo "$usage"
      exit
      ;;
    v) echo "$VERSION"
      exit
      ;;
    d) doDestroy="true"
      ;;
    d) doUpdate="true"
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

read -p "Are you actively working on JIRA instance? (Y/n)" doit

if [[ $doit =~ ^[yY] ]] ; then
  ln -sf "$HOME/dotfiles/.jira.d" "$HOME"
  if ! dotInstall flare576/scripts/jira-cli "manual"; then
    DLURL=$(latestGit "go-jira/jira" "jira-linux-amd64")
    curl -sL ${DLURL} -o /tmp/jira-linux-amd64 \
    && chmod +x /tmp/jira-linux-amd64 \
    && mv /tmp/jira-linux-amd64 /usr/local/bin/jira
  fi
  echo
  echo "Setting up Jira CLI"
  read -p "What is your email address? " email
  read -p "What is your base Jira URL? " url
  read -s -p "What is your Jira API Token (https://id.atlassian.com/manage/api-tokens)? " api_token
  echo
  read -p "What Jira Project do you normally work on? " proj
  read -p "What do you want to prefix your branches with (usually first name) " prefix
  read -p "If your shortname in Jira is different than you email, what is it? (blank for same) " shortuser

  touch ${HOME}/dotfiles/.jira.d/.jira.issue

  if [ -z $shortuser ] ; then
    short=email
  fi
  url=$(echo $url | sed 's/https:\/\///')

  config="${HOME}/dotfiles/.doNotCommit.d/.doNotCommit.jira"

  cat<<END > ${config}
export JIRA_API_TOKEN=${api_token}
export JIRA_S_ENDPOINT=${url}
export JIRA_S_PROJECT=${proj}
export JIRA_S_LOGIN=${email}
export JIRA_S_PREFIX=${prefix}
export JIRA_S_USER=${shortuser}
END

fi

