#!/bin/bash
source "$(dirname "$0")/../utils.sh"
usage="$(basename "$0") [-hvadmu]
Links dotfile configs and installs or updates vim and plugins by default.
Vim is a command-line text editor that frustrates git users.
Options:
  -h Show this help
  -v Display version
  -a Installs all plugins (unattended mode)
  -d Uninstall
  -m Only install/update vim and theme/functionality plugins
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
    a) allPlugins="true"
      ;;
    d) doDestroy="true"
      ;;
    m) minimal="true"
      ;;
    u) doUpdate="true"
      ;;
    *) echo "Unknown Option '$OPTARG', exiting"
      exit
      ;;
  esac
done
shift $((OPTIND -1))

check="$allPlugins$doDestroy$minimal$doUpdate"
config="$HOME/.doNotCommit.d/.doNotCommit.vim"

if [ -n "$check" ] && [ "$check" != "true" ]; then
  echo "-a, -d, -m, and -u are mutually exclusive; use one only"
  exit
fi

if [ "$doDestroy" == "true" ]; then
  dotRemove vim gvim
  echo "Removing vim plugins"
  rm -rf "$HOME/.vim"

  echo "Removing vimrc"
  rm -f "$HOME/.vimrc"

  echo "Removing vim shortcuts"
  rm -f "$config"

  engDir="$XDG_DATA_HOME"
  [ -z "$engDir" ] && engDir="$HOME/.local/share"
  if [ -f "$engDir/thesaurus.txt" ]; then
    echo "Deleting thesaurus..."
    rm -f "$engDir/thesaurus.txt"
  fi
  if [ -f "$engDir/stardict/CIDE-2.4.2" ]; then
    echo "Deleting dictionary..."
    rm -rf "$engDir/CIDE-2.4.2"
  fi
  if command -v sdcv &> /dev/null; then
    dotRemove sdcv
  fi

  if [ -n "$(pip3 --disable-pip-version-check list | grep jedi)" ]; then
    pip3 uninstall -y jedi
  fi
  exit
fi

if [ "$doUpdate" == "true" ] && ! command -v vim; then
  exit
fi

theme=(
  "altercation/vim-colors-solarized"  # Preferred Theme
  "sjl/badwolf"                       # Another theme
  "TaDaa/vimade"                      # handles fading/active effects
  "vim-airline/vim-airline"           # Status line manager
)
functionality=(
  "ervandew/supertab"            # Makes "Tab" key more super
  "tpope/vim-abolish"            # Allow `cr*` to coerce to [s]nake, [c]amel...
  "rking/ag.vim"                 # Silver Searcher in vim
  "kien/ctrlp.vim"               # jump to fuzzy file name
  "plytophogy/vim-diffchanges"   # Does diffing since save
  "lingceng/z.vim"               # Z-script in vim
  "tpope/vim-surround"           # cs'" to change surrounding ' to "
  "mg979/vim-visual-multi"       # Multi-cursor functionality
  "mbbill/undotree"              # <leader>u for a change history tree
  "samoshkin/vim-mergetool"      # Merge tool improvement
  "ludovicchabant/vim-gutentags" # Manages tag generation
  "majutsushi/tagbar"            # <leader>. for element list on right
  "dkarter/bullets.vim"          # markdown bullet awesomeness
  "tpope/vim-obsession"          # Session management made easy
  "yssl/QFEnter"                 # Quick Fix <leader>[space|enter] to open in split
)
js=(
  "MaxMEllon/vim-jsx-pretty"       # Makes JSX Pretty
  "elzr/vim-json"                  # Makes JSON Pretty
  "pangloss/vim-javascript"        # Makes JS Pretty
)
ts=(
  "leafgarland/typescript-vim"     # Makes TS Pretty
)
py=(
  "vim-scripts/indentpython.vim"   # PEP8 indentation
  "davidhalter/jedi-vim"           # Does a lot with Python
)
write=(
  "Ron89/thesaurus_query.vim"      # Brings sanity to thesaurus
)


dotInstall vim gvim

