# This file defines some common functions used throughout the setup scripts and defines the global version of the scripts
VERSION=2.0.0
isLinux=0; [ -f "/etc/os-release" ] && isLinux="true"

function cloneOrUpdateGit() {
  project="${1#*/}"
  folder="${2-$project}"
  if [ -d "$folder" ]; then
    echo "Updating $project"
    pushd "$folder" &> /dev/null || exit
    git pull
    popd &> /dev/null || exit
  else
    echo "Cloning $project"
    git clone -q "https://github.com/$1" "$folder"
  fi
}

function dotRemove() {
  brewPackage="$1"
  [ -n "$2" ] && linuxPackage="$2" || linuxPackage="$brewPackage"

  if command -v brew &> /dev/null ; then
    echo "Uninstalling $brewPackage"
    brew uninstall "$brewPackage"
  elif command -v apt-get &> /dev/null ; then
    [ "$linuxPackage" == "manual" ] && return 1
    echo "Uninstalling $linuxPackage"
    apt-get remove -qqq "$linuxPackage"
  else
    echo "Unsure how to uninstall"
  fi
}

function dotInstall() {
  brewPackage="$1"
  [ -n "$2" ] && linuxPackage="$2" || linuxPackage="$brewPackage"

  if command -v brew &> /dev/null ; then
    echo "Installing latest version of $brewPackage"
    HOMEBREW_NO_INSTALL_UPGRADE=0 brew install "$brewPackage"
  elif command -v apt-get &> /dev/null ; then
    [ "$linuxPackage" == "manual" ] && return 1
    echo "Installing latest version of $linuxPackage"
    apt-get update -qq;
    apt-get install -qqq --no-install-recommends "$linuxPackage"
  else
    echo "Unsure how to install"
  fi
}

# requires `jq` to be available
function latestGit() {
  repository="$1" # should be user/project formatted
  filter="$2" # artifact to look for
  echo "$(curl --silent "https://api.github.com/repos/$repository/releases/latest" | jq -r '.assets[].browser_download_url' | grep "$filter")"
}
