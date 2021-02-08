#!/bin/bash
isLinux=0; [ -f "/etc/os-release" ] && isLinux=1
echo "Setting up Oh My Zshell, Tools, Themes, and Plugins for ZSH"

# Install and setup Oh My Zshell
curl -sL http://install.ohmyz.sh | bash &> /dev/null #the installer is pretty, tho! :(
tc="$HOME/.doNotCommit.theme"

if ! grep -q "$tc" ${HOME}/dotfiles/.doNotCommit ; then
  echo "[ -f \"$tc\" ] && source \"$tc\"" >> "${HOME}/dotfiles/.doNotCommit"
fi
cd "$HOME/.oh-my-zsh/themes"
themes="$HOME/dotfiles/themes"
# Theme configs are in yaml
command -v pip3 &> /dev/null && pip3 install --quiet pyaml

for theme in "$themes"/**/*.zsh-theme; do
  ln -sf "$theme"
done

cd "$HOME/.oh-my-zsh/custom/plugins/"

# NVM and Node Optimizations
git clone -q https://github.com/lukechilds/zsh-better-npm-completion
git clone -q https://github.com/lukechilds/zsh-nvm

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