echo "Linking .vimrc, setting up plugins"
rm -rf "$HOME/.vim/bundle" "$HOME/.vim/autoload"
ln -fs "$HOME/dotfiles/.vimrc" "$HOME"
# vim 8.0+ handles plugin loading
plugins="$HOME/.vim/pack/plugins/start/"
mkdir -p "$plugins"
pushd "$plugins" &> /dev/null || exit

function vimInstall() {
  project="${1#*/}"
  [ "$doUpdate" == "true" ] && ! [ -d "$project" ] && return
  cloneOrUpdateGit "$1"
  vim -u NONE -c "helptags $project/doc" -c q
}

function checkAll() {
  if [[ "$miniV" =~ ^[yY] ]] ; then
    miniV='y'
    includeJS='n'
    includeTS='n'
    includePython='n'
    includeWriting='n'
  elif [[ "$miniV $includeJS $includeTS $includePython $includeWriting" == *"a"* ]] ; then
    includeJS='y'
    includeTS='y'
    includePython='y'
    includeWriting='y'
  fi
}

if [ -z "$check" ] ; then
  read -rp "Minimal Vim? (y)es/(n)o/(a)ll: " miniV
elif [ "$minimal" == "true" ]; then
  miniV='y'
elif [ "$allPlugins$doUpdate" == "true" ]; then
  miniV='a'
fi
checkAll

[[ "$miniV" =~ ^[nN] ]] && echo "Syntax Plugin Options:"
[ -z "$includeJS" ] && read -rp "Include javascript? (y)es/(n)o/(a)ll: " includeJS
checkAll
[ -z "$includeTS" ] && read -rp "Include typescript?  (y)es/(n)o/(a)ll: " includeTS
checkAll
[ -z "$includePython" ] && read -rp "Include python? (y)es/(n)o/(a)ll: " includePython
checkAll
[ -z "$includeWriting" ] && read -rp "Include writing tools? (y)es/(n)o/(a)ll: " includeWriting
checkAll

echo "Installing vim plugins"
############################## Theme ###########
for item in "${theme[@]}"; do
  vimInstall "$item"
done

############################## Functionality ###########
for item in "${functionality[@]}"; do
  vimInstall "$item"
done

############################## Syntax ###########
if [[ $includeJS == "y"* ]] ; then
  for item in "${js[@]}"; do
    vimInstall "$item"
  done
fi

if [[ $includeTS == "y"* ]] ; then
  for item in "${ts[@]}"; do
    vimInstall "$item"
  done
fi

if [[ $includeWriting == "y"* ]] ; then
  for item in "${write[@]}"; do
    vimInstall "$item"
  done
  dotInstall sdcv
  engDir="$XDG_DATA_HOME"
  [ -z "$engDir" ] && engDir="$HOME/.local/share"

  mkdir -p "$engDir/stardict"

  echo "Downloading thesaurus..."
  curl -sL -o "$engDir/thesaurus.txt" https://flare576.com/files/mthesaur.txt

  echo "Downloading dictionary..."
  curl -sL -o "/tmp/CIDE.tar.gz" https://flare576.com/files/CIDE-2.4.2.tar.gz
  tar -xvzf "/tmp/CIDE.tar.gz" -C "$engDir/stardict/"
  rm "/tmp/CIDE.tar.gz"
fi

if [[ $includePython == "y"* ]] ; then
  for item in "${py[@]}"; do
    vimInstall "$item"
  done
  echo "Installing jedi with uv"
  uv tool install jedi
fi

echo "Setting up shortcuts"

cat<<END > ${config}
export EDITOR=vim

# Quick-edit configs
alias vi="vim"
alias vz='vi -o ~/.zshrc ~/.zshenv -c "cd ~"'
alias vd='vi ~/dotfiles -c "cd ~/dotfiles"'
alias vs='vi ~/scripts -c "cd ~/scripts"'
alias vt='vi ~/.tmux.conf -c "cd ~/dotfiles"'
alias vc='vi ~/.config -c "cd ~/.config"'
alias v='vi .'
alias vv='vi -S'

function vw(){ vi \$(which \$1) }

alias dict='sdcv -2 ~/.local/share/stardict'
END
