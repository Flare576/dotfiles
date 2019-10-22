#!/bin/bash
# https://github.com/Netflix-Skunkworks/go-jira
ln -sf $HOME/dotfiles/.jira.d $HOME
brew install go-jira
read -p "Are you actively working on JIRA instance? (Y/n)" doit
echo

if [[ $doit =~ ^[yY] ]] ; then
  echo "Setting up Jira CLI"
  read -p "What is your email address? " email
  read -p "What is your base Jira URL? " url
  read -s -p "What is your Jira API Token (https://id.atlassian.com/manage/api-tokens)? " api_token
  echo
  read -p "What Jira Project do you normally work on? " proj
  read -p "What do you want to prefix your branches with (usually first name) " prefix
  read -p "If your shortname in Jira is different than you email, what is it? (blank for same) " shortuser

  if [ -z $shortuser ] ; then
    short=email
  fi
  url=$(echo $url | sed 's/https:\/\///')

  config="${HOME}/dotfiles/.doNotCommit.jira"

  if ! grep -q '.doNotCommit.jira' ${HOME}/dotfiles/.doNotCommit ; then
    echo "source ${config}" >> ${HOME}/dotfiles/.doNotCommit
  fi

  if [ ! -f $config ] ; then
    touch $config
    ln -fs $config $HOME
  fi

  cat<<END > ${config}
export JIRA_API_TOKEN=${api_token}
export JIRA_S_ENDPOINT=${url}
export JIRA_S_PROJECT=${proj}
export JIRA_S_LOGIN=${email}
export JIRA_S_PREFIX=${prefix}
export JIRA_S_USER=${shortuser}
END

fi

