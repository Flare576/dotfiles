#!/bin/bash
if [ "$1" == "delete" ]; then
  # could also read the .doNotCommit file, but good for a start
  rm -rf "$FLARE_SCRIPTS"
fi

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
export PATH="\$FLARE_SCRIPTS/shell:\$FLARE_SCRIPTS/js:\$FLARE_SCRIPTS/python:\${PATH}"
END
fi
