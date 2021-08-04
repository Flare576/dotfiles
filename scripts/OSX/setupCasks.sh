#!/bin/bash
apps=(
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
)

echo "Installing Homebrew Casks"
brew install --cask ${apps[@]}

# Force setup of apps
open -a 1Password
read -p "Once you setup 1Password, press enter."
open -a Spotify
read -p "Once you setup Spotify, press enter."
