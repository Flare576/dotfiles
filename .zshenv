# This file is loaded before .zshrc
# Secrets
source $HOME/.doNotCommit

export PATH="/usr/local/bin:${PATH}"
# export PATH="/usr/local/opt/python/libexec/bin:${PATH}"

#bindkey -v
#bindkey 'jk' vi-cmd-mode
export KEYTIMEOUT=2
export EDITOR=vim
export DEFAULT_CHEAT_DIR='$HOME/dotfiles/.cheat'

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

alias chrome='open -a Google\ Chrome'
alias vz='vi -o ~/.zshrc ~/.zshenv -c "cd ~"'
alias sz='source ~/.zshrc && source ~/.zshenv'
alias vd='vi ~/dotfiles -c "cd ~/dotfiles"'
alias vs='vi ~/scripts -c "cd ~/scripts"'
alias v='vi .'
alias pi='pipenv'
alias py='pipenv run python'
alias cat='bat'
alias git='hub'

function gs() {
  git submodule foreach $1
}

function gacp() {
  git add .
  git commit -m "$1"
  git push -u
}

function fwatch() {
  time=$1
  if [[ ! $time =~ ^[\.0-9]+$ ]] ; then
    echo "First argument must be sleep seconds"
    return 1
  fi

  shift
  while true; do
    out=$($*)
    clear
    printf "%s" $out
    sleep $time
  done
}

function weather() {
  if [ $(tput cols) -gt  "100" ] ; then
    curl -s "wttr.in/${MY_LOC_ZIP}?Q"
  else
    curl -s "wttr.in/${MY_LOC_ZIP}?0&Q"
  fi
  echo
  TZ=America/Chicago date
}

function prettyDate() {
  echo
  echo $MY_LOC_NAME
  TZ=$MY_LOC_TZ date "+%a %b %e %H:%M:%S %Z"
  echo
  echo $REMOTE_LOC_NAME
  TZ=$REMOTE_LOC_TZ date "+%a %b %e %H:%M:%S %Z"
}

function wweather() {
  fwatch 600 weather
}

function wdate() {
  fwatch 1 prettyDate
}

# kubectl shortcuts
source $HOME/.zshrc.kubeHelper
