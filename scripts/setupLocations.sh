#!/bin/sh

# Ask first
read -p "Setup location information (for wdate and wweather)? (Y/n) " doit
echo

if [[ $doit =~ ^[yY] ]] ; then
  echo "Atta kid"
  read -p "What is your current location called? " myname
  read -p "What is your current Zip code? " myzip
  read -p "What is your current Timezone (See /usr/share/zoneinfo)? " mytz

  read -p "What is your remote location called? " remotename
  read -p "What is your remote location Timezone (See /usr/share/zoneinfo)? " remotetz

  config="${HOME}/dotfiles/.doNotCommit.d/.doNotCommit.locations"

  cat<<END > ${config}
export MY_LOC_NAME=${myname}
export MY_LOC_ZIP=${myzip}
export MY_LOC_TZ=${mytz}
export REMOTE_LOC_NAME=${remotename}
export REMOTE_LOC_TZ=${remotetz}
END

npm install -g vtop
fi
