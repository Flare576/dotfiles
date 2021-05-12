#!/bin/bash
isLinux=0; [ -f "/etc/os-release" ] && isLinux=1

if [ "$1" == "delete" ]; then
  cd "$HOME"
  rm -rf .oh-my-zsh .z
  if [ "$isLinux" -eq "1" ] ; then
    chsh -s $(which bash)
    sudo sed -i "" -e "d/\/zsh" "/etc/shells"
  else
    sudo dscl . -create /Users/$USER UserShell $(which bash)
  fi
  return
fi

echo "Setting up Oh My Zshell, Tools, Themes, and Plugins for ZSH"

# Install and setup Oh My Zshell
curl -sL http://install.ohmyz.sh | bash &> /dev/null #the installer is pretty, tho! :(

# Configure theme management
touch "$HOME/dotfiles/.doNotCommit.d/.doNotCommit.theme"
cd "$HOME/.oh-my-zsh/themes"
themes="$HOME/dotfiles/themes"
# Theme configs are in yaml
command -v pip3 &> /dev/null && pip3 install --quiet pyaml

for theme in "$themes"/**/*.zsh-theme; do
  ln -sf "$theme"
done

# one more and should probably consider zplug...
cd "$HOME/.oh-my-zsh/custom/plugins/"

# NVM and Node Optimizations
git clone -q https://github.com/lukechilds/zsh-better-npm-completion
git clone -q https://github.com/lukechilds/zsh-nvm
# docker-aliases for... docker aliases
git clone -q https://github.com/webyneter/docker-aliases

# Sometimes Z doesn't setup its file
touch "$HOME/.z"

ln -fs "$HOME/dotfiles/.zshrc" "$HOME"

echo "Making Zsh default"
if [ "$isLinux" -eq "1" ] ; then
  # using sudo because most users can't (and shouldn't) direct-access /etc/shells
  which zsh | sudo tee -a /etc/shells
  chsh -s $(which zsh)
else
  sudo dscl . -create /Users/$USER UserShell /usr/local/bin/zsh
fi
