# See https://github.com/robbyrussell/oh-my-zsh/blob/master/templates/zshrc.zsh-template
# This file is loaded after .zshenv
PATH="$FLARE_PATH"

ZSH_DISABLE_COMPFIX=true # Remove "Insecure directories and files"
export ZSH=$HOME/.oh-my-zsh
# [ -n "$FLARE_ZSH_THEME" ] && ZSH_THEME="$FLARE_ZSH_THEME"
plugins=(aws vi-mode git extract z kubectl tmux docker-aliases docker-compose zsh-nvm node npm yarn zsh-better-npm-completion)

#Setup NVM
export NVM_COMPLETION=true  # Tab-completion
export NVM_LAZY_LOAD=true   # Make it fast
export NVM_LAZY_LOAD_EXTRA_COMMANDS=('gac' 'jira')

source $ZSH/oh-my-zsh.sh

# Jira cli auto complete
eval "$(jira --completion-script-zsh > /dev/null 2>&1)"

if [ -f "$(pwd)/.nvmrc" ] ; then
  nvm install
fi

# vim zsh
bindkey -v
#same as my vim.... also, slower than .1ms
bindkey jk vi-cmd-mode
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
