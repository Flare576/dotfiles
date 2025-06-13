#!/bin/bash
source "$(dirname "$0")/../utils.sh"
usage="$(basename "$0") [-hmvdu]
Links dotfile configs and installs or updates zsh, omz, and plugins by default.
ZSH is an alternative shell to bash that supports many more features, plugins, and other niceties.
OMZ (oh my zsh) is a customization framework for Zsh
Options:
  -h Show this help
  -m Minimal install, skips setting default shell
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
    m) minimal="true"
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
  .zshrc.kubeHelper
  .zshrc.awsHelper
  .zshrc.rpg
)

if [ "$doDestroy" == "true" ]; then
  echo "Removing zsh symlinks"
  for link in "${linkable[@]}";
  do
    rm -rf "$HOME/${link:?}"
  done

  echo "Removing omz and z"
  pushd "$HOME" &> /dev/null || exit
  rm -rf .oh-my-zsh .z .zcomp* &> /dev/null
  popd &> /dev/null || exit

  if [ "$isLinux" == "true" ]; then
    echo "Reverting to bash, removing zsh from shells listing"
    chsh -s "$(which bash)"
    sudo sed -i"" -e "/\/zsh/d" "/etc/shells"
  else
    echo "Reverting to bash"
    sudo dscl . -create "/Users/$USER" UserShell "$(which bash)"
  fi

  dotRemove zsh
  exit
fi

if [ "$doUpdate" == "true" ] && ! command -v omz; then
  exit
fi

dotInstall zsh

echo "Setting up Oh My Zshell, Tools, Themes, and Plugins for ZSH"

# Install and setup Oh My Zshell (saving to tmp allows --unattended)
curl -o /tmp/omz-install.sh -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh &> /dev/null
bash /tmp/omz-install.sh --unattended &> /dev/null
rm /tmp/omz-install.sh &> /dev/null

echo "Installing Plugins"
mkdir -p "$HOME/.oh-my-zsh/custom/plugins/"

# NVM and Node Optimizations
pushd "$HOME/.oh-my-zsh/custom/plugins/" &> /dev/null || exit
cloneOrUpdateGit lukechilds/zsh-better-npm-completion
cloneOrUpdateGit lukechilds/zsh-nvm
cloneOrUpdateGit webyneter/docker-aliases
popd &> /dev/null || exit

echo "Installing Cheat Completion"
zshComplete="$HOME/.oh-my-zsh/completions"
mkdir -p "$zshComplete"
rm -rf /tmp/cheat &> /dev/null
git clone -q https://github.com/cheat/cheat.git /tmp/cheat
mv /tmp/cheat/scripts/cheat.zsh "$zshComplete/_cheat.zsh"
rm -rf /tmp/cheat &> /dev/null

# Sometimes Z doesn't setup its file
touch "$HOME/.z"

for link in "${linkable[@]}";
do
  echo "Linking $link"
  ln -fs "$HOME/dotfiles/$link" "$HOME/$link"
done

# if "doUpdate" is true, or "minimal" is true, DON'T make zsh default
if [ -z "$doUpdate" ] && [ -z "$minimal" ]; then
  echo "Making Zsh default"
  loc="$(which zsh)"
  if [ "$isLinux" == "true" ] ; then
    if grep -vq "$loc" /etc/shells; then
      # using sudo because most users can't (and shouldn't) direct-access /etc/shells
      echo "$loc" | sudo tee -a /etc/shells
    fi
    chsh -s "$loc"
  else
    # dscl is an OSX tool that updates the same underlying system as 'chsh' and OSX doesn't require updating /etc/shells
    sudo dscl . -create "/Users/$USER" UserShell "$loc"
  fi
fi
