#!/bin/sh
echo "Configuring Dock and System settings"

# Put dock on left side of screen
defaults write com.apple.dock orientation left
# Auto-hide
osascript -e 'tell application "System Events" to set the autohide of the dock preferences to true'
# Screen-saver/lock hot corner lower left
defaults write com.apple.dock "wvous-bl-corner" -int 5
# Shrink dock
# defaults write com.apple.dock tilesize -integer 40
# Dock magnification
# defaults write com.apple.dock magnification -bool true
# Icon size of magnified Dock items
# defaults write com.apple.dock largesize -int 64

# Show hidden files in finder and folders to top
defaults write com.apple.finder _FXSortFoldersFirst 1
defaults write com.apple.finder AppleShowAllFiles YES

# Fix scroll direction
defaults write -g com.apple.swipescrolldirection -bool NO
# Tap to click
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
# Enable battery icon in menu bar
defaults write com.apple.menuextra.battery ShowPercent YES
# Tab through controls of dialog boxes
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
# make repeating keys fast
defaults write -g InitialKeyRepeat -int 15 # normal minimum is 15 (225 ms)
defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)

# Disable SmartQuotes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

killall Finder
killall Dock
killall SystemUIServer

sh $HOME/dotfiles/scripts/reassignCapsLock.sh
