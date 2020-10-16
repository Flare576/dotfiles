#!/bin/sh
# "Inspired" by https://apple.stackexchange.com/a/122573

# Probably a better way to do this...
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
  delay 0.5
  key code 36 --return
  delay 1.0
  keystroke tab
  delay 0.1

  --Open modifier keys submenu
  repeat 3 times
    keystroke tab using shift down
  end repeat
  keystroke space
  delay 0.1

  --Select top keyboard
  keystroke space
  repeat 3 times
    key code 126 --up arrow
  end repeat
  keystroke return

  --Go through up to 3 keyboards (top of loop assumes you just selected a keyboard)
  repeat 3 times
    delay 0.1

    --Select "Caps Lock" drop-down
    keystroke tab
    delay 0.5

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

    -- Select next keyboard

    keystroke tab using shift down
    keystroke space
    delay 0.1
    key code 125 --down arrow
    keystroke return
  end repeat


  --Commit changes! phew.
  keystroke return
end tell'
