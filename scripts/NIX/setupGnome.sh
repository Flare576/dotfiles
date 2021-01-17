#!/bin/bash
# the Gnome Terminal editor uses `dconf` command to control its behavior.
# On a Chromebook, the file holding the "Database" is
# $HOME/.config/dconf/user
# This script adds 4 profiles, adds them to the `list`
# which controls the Preference UI's list, and sets the
# default key to use "Flare". Flare is defaulted to "dark"
# Solarized, and `switchTheme` will replace those values
# when switched

profilesPath="/org/gnome/terminal/legacy/profiles:/"
solarizedBase="use-theme-colors=false
palette=['rgb(7,54,66)', 'rgb(220,50,47)', 'rgb(133,153,0)', 'rgb(181,137,0)', 'rgb(38,139,210)', 'rgb(211,54,130)', 'rgb(42,161,152)', 'rgb(238,232,213)', 'rgb(0,43,54)', 'rgb(203,75,22)', 'rgb(88,110,117)', 'rgb(101,123,131)', 'rgb(131,148,150)', 'rgb(108,113,196)', 'rgb(147,161,161)', 'rgb(253,246,227)']
use-system-font=false
font='JetBrains Mono Medium 14"

# Add Solarized Light
echo "[:6c28978a-af78-434e-a97f-b5c252a080fd]
visible-name='Solarized Light'
foreground-color='rgb(101,123,131)'
background-color='rgb(253,246,227)'
$solarizedBase" | dconf load "$profilesPath"

# Add Solarized Dark
echo "[:6439a867-f018-4fce-a077-dd0cd98ef13c]
visible-name='Solarized Dark'
background-color='rgb(0,43,54)'
foreground-color='rgb(131,148,150)'
$solarizedBase" | dconf load "$profilesPath"

# Add "Symlink" profile, default to dark
symId="6d940353-9091-4d32-b491-95a661527d08"
echo "[:$symId]
visible-name='Flare'
background-color='rgb(0,43,54)'
foreground-color='rgb(131,148,150)'
$solarizedBase" | dconf load "$profilesPath"

# Add backup profile
echo "[:b1dcc9dd-5262-4d8d-a863-c897e6d979b9]
use-system-font=false
visible-name='Sweetness'
font='JetBrains Mono Regular 14'" | dconf load "$profilesPath"

# set default to symlink
dconf write /org/gnome/terminal/legacy/profiles:/default "'$symId'"

# Update List
existing=$(dconf read ${profilesPath}list)
if [[ -n "$existing" ]] ; then
  existing=${existing:1:${#existing}-2}
fi

newIds=(
"6c28978a-af78-434e-a97f-b5c252a080fd"
"6439a867-f018-4fce-a077-dd0cd98ef13c"
"b1dcc9dd-5262-4d8d-a863-c897e6d979b9"
"6d940353-9091-4d32-b491-95a661527d08"
)

for id in ${newIds[@]};
do
  if [[ "$existing" != *"$id"* ]] ; then
    [[ $existing == "" ]] || existing="$existing, "
    existing="$existing'$id'"
  fi
done

dconf write "${profilesPath}list" "[$existing]"
