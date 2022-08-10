# This file is loaded before .zshrc
# Change "path" to an -a(rray) -U(nique) (special) type, prevents dup entries
typeset -aU path
# Secrets
if [ -d "$HOME/.doNotCommit.d" ]; then
  for f in "$HOME/.doNotCommit.d"/.doNotCommit*; do [[ $f != *".sw"* ]] && source $f; done
fi
# Apple Silicon Macs have new directory
[ -f "/opt/homebrew/bin/brew" ] && eval "$(/opt/homebrew/bin/brew shellenv)"
export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
source "$(switch-theme)"

alias -g dateS="date '+%Y-%m-%dT%H-%M-%S'"
setopt PUSHDSILENT
export EDITOR=vim
export XDG_CONFIG_HOME="$HOME/.config" # https://wiki.archlinux.org/title/XDG_Base_Directory
export CHEAT_CONFIG_PATH="$HOME/cheat/conf.yml"

# Initialize pyenv
# command -v pyenv >/dev/null 2>&1 && eval "$(pyenv init -)"
## # temp
## export PYTHONPATH=/usr/local/lib/python3.9/site-packages/
# Quick-edit configs
alias vz='vi -o ~/.zshrc ~/.zshenv -c "cd ~"'
alias vd='vi ~/dotfiles -c "cd ~/dotfiles"'
alias vs='vi ~/scripts -c "cd ~/scripts"'
alias vt='vi ~/.tmux.conf -c "cd ~/dotfiles"'
alias vc='vi ~/.config -c "cd ~/.config"'
alias v='vi .'
alias vk='vi ~/Projects/Personal/sofle/qmk_firmware/keyboards/sofle/keymaps/flare576/'
alias vv='vi -S'
function vw(){ vi $(which $1) }

alias chrome='open -a Google\ Chrome'
alias firefox='open -a Firefox'
alias wat='watson'
alias wats='watson status'
alias waty='watson report --from $(date -v -1d "+%Y-%m-%d") --to $(date -v -1d "+%Y-%m-%d")'
alias wata='watson aggregate'
alias sz='source ~/.zshrc && source ~/.zshenv'
alias tm='tmux new-session'

alias pi='pipenv'
alias py='pipenv run python'
# Leaving this as a reminder to never do this
# alias python='echo "maybe try pi/py..."'

# Utilities
command -v batcat > /dev/null && alias bat='batcat' # Some *nix systems needed a different name
alias cat='bat'
alias git='hub'
alias c="cheat"
alias cpl="cheat -t private -l"
alias cpe="cheat -t private -e"
alias note="cheat -t private -e"
alias notes="cheat -l -t private"

alias lzy='lazydocker'
alias lzye='vi $HOME/Library/Application\ Support/jesseduffield/lazydocker/config.yml'
alias dclean='docker system prune --volumes -f'
alias dnuke='docker system prune --volumes -af'
alias dstop="osascript -e 'quit app \"Docker\"'"
alias dstart="open -a Docker"

alias plcat='plutil -convert xml1 -o -'


function sudoedit () {
  protected_file="$1"
  case $protected_file in
    (*.*) extension=${protected_file##*.};;
    (*)   extension="tmp";;
  esac
  editable_file="/tmp/$RANDOM.$extension"
  sudo cp "$protected_file" "$editable_file"
  sudo chown "$(whoami)" "$editable_file"
  sudo chmod 600 "$editable_file"
  $EDITOR "$editable_file"
  if [ $? -eq 0 ]; then
    sudo cp "$editable_file" "$protected_file"
  fi
  rm "$editable_file"
}

function gs() {
  git submodule foreach $1
}

personaldot="$HOME/personaldot/.zshenv"
[ -f "$personaldot" ] && source "$personaldot"

# application shortcuts
source $HOME/.zshrc.kubeHelper
source $HOME/.zshrc.awsHelper
source $HOME/.zshrc.rpg
