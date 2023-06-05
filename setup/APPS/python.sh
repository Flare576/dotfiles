#!/bin/bash
source "$(dirname "$0")/../utils.sh"
usage="$(basename "$0") [-hvdtu]
By default, installs python3. With -t, installs pyenv/pipenv and uses pyenv to install python3.
Pyenv is a set of scripts which manage active/available versions of Python
Pipenv is a set of tools that manages project dependencies of Python projects
Options:
  -h Show this help
  -v Display version
  -a Installs pyenv, pipenv, and python3 with pyenv
  -d Uninstall Pyenv, Pipenv, and probably your local python install
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
    a) doAll="true"
      ;;
    u) doUpdate="true"
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
  # TODO: manage removing pipenv files once I start using it
  if command -v pyenv &> /dev/null ; then
    rootdir="$(pyenv root)"
    echo "Removing $rootdir"
    rm -rf "$rootdir"
    if dotRemove pyenv "manual"; then
      echo "Unlinking pyenv"
      rm /usr/bin/pyenv
    fi
    dotRemove pipenv
  else
    dotRemove python3
  fi
  exit
fi

if [ "$doUpdate" == "true" ] && ! command -v python3; then
  exit
fi

if [ "$doAll" == "true" ]; then
  if ! dotInstall pyenv "manual"; then
    echo "Installing Python build dependencies"
    sudo apt-get update -qq;
    sudo apt-get install -qqq make build-essential libssl-dev zlib1g-dev \
      libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
      libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
    echo "Installing latest version of pyenv"
    curl https://pyenv.run | bash &> /dev/null
  fi
  dotInstall pipenv

  echo "Install latest stable version of Python3"
  stable=$(pyenv install --list | grep -v '-' | grep -v 'b' | tr -d ' ' |  grep '^3' | tail -1)
  pyenv install "$stable"
  pyenv global "$stable"
else
  dotInstall python3
fi
