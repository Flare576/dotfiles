#!/bin/bash
# 2025-09-06: Messing with default shell was probably never a great idea, but between all these variables, I'm taking it out:
# - Steam Deck (DO NOT SWITCH)
# - OSX (ZSH _is_ default)
# - Ubuntu VMs (just -it /bin/zsh)
source "$(dirname "$0")/../utils.sh"
usage="$(basename "$0") [-hmvdu]
Links dotfile configs and installs or updates zsh, omz, and plugins by default.
ZSH is an alternative shell to bash that supports many more features, plugins, and other niceties.
OMZ (oh my zsh) is a customization framework for Zsh
Options:
  -h Show this help
  -v Display version
  -d Unlink files and Uninstall zsh/omz/plugins
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
    m) echo "Ignoring -m, no all settings"
      ;;
    *) echo "Unknown Option '$OPTARG', exiting"
      exit
      ;;
  esac
done
shift $((OPTIND -1))

linkable=(
  .zshenv
  .zshrc
  .zshenv.kube
  .zshenv.aws
  .zshenv.rpg
  .zshenv.llm
)

plugins=(
  "lukechilds/zsh-better-npm-completion"
  "lukechilds/zsh-nvm"
  "webyneter/docker-aliases"
)


if [ "$doDestroy" == "true" ]; then
  echo "Removing zsh symlinks"
  for link in "${linkable[@]}";
  do
    unLink "$link"
  done

  echo "Removing omz and z"
  pushd "$HOME" &> /dev/null || exit
  rm -rf .oh-my-zsh .z .zcomp* &> /dev/null
  popd &> /dev/null || exit

  dotRemove zsh
  exit
fi


if [ "$doUpdate" == "true" ]; then
  # Since OMZ only loads on interactive shells, can't just check with command -v
  if ! zsh -ic "omz upgrade" &> /dev/null; then
    echo "omz upgrade failed"
    exit
  fi
else
  # Install and setup Oh My Zshell (saving to tmp allows --unattended)
  curl -o /tmp/omz-install.sh -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh &> /dev/null
  bash /tmp/omz-install.sh --unattended &> /dev/null
  rm /tmp/omz-install.sh &> /dev/null

  # Sometimes Z doesn't setup its file
  touch "$HOME/.z"
fi

dotInstall zsh

echo "Setting up Oh My Zshell, Tools, Themes, and Plugins for ZSH"

for link in "${linkable[@]}";
do
  linkToHome "$link"
done

echo "Installing Plugins"
mkdir -p "$HOME/.oh-my-zsh/custom/plugins/"

pushd "$HOME/.oh-my-zsh/custom/plugins/" &> /dev/null || exit
  for plugin in "${plugins[@]}";
  do
    cloneOrUpdateGit "$plugin"
  done
popd &> /dev/null || exit

echo "Installing Cheat Completion"
zshComplete="$HOME/.oh-my-zsh/completions"
mkdir -p "$zshComplete"
rm -rf /tmp/cheat &> /dev/null
git clone -q https://github.com/cheat/cheat.git /tmp/cheat
mv /tmp/cheat/scripts/cheat.zsh "$zshComplete/_cheat.zsh"
rm -rf /tmp/cheat &> /dev/null
