#!/bin/sh

brew install dockutil

toremove=(
  Safari
  Messages
  Mail
  Maps
  Photos
  FaceTime
  Calendar
  Contacts
  Reminders
  Notes
  Freeform
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

brew uninstall dockutil
