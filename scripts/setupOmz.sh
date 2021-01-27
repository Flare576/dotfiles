#!/bin/bash
isLinux=0; [ -f "/etc/os-release" ] && isLinux=1
echo "Setup Oh My Zshell"

# Install and setup Oh My Zshell
curl -sL http://install.ohmyz.sh | sh
cd "$HOME/.oh-my-zsh/themes"
themes="$HOME/dotfiles/themes"
for theme in "$themes"/**/*.zsh-theme; do
  ln -sf "$theme"
done

cd "$HOME/.oh-my-zsh/custom/plugins/"

# NVM and Node Optimizations
git clone https://github.com/lukechilds/zsh-better-npm-completion
git clone https://github.com/lukechilds/zsh-nvm

# Sometimes Z doesn't setup its file
touch "$HOME/.z"

ln -fs "$HOME/dotfiles/.zshrc" "$HOME"

echo "Making Zsh default"
if [ "$isLinux" -eq "1" ] ; then
  which zsh | sudo tee -a /etc/shells
  chsh -s $(which zsh)
else
  sudo dscl . -create /Users/$USER UserShell /usr/local/bin/zsh
fi
