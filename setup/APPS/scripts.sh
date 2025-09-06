#!/bin/bash
source "$(dirname "$0")/../utils.sh"
usage="$(basename "$0") [-hvdu] [location]
Installs scripts I've written. Some are setup as homebrew formula, some are
collected in a generic project. If no path is provided, installs to ~/scripts
Options:
  -h Show this help
  -v Display version
  -d Deletes local repo and uninstalls scripts
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
    *) echo "Unknown Option '$OPTARG', exiting"
      exit
      ;;
  esac
done
shift $((OPTIND -1))

brews=(
  flare576/scripts/monitorjobs    # AWS-cli based job monitoring
  flare576/scripts/git-clone      # Manage multiple git accounts for cloning projects
  flare576/scripts/dvol           # manage Docker Volumes outside of project docker-compose files
  flare576/scripts/newScript      # facilitate creating new scripts in varius languages
  flare576/scripts/vroom          # wrapper for 'make' command to start/manage project execution
  flare576/scripts/switch-theme   # tool for changing tmux, vim, bat, zhs, etc. themes
)

config="$HOME/dotfiles/.doNotCommit.d/.doNotCommit.scripts"
INSTALL="$HOME/scripts"
if [ -n "$1" ]; then
  INSTALL="$1"
elif [ -n "$FLARE_SCRIPTS" ]; then
  INSTALL="$FLARE_SCRIPTS"
fi

if [ "$doDestroy" == "true" ]; then
  if test $(which brew); then
    for formula in "${brews[@]}"
    do
      dotRemove "$formula"
    done
  fi
  rm -rf "$FLARE_SCRIPTS"
  rm -rf "$config"
  exit
fi

if [ "$doUpdate" == "true" ] && ! [ -d "$INSTALL" ]; then
  exit
fi

echo "Cloning/Updating scripts in $INSTALL"
if [ ! -d "$INSTALL" ]; then
  git clone --recurse-submodules -q https://github.com/flare576/scripts.git $INSTALL
fi

pushd "$INSTALL" &> /dev/null || exit
git pull --recurse-submodules

echo "Ensuring $config is up-to-date"
cat<<END > ${config}
export FLARE_SCRIPTS="$INSTALL"
# fpath controls zsh auto-completion config locations
fpath=(\$FLARE_SCRIPTS/bin \$fpath)
export PATH="\$FLARE_SCRIPTS/bin:\${PATH}"
END

if command -v brew &> /dev/null ; then
  echo "Installing scripts"
  for formula in "${brews[@]}"
  do
    dotInstall "$formula"
  done
else
  echo 'export PATH="$FLARE_SCRIPTS/nonbrew:$PATH"' >> "$config"
fi

# Install NPM-based tools
# NVM / NPM are controlled via OMZ, so load ZSH
zsh -c "npm install -g git-gac"
