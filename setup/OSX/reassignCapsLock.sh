#!/bin/bash
# "Inspired" by https://apple.stackexchange.com/a/122573

if [[ "$1" == "delete" ]]; then
  exit
fi

echo "Attempting to use UI to set caps lock action..."

function update_settings () {
  osascript -e '
--reboot system preferences to make GUI state more predictable
tell application "System Preferences"
  quit
  delay 1
  activate
  delay 1
  activate
end tell

tell application "System Events"
  --Bring up keyboard prefs
  key code 53 --escape
  keystroke "f" using command down
  delay 0.5
  key code 53 --escape
  keystroke "keyboard"
  delay 1.0
  key code 36 --return
  delay 2.0
  keystroke tab
  delay 0.5

  --Open modifier keys submenu
  repeat 3 times
    keystroke tab using shift down
    delay 0.5
  end repeat
  keystroke space
  delay 0.1

  --Open drop-down and go to top
  keystroke space
  delay 0.1
  repeat 4 times
    key code 126 --up arrow
  end repeat

  --Select "Option" option
  repeat 2 times
    key code 125 --down arrow
  end repeat
  delay 0.1

  keystroke return
  delay 0.1

  --Commit changes! phew.
  keystroke return
end tell'
}

read -p "Ensure no external keyboards are connected - Handle them separately."
update_settings
read -p "If there was an error, open System Preferences - Security & Privacy -> Privacy -> Accessibility and add Terminal"
update_settings
