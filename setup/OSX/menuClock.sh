#!/bin/sh
# See https://www.tech-otaku.com/mac/setting-the-date-and-time-format-for-the-macos-menu-bar-clock-using-terminal/
# should be com.apple.menuextra.clock.plist,

defaults write com.apple.Terminal "Window Settings" -dict-add Sweetness \
  '<dict>
    <key>DateFormat</key>
    <string>EEE MMM d  h:mm a</string>
    <key>FlashDateSeparators</key>
    <false/>
    <key>IsAnalog</key>
    <false/>
  </dict>'
