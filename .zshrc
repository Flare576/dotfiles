# See https://github.com/robbyrussell/oh-my-zsh/blob/master/templates/zshrc.zsh-template
# This file is loaded after .zshenv

ZSH_DISABLE_COMPFIX=true # Remove "Insecure directories and files"
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="$FLARE_ZSH_THEME"

#Setup NVM
export NVM_COMPLETION=true  # Tab-completion
export NVM_LAZY_LOAD=true   # Make it fast
export NVM_LAZY_LOAD_EXTRA_COMMANDS=('gac' 'jira')

plugins=(zsh-nvm git extract node npm yarn z zsh-better-npm-completion kubectl tmux)

source $ZSH/oh-my-zsh.sh

# Jira cli auto complete
eval "$(jira --completion-script-zsh > /dev/null 2>&1)"

here=$(pwd)
if [ -f "$here/.nvmrc" ] ; then
  nvm install
fi
