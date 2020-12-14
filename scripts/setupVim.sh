#!/bin/bash
echo "Linking .vimrc, setting up plugins"
rm -rf "$HOME/.vim/bundle" "$HOME/.vim/autoload"
ln -fs $HOME/dotfiles/.vimrc $HOME
# vim 8.0+ handles plugin loading
plugins=~/.vim/pack/plugins/start/
mkdir -p $plugins
cd $plugins

############################## Theme ###########
# Preferred Theme
git clone https://github.com/sjl/badwolf.git
# active/inactive color update
git clone https://github.com/TaDaa/vimade
# Status line gud
git clone https://github.com/vim-airline/vim-airline

############################## Plugins ###########
# Silver Searcher in Vim
git clone https://github.com/rking/ag.vim.git
# CtrlP (file finder)
git clone https://github.com/kien/ctrlp.vim.git
# Allows diffing changes in current file/buffer
git clone https://github.com/plytophogy/vim-diffchanges
# Bring Z-power to Vim
git clone https://github.com/lingceng/z.vim.git
# Flip those surroundings!
git clone https://github.com/tpope/vim-surround.git
# Multi-cursor support
git clone https://github.com/terryma/vim-multiple-cursors.git
# Better undotree
git clone https://github.com/mbbill/undotree.git
# Merge tool soooo good
git clone https://github.com/samoshkin/vim-mergetool.git
# tag support
git clone https://github.com/ludovicchabant/vim-gutentags.git
git clone https://github.com/majutsushi/tagbar.git
# EditorConfig support (see https://editorconfig.org/)
git clone https://github.com/editorconfig/editorconfig-vim.git

############################## Syntax ###########
# JSX
git clone https://github.com/MaxMEllon/vim-jsx-pretty.git
# JSON
git clone https://github.com/elzr/vim-json.git
# Javascript
git clone https://github.com/pangloss/vim-javascript.git
# HTML
git clone https://github.com/vim-scripts/indenthtml.vim.git
# Typescript
git clone https://github.com/leafgarland/typescript-vim.git
# Thesourus... does English count as syntax? ¯\_(ツ)_/¯ 
echo "Downloading thesaurus..."
thesDir="$XDG_DATA_HOME"
[ -z "$thesDir" ] && thesDir="$HOME/.local/share"
mkdir -p "$thesDir"
curl -sL -o "$thesDir/thesaurus.txt" http://www.gutenberg.org/files/3202/files/mthesaur.txt
