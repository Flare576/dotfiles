#!/bin/zsh
# right now the script uses a `yaml` function located in my zsh profile, so it needs zsh
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
  config="$(dirname "$theme")/config.yml"
  [ -e "$config" ] || continue
  themeName=$(yaml "$config" "['terminal']")
  bare=$(sed -n '/<dict>/,/<\/dict>/p' "$theme")
  echo "Importing $themeName Terminal Theme"
  defaults write com.apple.Terminal "Window Settings" -dict-add "$themeName" "$bare"
done

# Set new profile to startup
defaults write com.apple.Terminal "Startup Window Settings" "$themeName"
# Set new profile to default
defaults write com.apple.Terminal "Default Window Settings" "$themeName"
divider="[41m[30m*[32m*[33m*[34m*[35m*[36m*[37m*[38m*[90m*[91m*[92m*[93m*[94m*[95m*[30m*[32m*[33m*[34m*[35m*[36m*[37m*[38m*[90m*[91m*[92m*[93m*[94m*[95m*[41m[30m*[32m*[33m*[34m*[35m*[0m"
printf "\n${divider}\n[31mYOU WILL NEED TO RESTART TERMINAL[0m\nWe edited its plist\n${divider}\n"
