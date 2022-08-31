#!/bin/sh
DLURL=$(curl --silent "https://api.github.com/repos/kcrawford/dockutil/releases/latest" | jq -r '.assets[].browser_download_url' | grep pkg)
curl -sL ${DLURL} -o /tmp/dockutil.pkg
sudo installer -pkg "/tmp/dockutil.pkg" -target /
rm /tmp/dockutil.pkg

toremove=(
  Safari
  Messages
  Maps
  Photos
  FaceTime
  Contacts
  Reminders
  Notes
  TV
  Music
  Podcasts
  News
  "App Store"
  "System Preferences"
)

for crapapp in "${toremove[@]}"; do
  dockutil --remove "$crapapp" &> /dev/null
done

sudo rm /usr/local/bin/dockutil
