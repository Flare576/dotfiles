#!/bin/sh
echo "Linking .vimrc, setting up plugins"

ln -s $HOME/dotfiles/.vimrc $HOME
# Setup pathogen
mkdir -p ~/.vim/autoload ~/.vim/bundle
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
cd ~/.vim/bundle
# Preferred Theme
git clone https://github.com/sjl/badwolf.git
# Formatter for JSON
git clone https://github.com/elzr/vim-json.git
# Formatter for Javascript
git clone https://github.com/pangloss/vim-javascript.git
# Formmatter for HTML
git clone https://github.com/vim-scripts/indenthtml.vim.git
# Formatter for Typescript
git clone https://github.com/leafgarland/typescript-vim.git
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
# Better Uber-undo
git clone git@github.com:sjl/gundo.vim.git
