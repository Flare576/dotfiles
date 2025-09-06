#!/bin/bash
source "$(dirname "$0")/utils.sh"

# "Simple" means there isn't a dedicated script to install the app
all_simple=(
  awscli               # Amazon Web Service CLI
  bat                  # enhanced version of the cat command
  fzf                  # FuzzyFind lets you search through piped-in data (useful with history)
  git                  # it's git
  gh                   # github's cli tool for everything not in git
  graphviz             # For PlantUML
  hub                  # overlay to git, adds github-specific calls/functionality
  jq                   # work with JSON with a command-line query language
  jre-openjdk          # Steam Deck needs java
  k9s                  # Any project using K8s
  lazydocker           # Any project using straight Docker
  rpg-cli              # A bit of fun for folder management
  shellcheck           # helps debugging/formatting shell scripts
  universal-ctags      # generates indexes used by vim for "intellisense"-like features
  watch                # repeatedly call a command and monitor output
  watson               # Great time tracker
  samba                # Shared Directories for Linux
  lftp                 # For deploying website
  make                 # Steam Deck doesn't have make somehow
  uv                   # Python tool kit
)
all_scripted=(
  cheat.sh
  jira.sh
  omz.sh
  # python.sh          # Sunset, don't worry about global python, use uv
  scripts.sh
  silversearcher.sh
  tmux.sh
  vim.sh               # Python deps need pip for Jedi - must come after python
  llm.sh
)

# Each should be a subset of all
work_simple=(
  awscli
  bat
  fzf
  git
  gh
  graphviz
  hub
  jq
  k9s
  lazydocker
  rpg-cli
  shellcheck
  universal-ctags
  watch
  watson
  uv
)
work_scripted=(
  cheat.sh
  jira.sh
  omz.sh
  scripts.sh
  silversearcher.sh
  tmux.sh
  vim.sh
  llm.sh
)
personal_simple=(
  bat
  fzf
  gh
  git
  graphviz
  hub
  shellcheck
  universal-ctags
  watch
  jq
  rpg-cli
  uv
)
personal_scripted=(
  cheat.sh
  omz.sh
  scripts.sh
  silversearcher.sh
  jira.sh
  tmux.sh
  vim.sh
  llm.sh
)
steamdeck_simple=(
  bat
  gh
  git
  graphviz
  hub
  jre-openjdk
  jq
  rpg-cli
  universal-ctags
  lftp
  make
  uv
)
steamdeck_scripted=(
  cheat.sh
  omz.sh
  scripts.sh
  silversearcher.sh
  tmux.sh
  vim.sh
  llm.sh
)
remote_simple=(
  bat
  git
  hub
  jq
  universal-ctags
)
remote_scripted=(
  cheat.sh
  omz.sh
  scripts.sh
  silversearcher.sh
  tmux.sh
  vim.sh
)

usage="$(basename "$0") [-hfvamdpu] app
Installs tools/applications based on -p Profile or provided app.
Options:
  -h Show this help
  -v Display version
  -p Profile name [all, work, personal, remote, steamdeck]
  -a Install all features of tools/apps
  -m Install minimal versions of tools/apps
  -f Force a simple install regardless of profile/list
  -d Unlink files and Uninstall tools/apps
  -u Update installed applications
"

while getopts ':hfvadmp:u' option; do
  case "$option" in
    h) echo "$usage"
      exit
      ;;
    v) echo "$VERSION"
      exit
      ;;
    d) doDestroy="-d"
      ;;
    a) all="-a"
      ;;
    m) minimal="-m"
      ;;
    p) profile="$OPTARG"
      ;;
    f) force="true"
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

target="$1"

if [ -n "$force" ]; then
  if [ -n "$doUpdate" ]; then
    if command -v "$target"; then
      echo "Attempting blind update"
      dotInstall "$target"
    else
      echo "Can't update what's not installed"
    fi
  else
    echo "Attempting blind install"
    dotInstall "$target"
  fi
  exit
fi

if [ "$profile" == "work" ]; then
  simple=("${work_simple[@]}")
  scripted=("${work_scripted[@]}")
elif [ "$profile" == "personal" ]; then
  simple=("${personal_simple[@]}")
  scripted=("${personal_scripted[@]}")
elif [ "$profile" == "steamdeck" ]; then
  simple=("${steamdeck_simple[@]}")
  scripted=("${steamdeck_scripted[@]}")
elif [ "$profile" == "remote" ]; then
  simple=("${remote_simple[@]}")
  scripted=("${remote_scripted[@]}")
else
  simple=("${all_simple[@]}")
  scripted=("${all_scripted[@]}")
fi

for app in "${simple[@]}"
do
  [ -n "$target" ] && [ "$target" != "$app" ] && continue
  if [ -n "$doDestroy" ]; then
   dotRemove "$app"
  elif [ -n "$doUpdate" ]; then
    case "$app" in
      "the_silver_searcher")
        command -v ag && dotInstall "$app" "silversearcher-ag"
        ;;
      "uv")
        command -v uv && dotInstall "$app" "python-uv"
        ;;
      *) command -v "$app" && dotInstall "$app"
        ;;
    esac
  else # Install
    case "$app" in
      "the_silver_searcher") dotInstall "$app" "silversearcher-ag"
        ;;
      "uv") dotInstall "$app" "python-uv"
        ;;
      *) dotInstall "$app"
        ;;
    esac
  fi
done

params="$all $minimal $doDestroy $doUpdate"
for script in "${scripted[@]}"
do
  [ -n "$target" ] && [ "$target.sh" != "$script" ] && continue
  bash "$HOME/dotfiles/setup/APPS/$script" $params
done

# Jetbrains Mono is a great font for terminals; install it so it's available on this system
if [ -z "$target" ] && [ -n "$doDestroy" ]; then
  # not really sure how to uninstall from Linux...
  if [ "$isLinux" == "true" ] ; then
    echo "We can pretend I uninstalled Jetbrains font..."
  elif brew ls --versions font-jetbrains-mono >/dev/null; then
    brew uninstall --cask font-jetbrains-mono
  fi
elif [ -z "$target" ]; then
  if [ "$isLinux" == "true" ]; then
    # TODO - I do want this on my steam deck, but I don't know if it needs distrobox-host-exec or not yet
    if [ "$profile" != "remote" ] && [ "$profile" != "steamdeck" ]; then
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"
    fi
  elif [[ "$1" == "update" ]]; then
    if brew ls --versions font-jetbrains-mono &> /dev/null; then
      brew upgrade --cask font-jetbrains-mono
    fi
  else
    brew install --cask font-jetbrains-mono
  fi
fi

