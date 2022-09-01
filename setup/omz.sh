#!/bin/bash
isLinux=0; [ -f "/etc/os-release" ] && isLinux=1

linkable=(
  .zshenv
  .zshrc
  .zshrc.kubeHelper
  .zshrc.awsHelper
  .zshrc.rpg
)

if [[ "$1" == "delete" ]]; then
  echo "Removing zsh symlinks"
  for link in "${linkable[@]}";
  do
    rm -rf "$HOME/$link"
  done

  echo "Removing omz and z"
  pushd $HOME &> /dev/null
  rm -rf .oh-my-zsh .z .zcomp* &> /dev/null
  popd &> /dev/null

  if [ "$isLinux" -eq "1" ]; then
    echo "Reverting to bash, removing zsh from shells listing"
    chsh -s "$(which bash)"
    sudo sed -i"" -e "/\/zsh/d" "/etc/shells"
  else
    echo "Reverting to bash"
    sudo dscl . -create "/Users/$USER" UserShell "$(which bash)"
  fi

  if ! command -v brew &> /dev/null ; then
    echo "Uninstalling zsh"
    brew uninstall zsh
  fi
  exit
fi

echo "Installing latest version of zsh"
if command -v brew &> /dev/null ; then
  HOMEBREW_NO_INSTALL_UPGRADE=0 brew install zsh
else
  echo "Homebrew not found"
fi

echo "Setting up Oh My Zshell, Tools, Themes, and Plugins for ZSH"

# Install and setup Oh My Zshell (saving to tmp allows --unattended)
curl -o /tmp/omz-install.sh -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh &> /dev/null
bash /tmp/omz-install.sh --unattended &> /dev/null
rm /tmp/omz-install.sh &> /dev/null

echo "Installing Plugins"
mkdir -p "$HOME/.oh-my-zsh/custom/plugins/"
pushd "$HOME/.oh-my-zsh/custom/plugins/" &> /dev/null

# NVM and Node Optimizations
echo "Installing NPM Completion"
git clone -q https://github.com/lukechilds/zsh-better-npm-completion
echo "Installing NVM Completion"
git clone -q https://github.com/lukechilds/zsh-nvm
echo "Installing Docker Aliases"
git clone -q https://github.com/webyneter/docker-aliases

echo "Installing Cheat Completion"
zshComplete=$HOME/.oh-my-zsh/completions
mkdir -p $zshComplete
rm -rf /tmp/cheat &> /dev/null
git clone -q https://github.com/cheat/cheat.git /tmp/cheat
mv /tmp/cheat/scripts/cheat.zsh $zshComplete/_cheat.zsh
rm -rf /tmp/cheat &> /dev/null
popd &> /dev/null

# Sometimes Z doesn't setup its file
touch "$HOME/.z"

for link in "${linkable[@]}";
do
  echo "Linking $link"
  ln -fs "$HOME/dotfiles/$link" "$HOME/$link"
done

echo "Making Zsh default"
if [ "$isLinux" -eq "1" ] ; then
  # using sudo because most users can't (and shouldn't) direct-access /etc/shells
  which zsh | sudo tee -a /etc/shells
  chsh -s "$(which zsh)"
else
  # dscl is an OSX tool that updates the same underlying system as 'chsh' and OSX doesn't require updating /etc/shells
  sudo dscl . -create /Users/$USER UserShell "$(which zsh)"
fi
