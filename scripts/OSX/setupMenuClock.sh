#!/bin/sh

defaults write com.apple.Terminal "Window Settings" -dict-add Sweetness \
  '<dict>
    <key>DateFormat</key>
    <string>EEE MMM d  h:mm a</string>
    <key>FlashDateSeparators</key>
    <false/>
    <key>IsAnalog</key>
    <false/>
  </dict>'
