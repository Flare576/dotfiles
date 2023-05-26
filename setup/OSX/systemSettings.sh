#!/bin/bash
source "$(dirname "$0")/../utils.sh"

usage="$(basename "$0") [-hvdu]
By default, makes several changes to system settings. With -d, resets to 'original' settings.

 - Move dock from bottom to left
 - Adds hot-corner screen saver to bottom left
 - Enables showing hidden folders in Finder
 - Shows all files in Finder
 - Disable 'Swipe to scroll'
 - Enable 'Tap to click'
 - Enable showing battery percent in staus bar (broken)
 - Allow tabbing in dialog boxes
 - Set hold-to-repeat time for keys from 25 to 15
 - Set repeat rate from 6 to 1
 - Disable Smart-Quotes
 - Set show-scrollbars from 'Automatic' to 'WhenScrolling'
 - Display sound icon in status bar by default

  -h Show this help
  -v Display version
  -d Revert changes
"
while getopts ':hvdu' option; do
  case "$option" in
    h) echo "$usage"
      exit
      ;;
    v) echo "$VERSION"
      exit
      ;;
    d) doDestroy="true"
      ;;
    u) doUpdate="true"
      ;;
    *) echo "Unknown Option '$option', exiting"
      exit
      ;;
  esac
done
shift $((OPTIND -1))

dockside="left"
autoHide="true"
hotCornerAction=5
showHiddenFolder=1
showAllFiles="YES"
swipeScroll="NO"
tapToClick="true"
showPercent="YES"
dialogTab="3"
initialRepeat=15
keyRepeat=1
smartQuotes='false'
scrollbars='WhenScrolling'
showSound="true"
if [ "$doDestroy" == "true" ]; then
  dockside="bottom"
  autoHide="false"
  hotCornerAction=0
  showHiddenFolder=0
  showAllFiles="NO"
  swipeScroll="YES"
  tapToClick="false"
  showPercent="NO"
  dialogTab="0"
  initialRepeat=25
  keyRepeat=6
  smartQuotes='true'
  scrollbars='Automatic'
  showShound="false"
fi
echo "Configuring Dock and System settings"

# Put dock on left side of screen
defaults write com.apple.dock orientation "$dockside"
# Auto-hide
osascript -e 'tell application "System Events" to set the autohide of the dock preferences to true'
# Screen-saver/lock hot corner lower left
defaults write com.apple.dock "wvous-bl-corner" -int $hotCornerAction
# Shrink dock
# defaults write com.apple.dock tilesize -integer 40
# Dock magnification
# defaults write com.apple.dock magnification -bool true
# Icon size of magnified Dock items
# defaults write com.apple.dock largesize -int 64

# Show hidden files in finder and folders to top
defaults write com.apple.finder _FXSortFoldersFirst $showHiddenFolder
defaults write com.apple.finder AppleShowAllFiles $showAllFiles

# Fix scroll direction
defaults write -g com.apple.swipescrolldirection -bool $swipeScroll
# Only show scrollbars when srolling (or Terminal's dimensions are wrong)
defaults write NSGlobalDomain AppleShowScrollBars -string "$scrollbars"
# Tap to click
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool $tapToClick
# Enable battery icon in menu bar
defaults write com.apple.menuextra.battery ShowPercent $showPercent
# Tab through controls of dialog boxes
defaults write NSGlobalDomain AppleKeyboardUIMode -int $dialogTab
# make repeating keys fast
defaults write -g InitialKeyRepeat -int $initialRepeat # normal minimum is 15 (225 ms)
defaults write -g KeyRepeat -int $keyRepeat # normal minimum is 2 (30 ms)
# Show sound on menu bar at all times
defaults write -g com.apple.controlcenter "NSStatusItem Visible Sound" -bool $showSound

# Disable SmartQuotes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool $smartQuotes

bash $HOME/dotfiles/setup/OSX/reassignCapsLock.sh $1
bash $HOME/dotfiles/setup/OSX/menuClock.sh $1

killall Finder
killall Dock
killall SystemUIServer
