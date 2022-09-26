#!/bin/bash
source "$(dirname "$0")/../utils.sh"
usage="$(basename "$0") [-hvadm]
Links dotfile configs and installs or updates vim and plugins by default.
Vim is a command-line text editor that frustrates git users.
Options:
  -h Show this help
  -v Display version
  -a Installs all plugins (unattended mode)
  -d Uninstall Vim/plugins
  -m Only install/update vim and theme/functionality plugins
"

while getopts ':hvadm' option; do
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
    *) echo "Unknown Option '$option', exiting"
      exit
      ;;
  esac
done
shift $((OPTIND -1))

check="$allPlugins$doDestroy$minimal"

if [ -n "$check" ] && [ "$check" != "true" ]; then
  echo "-a, -d, and -m are mutually exclusive; use one only"
  exit
fi

if [ "$doDestroy" == "true" ]; then
  dotRemove vim
  echo "Removing vim plugins"
  rm -rf "$HOME/.vim"
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

dotInstall vim

echo "Linking .vimrc, setting up plugins"
rm -rf "$HOME/.vim/bundle" "$HOME/.vim/autoload"
ln -fs "$HOME/dotfiles/.vimrc" "$HOME"
# vim 8.0+ handles plugin loading
plugins="$HOME/.vim/pack/plugins/start/"
mkdir -p "$plugins"
pushd "$plugins" &> /dev/null || exit

function vimInstall() {
  cloneOrUpdateGit "$1"
  project="${1#*/}"
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
elif [ "$allPlugins" == "true" ]; then
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
  thesDir="$XDG_DATA_HOME"
  [ -z "$thesDir" ] && thesDir="$HOME/.local/share"
  if [ ! -f "$thesDir/thesaurus.txt" ]; then
    echo "Downloading thesaurus..."
    mkdir -p "$thesDir"
    curl -sL -o "$thesDir/thesaurus.txt" http://www.gutenberg.org/files/3202/files/mthesaur.txt
  fi
fi

if [[ $includePython == "y"* ]] ; then
  for item in "${py[@]}"; do
    vimInstall "$item"
  done
  echo "Installing jedi with pip3"
  pip3 install jedi
fi
