#!/bin/bash
if [[ "$1" == "delete" ]]; then
  echo "Removing ~/.vim/ and ~/.vimrc"
  rm -rf "$HOME/.vim" "$HOME/.vimrc"
  exit
fi

echo "Linking .vimrc, setting up plugins"
rm -rf "$HOME/.vim/bundle" "$HOME/.vim/autoload"
ln -fs $HOME/dotfiles/.vimrc $HOME
# vim 8.0+ handles plugin loading
plugins=~/.vim/pack/plugins/start/
mkdir -p $plugins
cd $plugins

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

if [ -z "$1" ] ; then
  read -p "Minimal Vim? (y/N/a)" miniV
else
  miniV='y'
fi
checkAll

[[ "$miniV" == 'n' ]] && echo "Syntax Plugin Options:"
[ -z "$includeJS" ] && read -p "Include javascript? (y)es/(n)o/(a)ll: " includeJS
checkAll
[ -z "$includeTS" ] && read -p "Include typescript?  (y)es/(n)o/(a)ll: " includeTS
checkAll
[ -z "$includePython" ] && read -p "Include python? (y)es/(n)o/(a)ll: " includePython
checkAll
[ -z "$includeWriting" ] && read -p "Include writing tools? (y)es/(n)o/(a)ll: " includeWriting
checkAll

echo "Installing vim plugins"
############################## Theme ###########
# Preferred Theme
echo "Cloning vim-colors-solarized"
git clone -q https://github.com/altercation/vim-colors-solarized.git
echo "Cloning vim-airline-themes"
git clone -q https://github.com/vim-airline/vim-airline-themes.git

# Backup Theme
echo "Cloning badwolf"
git clone -q https://github.com/sjl/badwolf.git

# active/inactive color update
echo "Cloning vimade"
git clone -q https://github.com/TaDaa/vimade.git

# Status line gud
echo "Cloning vim-airline"
git clone -q https://github.com/vim-airline/vim-airline.git

# SuperTab
echo "Cloning SuperTab"
git clone -q https://github.com/ervandew/supertab.git


############################## Plugins ###########
# Handle case, spelling, and replace without :'(
echo "Cloning abolish.vim"
git clone -q https://github.com/tpope/vim-abolish.git

# Silver Searcher in Vim
echo "Cloning ag.vim"
git clone -q https://github.com/rking/ag.vim.git

# CtrlP (file finder)
echo "Cloning ctrlp.vim"
git clone -q https://github.com/kien/ctrlp.vim.git

# Allows diffing changes in current file/buffer
echo "Cloning vim-diffchanges"
git clone -q https://github.com/plytophogy/vim-diffchanges.git

# Bring Z-power to Vim
echo "Cloning z.vim"
git clone -q https://github.com/lingceng/z.vim.git

# Flip those surroundings!
echo "Cloning vim-surround"
git clone -q https://github.com/tpope/vim-surround.git

# Multi-cursor support (for splits!
echo "Cloning multiple-cursors"
git clone -q https://github.com/terryma/vim-multiple-cursors.git

# Better undotree
echo "Cloning undotree"
git clone -q https://github.com/mbbill/undotree.git

# Merge tool soooo good
echo "Cloning vim-mergetool"
git clone -q https://github.com/samoshkin/vim-mergetool.git

# tag support
echo "Cloning vim-gutentags"
git clone -q https://github.com/ludovicchabant/vim-gutentags.git

echo "Cloning tagbar"
git clone -q https://github.com/majutsushi/tagbar.git

# EditorConfig support (see https://editorconfig.org/)
# git clone -q https://github.com/editorconfig/editorconfig-vim.git

# better lists/bullets
echo "Cloning bullets"
git clone -q https://github.com/dkarter/bullets.vim.git

if [[ $includeJS == "y"* ]] ; then
  # JSX
  echo "Cloning vim-jsx-pretty"
  git clone -q https://github.com/MaxMEllon/vim-jsx-pretty.git

  # JSON
   echo "Cloning vim-json"
  git clone -q https://github.com/elzr/vim-json.git
  # Javascript

  echo "Cloning vim-javascript"
  git clone -q https://github.com/pangloss/vim-javascript.git
fi
if [[ $includeTS == "y"* ]] ; then
  # Typescript
  echo "Cloning typescript-vim"
  git clone -q https://github.com/leafgarland/typescript-vim.git
fi
if [[ $includeWriting == "y"* ]] ; then
  echo "Downloading thesaurus..."
  thesDir="$XDG_DATA_HOME"
  [ -z "$thesDir" ] && thesDir="$HOME/.local/share"
  mkdir -p "$thesDir"
  curl -sL -o "$thesDir/thesaurus.txt" http://www.gutenberg.org/files/3202/files/mthesaur.txt
fi
if [[ $includePython == "y"* ]] ; then
  # Intelligent indentation handling
  echo "Cloning indentpython.vim"
  git clone -q https://github.com/vim-scripts/indentpython.vim.git

  # Autocompletion for Python
  echo "Cloning jedi-vim"
  git clone -q https://github.com/davidhalter/jedi-vim.git
  echo "Installing jedi with pip3"
  pip3 install jedi
fi
