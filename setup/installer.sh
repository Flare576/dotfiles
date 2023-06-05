#!/bin/bash
source "$(dirname "$0")/utils.sh"

# "Simple" means there isn't a dedicated script to install the app
all_simple=(
  awscli               # Amazon Web Service CLI
  bat                  # enhanced version of the cat command
  fzf                  # FuzzyFind lets you search through piped-in data (useful with history)
  git                  # it's git
  hub                  # overlay to git, adds github-specific calls/functionality
  jq                   # work with JSON with a command-line query language
  k9s                  # Any project using K8s
  lazydocker           # Any project using straight Docker
  rpg-cli              # A bit of fun for folder management
  shellcheck           # helps debugging/formatting shell scripts
  the_silver_searcher  # provides enhanced search support with 'ag'
  universal-ctags      # generates indexes used by vim for "intellisense"-like features
  watch                # repeatedly call a command and monitor output
  watson               # Great time tracker
)
all_scripted=(
  cheat.sh
  jira.sh
  omz.sh
  python.sh
  scripts.sh
  tmux.sh
  vim.sh
)

# Each should be a subset of all
work_simple=(
  awscli
  bat
  fzf
  git
  hub
  jq
  k9s
  lazydocker
  rpg-cli
  shellcheck
  the_silver_searcher
  universal-ctags
  watch
  watson
)
work_scripted=(
  cheat.sh
  jira.sh
  omz.sh
  python.sh
  scripts.sh
  tmux.sh
  vim.sh
)
personal_simple=(
  bat
  fzf
  git
  hub
  shellcheck
  the_silver_searcher
  universal-ctags
  watch
  jq
  rpg-cli
)
personal_scripted=(
  cheat.sh
  omz.sh
  python.sh
  scripts.sh
  jira.sh
  tmux.sh
  vim.sh
)

remote_simple=(
  bat
  the_silver_searcher
  universal-ctags
)
remote_scripted=(
  cheat.sh
  scripts.sh
  tmux.sh
  vim.sh
)

usage="$(basename "$0") [-hvmd]
Installs tools/applications based on -p Profile
Options:
  -h Show this help
  -v Display version
  -p Profile name [all, work, personal, remote]
  -m Install minimal versions of tools/apps
  -d Unlink files and Uninstall tools/apps
  -u Update installed applications
"

while getopts ':hvdmp:u' option; do
  case "$option" in
    h) echo "$usage"
      exit
      ;;
    v) echo "$VERSION"
      exit
      ;;
    d) doDestroy="-d"
      ;;
    m) minimal="-m"
      ;;
    p) profile="$OPTARG"
      ;;
    u) doUpdate="-u"
      ;;
    *) echo "Unknown Option '$option', exiting"
      exit
      ;;
  esac
done
shift $((OPTIND -1))

: ${profile:="all"}

if [ "$profile" == "work" ]; then
  simple=("${work_simple[@]}")
  scripted=("${work_scripted[@]}")
elif [ "$profile" == "personal" ]; then
  simple=("${personal_simple[@]}")
  scripted=("${personal_scripted[@]}")
elif [ "$profile" == "remote" ]; then
  simple=("${remote_simple[@]}")
  scripted=("${remote_scripted[@]}")
else
  simple=("${all_simple[@]}")
  scripted=("${all_scripted[@]}")
fi

for app in "${simple[@]}"
do
  if [ -n "$doDestroy" ]; then
   dotRemove "$app"
  elif [ -n "$doUpdate" ]; then
    case "$app" in
      "the_silver_searcher")
        command -v ag && dotInstall "$app" "silversearcher-ag"
        ;;
      *) command -v "$app" && dotInstall "$app"
        ;;
    esac
  else # Install
    case "$app" in
      "the_silver_searcher") dotInstall "$app" "silversearcher-ag"
        ;;
      *) dotInstall "$app"
        ;;
    esac
  fi
done

params="$minimal $doDestroy $doUpdate"
for script in "${scripted[@]}"
do
    bash "$HOME/dotfiles/setup/APPS/$script" $params
done

# Jetbrains Mono is a great font for terminals; install it so it's available on this system
if [ -n "$doDestroy" ]; then
  # not really sure how to uninstall from Linux...
  if [ "$isLinux" == "true" ] ; then
    echo "We can pretend I uninstalled Jetbrains font..."
  elif brew ls --versions homebrew/cask-fonts/font-jetbrains-mono >/dev/null; then
    brew uninstall --cask homebrew/cask-fonts/font-jetbrains-mono
  fi
else
  if [ "$isLinux" == "true" ]; then
    if [ "$profile" != "remote" ]; then
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"
    fi
  elif [[ "$1" == "update" ]]; then
    if brew ls --versions homebrew/cask-fonts/font-jetbrains-mono >/dev/null; then
      brew upgrade --cask homebrew/cask-fonts/font-jetbrains-mono
    fi
  else
    brew install --cask homebrew/cask-fonts/font-jetbrains-mono
  fi
fi

