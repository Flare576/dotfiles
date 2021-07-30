#!/bin/sh
# To get this data, run
# plist $HOME/Library/Preferences/com.apple.Terminal.plist
# then find the key starting with `<key>Sweetness</key>`
# Exporting the terminal from within Terminal also works if you do this
# https://apple.stackexchange.com/questions/99027/how-can-i-import-a-terminal-file-using-the-command-line

# Setting open Terminal windows information here:
# https://superuser.com/questions/187591/os-x-terminal-command-to-change-color-themes

# we're not going to bother uninstalling the theme entries right now
if [[ "$1" == "delete" ]]; then
  defaults write com.apple.Terminal "Startup Window Settings" "Basic"
  defaults write com.apple.Terminal "Default Window Settings" "Basic"
  exit
fi

for theme in $HOME/dotfiles/themes/**/*.terminal; do
  echo "WHAT $theme"
  [ -e "$theme" ] || continue
  config="$(dirname "$theme")/config.yml"
  themeName=$(yaml "$config" "['terminal']")
  bare=$(sed -n '/<dict>/,/<\/dict>/p' "$theme")
  echo "Importing $themeName Terminal Theme"
  defaults write com.apple.Terminal "Window Settings" -dict-add "$themeName" "$bare"
done

# Set new profile to startup
defaults write com.apple.Terminal "Startup Window Settings" "$themeName"
# Set new profile to default
defaults write com.apple.Terminal "Default Window Settings" "$themeName"
echo "You will need to restart Terminal; we edited its plist"
