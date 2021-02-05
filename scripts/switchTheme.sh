function switchTheme() {
  hasRun="false"
  # get known aliases
  configRoot="$HOME/dotfiles/themes"
  for config in "$configRoot"/**/config.yml; do
    [ -e "$config" ] || continue
    checkFor=( $(yaml "$config" "['alias']" | sed "s/[][',]//g") )
    [[ " ${checkFor[@]} " =~ " $1 " ]] || continue
    if [ $hasRun = "true" ] ; then
      echo "There as a duplicate alias; using first found"
      return 1
    fi
    hasRun="true"
    name="$(yaml "$config" "['name']")"
    themeExport="$HOME/.doNotCommit.theme"
    cat << EOF > $themeExport
export FLARE_THEME="$name"
export FLARE_VIM_THEME="$(yaml "$config" "['vim']")"
export FLARE_TMUX_THEME="$(yaml "$config" "['tmux']")"
export FLARE_ZSH_THEME="$(yaml "$config" "['zsh']")"
export BAT_THEME="$(yaml "$config" "['bat']")"
EOF
    source "$themeExport"

    # refresh current zsh and tmux
    source "$HOME/dotfiles/themes/$name/$FLARE_ZSH_THEME.zsh-theme"
    command -v tmux &> /dev/null && tmux source-file "$HOME/dotfiles/themes/$FLARE_THEME/$FLARE_TMUX_THEME" &> /dev/null
    # vim and zsh are configured to watch for changes on updates

    # Terminal emulators for different machines I use
    if command -v mintheme &> /dev/null ; then # WSL
      # https://github.com/mintty/utils/pull/2/files
      # patch submitted to mintheme; remove check when accepted (or declined)
      minttyTheme="$(yaml "$config" "['mintty']")"
      theme=$(mintheme --save $name/$minttyTheme | sed \
        -e '2!d' \
        -e 's/saved.\+''//')
      if [[ theme != *"tmux"* ]] ; then # declined
        echo $theme | sed -e 's/^/Ptmux;/'
      else # accepted
        echo $theme
      fi
    elif command -v defaults &> /dev/null ; then # OSX
      title="$(yaml "$config" "['terminal']")"
      defaults write com.apple.Terminal "Startup Window Settings" "$title"    # Set new profile to startup
      defaults write com.apple.Terminal "Default Window Settings" "$title"    # Set new profile to default
      osascript "$HOME/dotfiles/scripts/OSX/themeOpenTerminals.scpt" "$title" # Update active/existing windows
    elif command -v dconf &> /dev/null ; then  # Chromebook
      # copy/paste desired theme over "current" theme (which should be "Flare")
      symId=":6d940353-9091-4d32-b491-95a661527d08/"
      basePath="/org/gnome/terminal/legacy/profiles:"
      gnomeId="$(yaml "$config" "['gnome']")"
      updateTo=$(dconf dump "$basePath/$gnomeId" | sed -e "s/visible-name='.*'/visible-name='Flare'/")
      echo "$updateTo" | dconf load $basePath/$symId
    fi # else we're probably not running a terminal emulator on this machine
  done
}
