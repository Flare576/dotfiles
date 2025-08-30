#!/bin/bash
source "$(dirname "$0")/../utils.sh"
usage="$(basename "$0") [-hvadu]
By default, uses local python3 to setup 'pydot' venv and links it to .doNotCommit structure.
If no Python3 instance, exits with error
With -a, installs pyenv/pipenv and uses pyenv to install python3.
- Pyenv is a set of scripts which manage active/available versions of Python
- Pipenv is a set of tools that manages project dependencies of Python projects
Options:
  -h Show this help
  -v Display version
  -a Installs pyenv, pipenv, and python3 with pyenv
  -d Uninstall Pyenv, Pipenv, and clear 'pydot' env
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
    m) echo "Ignoring -m, no minimal settings"
      ;;
    u) doUpdate="true"
      ;;
    *) echo "Unknown Option '$OPTARG', exiting"
      exit
      ;;
  esac
done
shift $((OPTIND -1))

if [ -z "$doAll" ] && ! command -v python3 &> /dev/null; then
  echo "No Python3 found" >&2;
  exit 1
fi
activator="$HOME/.doNotCommit.d/.doNotCommit.pydot"
v_env="$HOME/pydot"

if [ "$doDestroy" == "true" ]; then
  if command -v pyenv &> /dev/null ; then
    # TODO: manage removing pipenv files once I start using it
    rootdir="$(pyenv root)"
    echo "Removing $rootdir"
    rm -rf "$rootdir"
    if dotRemove pyenv "manual"; then
      echo "Unlinking pyenv"
      rm /usr/bin/pyenv
    fi
    dotRemove pipenv
  else
    echo "Deactivating and destroying virtual env and activator"
    deactivate
    rm -rf "$v_env"
    rm "$activator"
    exit
  fi
  exit
fi

if [ "$doUpdate" == "true" ] && ! command -v python3; then
  exit
fi

if [ "$doAll" == "true" ]; then
  if ! dotInstall pyenv "manual"; then
    if command -v apt-get &> /dev/null ; then
      echo "Installing Python build dependencies"
      sudo apt-get update -qq;
      sudo apt-get install -qqq make build-essential libssl-dev zlib1g-dev \
        libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
        libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
      echo "Installing latest version of pyenv"
      curl https://pyenv.run | bash &> /dev/null
    elif command -v pacman &> /dev/null ; then
      dotInstall "pyenv"
    else
      echo "Unsure how to install"
    fi
  fi
  if ! dotInstall pipenv "manual"; then
    if command -v apt-get &> /dev/null ; then
      dotInstall "pipenv"
    elif command -v pacman &> /dev/null ; then
      dotInstall "python-pipenv"
    else
      echo "Unsure how to install"
    fi
  fi

  echo "Install latest stable version of Python3"
  stable=$(pyenv install --list | grep -v '-' | grep -v 'b' | tr -d ' ' |  grep '^3' | tail -1)
  pyenv install "$stable"
  pyenv global "$stable"
else
  if [ "$doUpdate" == "true" ]; then
    pip install --upgrade pip
    exit
  fi
  # Setup a generic virtual env and add it to .doNotCommit structure
  if [ -d "$v_env" ]; then
    echo "$v_env already exists, skipping creation"
  else
    if command -v python &> /dev/null; then
      python -m venv "$v_env" || python3 -m venv "$v_env"
    elif command -v python3 &> /dev/null; then
      python3 -m venv "$v_env"
    else
      echo 'No Python Found; are you missing your snake?'
      exit
    fi
    ln -sf "$v_env/bin/activate" "$activator"
  fi
fi
