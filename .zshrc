# See https://github.com/robbyrussell/oh-my-zsh/blob/master/templates/zshrc.zsh-template
# This file is loaded after .zshenv
# Minimal shell for Cursor Agent / tooling (skip Oh My Zsh, zle, theme — breaks output capture)
if [ -n "$CURSOR_AGENT" ]; then
  export PATH="/opt/homebrew/bin:$HOME/.bun/bin:$HOME/.local/bin:$PATH"
  [ -d "$HOME/.nvm/versions/node" ] && n=$(ls "$HOME/.nvm/versions/node" 2>/dev/null | sort -V | tail -1) && [ -n "$n" ] && export PATH="$HOME/.nvm/versions/node/$n/bin:$PATH"
  return 0
fi

PATH="$FLARE_PATH"

export ZSH=$HOME/.oh-my-zsh
# Removed due to lack of use: aws, kubectl, docker-aliases, docker-compose, node, npm, yarn, bun
plugins=(vi-mode git extract z tmux zsh-nvm zsh-better-npm-completion)

#Setup NVM
export NVM_COMPLETION=true  # Tab-completion
export NVM_LAZY_LOAD=true   # Make it fast
export NVM_LAZY_LOAD_EXTRA_COMMANDS=('gac' 'jira' 'vroom')

source $ZSH/oh-my-zsh.sh

# Jira cli auto complete
eval "$(jira --completion-script-zsh > /dev/null 2>&1)"

# NVM
if [ -f "$(pwd)/.nvmrc" ] ; then
  nvm install
fi

# Bun
if [ -d "$HOME/.bun" ] ; then
  [ -s "/home/flare/.oh-my-zsh/completions/_bun" ] && source "/home/flare/.oh-my-zsh/completions/_bun"
  export BUN_INSTALL="$HOME/.bun"
  export PATH="$BUN_INSTALL/bin:$PATH"
fi

# vim zsh
bindkey -v
#same as my vim.... also, slower than .1ms
bindkey -M vicmd B vi-beginning-of-line
bindkey -M vicmd E vi-end-of-line
export KEYTIMEOUT=3

# vim mapping removes up/down.... I like it, tho
# https://superuser.com/questions/585003/searching-through-history-with-up-and-down-arrow-in-zsh
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down
#bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search # Up
#bindkey "${terminfo[kcud1]}" down-line-or-beginning-search # Down

function zle-line-init zle-keymap-select {
  zle reset-prompt # We want to change the prompt when we enter/leave vim-mode keymap
}

# uses fzf to search history. Enter puts command on line but doesn't execute
function h() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac --height "50%" | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')
}

# Added by Homebrew Update Script
export PATH="/opt/homebrew/bin:$PATH"
