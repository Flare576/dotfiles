#!/bin/bash
casks=(
  1password          # Password Manager!
  1password-cli      # Still Password Manger... ON CLI!
  boop               # Small app to let you do quick text/json/etc. tweeks
  firefox            # I mean, why not!
  google-chrome      # Like you don't know!
  docker             # Seriously, it's Docker
  launchbar          # Spotlight.... only not crap!
  postman            # Wait a minute mr..... API manager!
  slack              # An alternative to Microsoft Teams ;)
  spotify            # Please your earballs!
  trailer            # Manage Github projects from Notification area!
  vlc                # For those rare times you need to watch something locally!
  visual-studio-code # For when you need an IDE
  zoom               # You know you're going to need it
)

code_exts=(
  alexcvzz.vscode-sqlite
  ckolkman.vscode-postgres
  jebbs.plantuml
  vscodevim.vim
)

echo "Installing Homebrew Casks"
for cask in "${casks[@]}"
do
  echo "Working on $cask"
  brew install --cask "$cask"
done

echo "Install VS Code Extensions"
for extension in "${code_exts[@]}"
do
  echo "Working on $extension"
  code --install-extension "$extension"
done
filename="$HOME/Library/Application Support/Code/User/settings.json"
# Read existing content or provide an empty JSON object if the file doesn't exist.
# Then update the 'workbench.colorTheme' using jq and write back atomically.
# The '2>/dev/null' suppresses potential error messages from 'cat' if the file is not found initially.
( [ -f "$filename" ] && cat "$filename" 2>/dev/null || echo "{}" ) | \
jq --arg theme "$code_theme" '.{"vim.vimrc.enable": true,"vim.vimrc.path":"~/.vimrc"}' > "$filename.tmp" && \
mv "$filename.tmp" "$filename"

# Force setup of apps
open -a "1Password"
read -p "Once you setup 1Password, press enter."
open -a Firefox
read -p "Once you setup Firefox, press enter."
open -a Spotify
read -p "Once you setup Spotify, press enter."
open -a Slack
read -p "Once you setup Slack, press enter."
open -a LaunchBar
read -p "Once you setup LaunchBar, press enter."

