#!/bin/bash
source "$(dirname "$0")/utils.sh"

# "Simple" means there isn't a dedicated script to install the app
all_simple=(
  awscli               # Amazon Web Service CLI
  bat                  # enhanced version of the cat command
  fzf                  # FuzzyFind lets you search through piped-in data (useful with history)
  git                  # it's git
  "npm:git-gac"        # make git a little easier
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
)
all_scripted=(
  cheat.sh
  jira.sh
  omz.sh
  scripts.sh
  silversearcher.sh
  tmux.sh
  vim.sh
  llm.sh
)

# Each should be a subset of all
work_simple=(
  awscli
  bat
  fzf
  git
  "npm:git-gac"
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
  "npm:git-gac"
  graphviz
  hub
  shellcheck
  universal-ctags
  watch
  jq
  rpg-cli
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
  "npm:git-gac"
  graphviz
  hub
  jre-openjdk
  jq
  rpg-cli
  universal-ctags
  lftp
  make
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
  "npm:git-gac"
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

if [ -z "$profile" ]; then
  echo "You don't want to install everything, trust me..."
  exit 1
fi

# Handle app ecosystems, like python and NodeJS
NVM_DIR="${NVM_DIR:-"$HOME/.nvm"}"
# NOTE: "Destroy" is handled after the rest of the script because individual apps might have their own cleanup
if [ -z "$doDestroy" ]; then # Install / Update
  echo "Installing / Updating uv and Python Ecosystem"
  if ! command -v uv &> /dev/null; then
     dotInstall "uv" "manual" || curl -LsSf https://astral.sh/uv/install.sh | sh
   else
    uv self update
  fi

  # Technically, omz-nvm will install NVM on first load, but it also uses whats there
  # Don't use the install script, though - it adds lines to your profile
  echo "Installing / Updating  NVM and NodeJS Ecosystem"
  mkdir -p "$NVM_DIR"
  pushd "$NVM_DIR" &> /dev/null || exit
  if ! [ -d ".git" ]; then
    git clone https://github.com/nvm-sh/nvm.git .
  else
    git pull
  fi
  source "nvm.sh"
  nvm install stable
  popd &> /dev/null || exit
fi

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
      if ! command unzip &> /dev/null; then
        dotInstall unzip
      fi
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

# NOTE: "Destroy" is handled after the rest of the script because individual apps might have their own cleanup
if [ -n "$doDestroy" ]; then
  echo "Removing uv and Python ecosystem"
  uv cache clean
  rm -rf "$(uv python dir)"
  rm -rf "$(uv tool dir)"

  echo "Removing NVM and NodeJS ecosystem"
  nvm unload
  rm -rf "$NVM_DIR"
fi
