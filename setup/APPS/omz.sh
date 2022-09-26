#!/bin/bash
source "$(dirname "$0")/../utils.sh"
usage="$(basename "$0") [-hvd]
Links dotfile configs and installs or updates zsh, omz, and plugins by default.
ZSH is an alternative shell to bash that supports many more features, plugins, and other niceties.
OMZ (oh my zsh) is a customization framework for Zsh
Options:
  -h Show this help
  -v Display version
  -d Unlink files and Uninstall zsh/omz/plugins
"

while getopts ':hvadm' option; do
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

  if [ "$isLinux" -eq "true" ]; then
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

dotInstall zsh

echo "Setting up Oh My Zshell, Tools, Themes, and Plugins for ZSH"

# Install and setup Oh My Zshell (saving to tmp allows --unattended)
curl -o /tmp/omz-install.sh -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh &> /dev/null
bash /tmp/omz-install.sh --unattended &> /dev/null
rm /tmp/omz-install.sh &> /dev/null

echo "Installing Plugins"
mkdir -p "$HOME/.oh-my-zsh/custom/plugins/"
pushd "$HOME/.oh-my-zsh/custom/plugins/" &> /dev/null || exit

# NVM and Node Optimizations
cloneOrUpdateGit lukechilds/zsh-better-npm-completion
cloneOrUpdateGit lukechilds/zsh-nvm
cloneOrUpdateGit webyneter/docker-aliases

echo "Installing Cheat Completion"
zshComplete="$HOME/.oh-my-zsh/completions"
mkdir -p "$zshComplete"
rm -rf /tmp/cheat &> /dev/null
git clone -q https://github.com/cheat/cheat.git /tmp/cheat
mv /tmp/cheat/scripts/cheat.zsh "$zshComplete/_cheat.zsh"
rm -rf /tmp/cheat &> /dev/null
popd &> /dev/null || exit

# Sometimes Z doesn't setup its file
touch "$HOME/.z"

for link in "${linkable[@]}";
do
  echo "Linking $link"
  ln -fs "$HOME/dotfiles/$link" "$HOME/$link"
done

echo "Making Zsh default"
if [ "$isLinux" == "true" ] ; then
  # using sudo because most users can't (and shouldn't) direct-access /etc/shells
  which zsh | sudo tee -a /etc/shells
  chsh -s "$(which zsh)"
else
  # dscl is an OSX tool that updates the same underlying system as 'chsh' and OSX doesn't require updating /etc/shells
  sudo dscl . -create "/Users/$USER" UserShell "$(which zsh)"
fi
