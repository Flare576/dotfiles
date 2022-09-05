#!/bin/bash

# Note: This is designed to install the GNOME Terminal Emulator on Chrome OS, not to theme or otherwise customize it
# Use https://github.com/flare576/switch-theme for that!

sudo apt-get install gnome-terminal

launcherFile="/usr/share/applications/GnomeTerminal.desktop"

cat << EOF > $launcherFile
[Desktop Entry]
Name=Gnome Terminal
#GenericName=Terminal
Comment=Gnome Terminal for ChromeOS
Exec=/usr/bin/gnome-terminal
Terminal=false
Type=Application
#Encoding=UTF-8
Icon=/usr/share/icons/Adwaita/scalable/apps/utilities-terminal-symbolic.svg
Categories=System;TerminalEmulator;Utility;
Keywords=shell;prompt;command;commandline;cmd;
EOF
