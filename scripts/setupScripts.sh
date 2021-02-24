#!/bin/bash
[ -z "$1" ] && read -p "Enter Dir for Flare Scripts ($HOME/scripts) or 'skip' to skip: " dest
echo

if [[ -z "$dest" ]] ; then
  dest=$HOME/scripts
fi

if [[ "$dest" != "skip" ]] ; then
  git clone -q https://github.com/flare576/scripts.git $dest
  sed -i'' -e 's/https:\/\/github.com\//git@github.com:/' $dest/.git/config

  config="${HOME}/dotfiles/.doNotCommit.d/.doNotCommit.scripts"
  cat<<END >> ${config}
export FLARE_SCRIPTS="$dest"
fpath=(\$FLARE_SCRIPTS/shell \$fpath)
export PATH="\$FLARE_SCRIPTS/shell:\$FLARE_SCRIPTS/js:\${PATH}"
END
fi
