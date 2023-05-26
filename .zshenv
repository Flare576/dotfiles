# This file is loaded before .zshrc
# Change "path" to an -a(rray) -U(nique) (special) type, prevents dup entries
typeset -aU path

# OSX baseline paths (see note on path_helper at bottom of file)
if [ -x /usr/libexec/path_helper ]; then
	eval `/usr/libexec/path_helper -s`
fi

# Secrets
if [ -d "$HOME/.doNotCommit.d" ]; then
  for f in "$HOME/.doNotCommit.d"/.doNotCommit*; do [[ $f != *".sw"* ]] && source $f; done
fi

if [ -f "/opt/homebrew/bin/brew" ]; then
  # Apple Silicon Macs have new directory
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  # i86 homebrew
  export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
fi

# because it's never easy
alias make=gmake
source "$(switch-theme)"

alias -g dateS="date '+%Y-%m-%dT%H-%M-%S'"
setopt PUSHDSILENT
export EDITOR=vim
export XDG_CONFIG_HOME="$HOME/.config" # https://wiki.archlinux.org/title/XDG_Base_Directory
export CHEAT_CONFIG_PATH="$HOME/cheat/conf.yml"

# Initialize pyenv
# Monterey 12.3 stopped shipping python2 - using pyenv to manage installs
command -v pyenv >/dev/null 2>&1 && eval "$(pyenv init -)"

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
alias sysup="$HOME/dotfiles/setup/installer.sh -u"
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

# OSX will use /etc/zshrc between this file and .zshenv - ignore the path changes
# https://github.com/sorin-ionescu/prezto/issues/381
FLARE_PATH="$PATH"
