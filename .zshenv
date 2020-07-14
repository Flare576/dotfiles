# This file is loaded before .zshrc
# Secrets
source $HOME/.doNotCommit

export PATH="/usr/local/bin:${PATH}"
# export PATH="/usr/local/opt/python/libexec/bin:${PATH}"

#bindkey -v
#bindkey 'jk' vi-cmd-mode
setopt PUSHDSILENT
export KEYTIMEOUT=2
export EDITOR=vim
export CHEAT_CONFIG_PATH="$HOME/dotfiles/cheat/conf.yml"

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
  echo "$MY_LOC_NAME"
  TZ=$MY_LOC_TZ date "+%a %b %e %H:%M:%S %Z"
  echo "$REMOTE_LOC_NAME"
  TZ=$REMOTE_LOC_TZ date "+%a %b %e %H:%M:%S %Z"
  echo
  # Covid date is marked by the start of the first discovery
  discoverS=$(date -j -f "%b %d %Y %H:%M:%S" "Nov 17 2019 0:0:00" +%s)
  # Nice to track days since America gave a fuck
  quarentineS=$(date -j -f "%b %d %Y %H:%M:%S" "Mar 14 2020 0:0:00" +%s)
  # 2012 was a leap year (like 2020) that started on a day that matches day names
  similarCalS=$(date -j -f "%b %d %Y %H:%M:%S" "Jan 1 2012 0:0:00" +%s)
  # needed for maths
  realNowS=$(date +%s)

  secondsPassedZeroDay=$((realNowS - discoverS))
  secondsPassedQuar=$((realNowS - quarentineS))

  now=$((similarCalS + secondsPassedZeroDay))
  quarentine=$((similarCalS + secondsPassedQuar))

  cdate=$(date -r $now "+%a %b %e 0AC  %H:%M:%S")
  echo "$cdate"
  echo "Quarantine: $((secondsPassedQuar / 86400)) days"
}

function wweather() {
  fwatch 600 weather
}

function svtop() {
  if command -v vtop; then
    vtop
  else
    npm i -g vtop
    vtop
  fi
}

function wdate() {
  fwatch 1 prettyDate
}

# kubectl shortcuts
source $HOME/.zshrc.kubeHelper
