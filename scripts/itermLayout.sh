#!/bin/sh
# Ask first
read -p "Do you want to set up some iTerm fun? (Y/n) " doit
echo

if [[ $doit =~ ^[yY] ]] ; then
  echo "Atta kid"
  read -p "What is your current location called? " myname
  read -p "What is your current Zip code? " myzip
  read -p "What is your current Timezone (e.g., America/Chicago)? " mytz

  read -p "What is your remote location called? " remotename
  read -p "What is your remote location Timezone (e.g., America/Los_Angeles)? " remotetz

  config="${HOME}/dotfiles/.doNotcommit.locations"

  if ! grep -q '.doNotCommit.locations' ${HOME}/dotfiles/.doNotCommit ; then
    echo "source ${config}" >> ${HOME}/dotfiles/.doNotCommit
  fi

  if [ ! -f $config ] ; then
    touch $config
    ln -Fs $config $HOME
  fi
  cat<<END > ${config}
export MY_LOC_NAME=${myname}
export MY_LOC_ZIP=${myzip}
export MY_LOC_TZ=${mytz}
export REMOTE_LOC_NAME=${remotename}
export REMOTE_LOC_TZ=${remotetz}
END

fi
