#!/bin/bash
# https://github.com/ggreer/the_silver_searcher
source "$(dirname "$0")/../utils.sh"

usage="$(basename "$0") [-hvdu]
Installs or upgrades 'ag', The Silver Searcher
ag is a very fast code searching tool.
  -h Show this help
  -v Display version
  -d Uninstall
  -u Update if installed
"
while getopts ':hvadmu' option; do
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
    a) echo "Ignoring -a, no all settings"
      ;;
    m) echo "Ignoring -m, no minimal settings"
      ;;
    *) echo "Unknown Option '$OPTARG', exiting"
      exit
      ;;
  esac
done
shift $((OPTIND -1))

brewName="the_silver_searcher"
linuxName="the_silver_searcher"
# Ubuntu's apt system calls it "silversearcher-ag"
if command -v apt-get &> /dev/null ; then
  linuxName="silversearcher-ag"
fi


if [ "$doDestroy" == "true" ]; then
  dotRemove "$brewName" "$linuxName"
  exit
fi

if [ "$doUpdate" == "true" ] && ! command -v ag; then
  exit
fi

dotInstall "$brewName" "$linuxName"
