#!/bin/bash
# Used this to setup chromebook:
# https://kmyers.me/blog/chromeos/is-your-chromeos-linux-terminal-broken-why-not-replace-it-with-gnome-terminal/
# The Gnome Terminal emulator uses `dconf` command to control its behavior.  On a
# Chromebook, the file holding the "Database" is $HOME/.config/dconf/user
# This script profiles from themes, appends them to the `list` which controls the
# Preference UI's list, and sets the default key to use "Flare". Flare is set
# to the last theme loaded

profilesPath="/org/gnome/terminal/legacy/profiles:/"

# We'll need to update the UI list with any new values we add; don't mess up what's there
existing=$(dconf read ${profilesPath}list)
if [[ -n "$existing" ]] ; then
  existing=${existing:1:${#existing}-2} # strip 1st/last character
fi

# Uses globstar
themeFiles="$HOME/dotfiles/themes"/**/*.gnome
for theme in $themeFiles; do
  [ -e "$theme" ] || continue
  config=$(echo $theme | sed 's/\(.*\)\/.*.gnome/\1\/config')
  themeName=$(yaml "$config" "['name']")
  id=$(yaml "$config" "['gnome']")

  echo "Importing $themeName Gnome Theme"
  dconf load "$profilesPath" < "$theme"

  # if new, add to UI list
  if [[ "$existing" != *"$id"* ]] ; then
    [[ $existing == "" ]] || existing="$existing, "
    existing="$existing'$id'"
  fi
done

# Add dummy profile to overwrite on SetTheme
dummyId="6d940353-9091-4d32-b491-95a661527d08"
echo $theme | sed
  -e "1 s/^.*$/[:$dummyId]"
  -e "2 s/=.*$/='Flare'"
| dconf load "$profilesPath"

# if new, add to UI list
if [[ "$existing" != *"$dummyId"* ]] ; then
  existing="$existing, '$dummyId'"
fi

# set default to dummy
dconf write /org/gnome/terminal/legacy/profiles:/default "'$dummyId'"

# Update List
dconf write "${profilesPath}list" "[$existing]"
