# See https://github.com/robbyrussell/oh-my-zsh/blob/master/templates/zshrc.zsh-template
# This file is loaded after .zshenv

export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="cobalt2"

#Setup NVM
export NVM_COMPLETION=true  # Tab-completion
export NVM_LAZY_LOAD=true   # Make it fast
export NVM_LAZY_LOAD_EXTRA_COMMANDS=('gac')

plugins=(zsh-nvm git extract node npm yarn z zsh-better-npm-completion kubectl)

source $ZSH/oh-my-zsh.sh

# Jira cli auto complete
eval "$(jira --completion-script-zsh > /dev/null 2>&1)"

here=$(pwd)
if [ -f "$here/.nvmrc" ] ; then
  nvm install
fi
