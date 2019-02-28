# See https://github.com/robbyrussell/oh-my-zsh/blob/master/templates/zshrc.zsh-template
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="cobalt2"
plugins=(git extract node z zsh-better-npm-completion kubectl)

export PATH="${HOME}/.nvm/versions/node/v5.9.0/bin:/usr/bin/env:${PATH}"

source $ZSH/oh-my-zsh.sh

# Iterm
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Jira cli auto complete
eval "$(jira --completion-script-zsh)"
# vroom autocomplete
source $HOME/dotfiles/scripts/vroom-completion.zsh
# gmb autocomplete
source $HOME/dotfiles/scripts/gmb-completion.zsh

#Setup NVM
export NVM_DIR="$HOME/.nvm"
. "/usr/local/opt/nvm/nvm.sh"

