#!/bin/bash
source "$(dirname "$0")/utils.sh"

usage="$(basename "$0") [-hvdu]
Sets up simlinks for tools/processes not explicitly handled in the APPS/* scripts.

- ~/.doNotCommit.d
- ~/.gitconfig.personal
- ~/.gitconfig
- ~/.gitignore
- ~/.config/lazydocker
- ~/.config/ctags

  -h Show this help
  -v Display version
  -d Uninstall
"
while getopts ':hvd' option; do
  case "$option" in
    h) echo "$usage"
      exit
      ;;
    v) echo "$VERSION"
      exit
      ;;
    d) doDestroy="true"
      ;;
    *) echo "Unknown Option '$option', exiting"
      exit
      ;;
  esac
done
shift $((OPTIND -1))

# Setup other symlinks
links=(
  .doNotCommit.d
  .gitconfig.personal
  .gitconfig
  .gitignore
# Link individual settings items; there will be ".config" files with secrets :/
  .config/lazydocker
  .config/ctags
  .config/kglobalshortcutsrc
  # Don't link this file - it has secrets
  # .config/git-clone/config
)

if [ "$doDestroy" == "true" ]; then
  echo "Removing symlinks"
  for link in "${links[@]}"; do
    if [ -f "$HOME/$link" ]; then
      rm -rf "$HOME/$link"
      if [ -e "$HOME/$link.bkp" ]; then
        echo "Restoring original file"
        mv "$HOME/$link.bkp" "$HOME/$link"
      fi
    fi
  done
  exit
fi

echo "Setting up symlnks and creating placeholder files"
mkdir -p "$HOME/.config" &> /dev/null
mkdir -p "$HOME/dotfiles/.doNotCommit.d" &> /dev/null

touch "$HOME/dotfiles/.gitconfig.personal"

for link in "${links[@]}"; do
  echo "Linking $link"

  # Check if the file already exists
  if [ -e "$HOME/$link" ]; then
    # If it's already a symbolic link, skip it
    if [ -L "$HOME/$link" ]; then
      echo "Skipping $link: already a symbolic link"
      continue
    fi

    # Merge if it is a file
    if [ -f "$HOME/$link" ]; then
      echo "Merging existing file $link"
      # Use diff3 to merge the files, creating a .orig file to mark conflicts
      diff3 -m "$HOME/dotfiles/$link" "$HOME/$link" "$HOME/dotfiles/$link" > "$HOME/$link.merged"

      # Check if diff3 introduced conflicts
      if grep -q "^<<<<<<<" "$HOME/$link.merged"; then
        echo "Conflicts detected during merge. Please resolve conflicts in $HOME/$link.merged"
        mv "$HOME/$link" "$HOME/$link.bkp"
        mv "$HOME/$link.merged" "$HOME/$link"

      else
        # If no conflicts, replace the dotfile with the merged content
        cat "$HOME/$link.merged" > "$HOME/dotfiles/$link"
        rm "$HOME/$link.merged"
        mv "$HOME/$link" "$HOME/$link.bkp"
      fi
    else
      # If it's not a regular file, back it up
      echo "Backing up existing non-regular file $HOME/$link"
      mv "$HOME/$link" "$HOME/$link.bkp"
    fi
  fi

  ln -fs "$HOME/dotfiles/$link" "$HOME/$link"
done

