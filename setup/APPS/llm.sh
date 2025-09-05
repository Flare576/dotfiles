#!/bin/bash
source "$(dirname "$0")/../utils.sh"
usage="$(basename "$0") [-hmvdu]
If installing on Linux, install after python.sh.
Installs 'llm' CLI tool, llm-gemini plugin, and sets envars.
Options:
  -h Show this help
  -m Minimal install, only install llm
  -v Display version
  -d Uninstall llm, plugins, and delete .doNotCommit.llm
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
    m) minimal="true"
      ;;
    *) echo "Unknown Option '$OPTARG', exiting"
      exit
      ;;
  esac
done
shift $((OPTIND -1))

config="$HOME/.doNotCommit.d/.doNotCommit.llm"

if [ "$doDestroy" == "true" ]; then
  echo "Uninstalling llm and plugins"
  if ! dotRemove llm "manual"; then
    # ideally, we'd loop over the results of llm plugins, but I'm lazy
    llm uninstall -y llm-gemini &> /dev/null
    pip uninstall -y llm
  fi
  echo "Deleting .doNotCommit.llm and configs"
  # This is commented out because I'm testing the script and this is irrecoverable
  # rm "$config"
  # rm ~/.config/llm
  exit
fi

if [ "$doUpdate" == "true" ] && ! command -v llm; then
  exit
fi

if ! dotInstall llm "manual"; then
  echo "Setting up llm"
  uv tool install llm
fi

if [ "$doUpdate" == "true" ]; then
  if llm plugins | grep -q "llm-gemini"; then
    llm install -U llm-gemini
  fi
else
  if [ -z "$minimal" ]; then
    llm install llm-gemini
    if [ ! -f "$config" ]; then
      echo "Please provide Gemini API key. It will be stored in .doNotCommit.llm"
      read -s gemini_key
      cat<<END > ${config}
export LLM_GEMINI_KEY=$gemini_key
export LLM_USER_PATH="\$HOME/.config/llm"
alias vl='vi ~/.config/llm -c "cd ~/.config/llm"'
END
    fi
  fi
fi
