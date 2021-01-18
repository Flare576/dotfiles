function switchTheme() {
  [[ "$1" == "light" ]] && mode="light" || mode="dark"

  pushd "$HOME/dotfiles/themes"
  # Universal parts [zsh, tmux, vim]
  ln -sf solarized-${mode}_zsh flare_zsh
  source flare_zsh

  ln -sf solarized-${mode}_tmux flare_tmux
  tmux source-file "$HOME/.tmux.conf" > /dev/null 2>&1

  ln -sf solarized-${mode}_vim flare_vim
  # I haven't found a way to update all vim sessions yet

  popd

  # Terminal emulators for different machines I use
  if command -v mintheme &> /dev/null ; then # WSL
    # https://github.com/mintty/utils/pull/2/files
    # patch submitted to mintheme; remove check when accepted (or declined)
    theme=$(mintheme --save solarized-${mode}.minttyrc | sed \
      -e '2!d' \
      -e 's/saved.\+''//')
    if [[ theme != *"tmux"* ]] ; then # declined
      echo $theme | sed -e 's/^/Ptmux;/'
    else # accepted
      echo $theme
    fi
  elif command -v defaults &> /dev/null ; then # OSX
    [[ $mode == "light" ]] && title="Solarized Light" || title="Solarized Dark"
    # Set new profile to startup
    defaults write com.apple.Terminal "Startup Window Settings" "$title"
    # Set new profile to default
    defaults write com.apple.Terminal "Default Window Settings" "$title"
    # Update active/existing windows
    osascript "$HOME/dotfiles/scripts/OSX/themeOpenTerminals.scpt" "$title"
  else # Chromebook
    # copy/paste desired theme over "current" theme (which should be "Flare")
    symId=":6d940353-9091-4d32-b491-95a661527d08/"
    light=":6c28978a-af78-434e-a97f-b5c252a080fd/"
    dark=":6439a867-f018-4fce-a077-dd0cd98ef13c/"
    basePath="/org/gnome/terminal/legacy/profiles:"
    [[ $mode == "light" ]] && profileid=$light || profileid=$dark
    updateTo=$(dconf dump $basePath/$profileid | sed -e "s/visible-name='.*'/visible-name='Flare'/")
    echo "$updateTo" | dconf load $basePath/$symId
  fi
}

