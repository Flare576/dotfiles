# This file is loaded before .zshrc
# Secrets
source $HOME/.doNotCommit

#export PATH="/home/linuxbrew/.linuxbrew/opt/python@3.8/libexec/bin:${PATH}"
# export PATH="/usr/local/bin:${PATH}"
# export PYTHONHOME="/usr/local/opt/python/libexec/bin"
# export PYTHONHOME="/usr/bin/python3"
# export PATH="/usr/local/opt/python/libexec/bin:${PATH}"

setopt PUSHDSILENT
export EDITOR=vim
export CHEAT_CONFIG_PATH="$HOME/dotfiles/cheat/conf.yml"

command -v pyenv >/dev/null 2>&1 && eval "$(pyenv init -)"

alias chrome='open -a Google\ Chrome'
alias vz='vi -o ~/.zshrc ~/.zshenv -c "cd ~"'
alias sz='source ~/.zshrc && source ~/.zshenv'
alias vd='vi ~/dotfiles -c "cd ~/dotfiles"'
alias vs='vi ~/scripts -c "cd ~/scripts"'
alias vt='vi ~/.tmux.conf -c "cd ~/dotfiles"'
alias tm='tmux new-session'
alias v='vi .'
alias vv='vi -S /tmp/ongoing'
alias pi='pipenv'
alias py='pipenv run python'
# alias python='echo "maybe try pi/py..."'
command -v bat > /dev/null 2>&1 || alias bat='batcat' # Some *nix systems needed a different name
alias cat='bat'
alias git='hub'
alias lzy='lazydocker'
alias dnuke='docker system prune --volumes -af'
alias lzye='vi $HOME/Library/Application\ Support/jesseduffield/lazydocker/config.yml'
alias plcat='plutil -convert xml1 -o -'
source "$HOME/dotfiles/scripts/switchTheme.sh"
alias st="switchTheme"

function note() {
  vi ~/.doNotCommit.folder/$1
}

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
  tmux select-pane -P 'bg=#000000'
  if [ $(tput cols) -gt  "100" ] ; then
    curl -s "wttr.in/${MY_LOC_ZIP}?Q"
  else
    curl -s "wttr.in/${MY_LOC_ZIP}?0&Q"
  fi
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
  if ! command -v npm; then
    nvm install stable
  fi

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

function yaml() {
  python3 -c "import yaml;print(yaml.safe_load(open('$1'))$2)"
}

function zsh_theme_refresh() {
  [ -f "$HOME/.doNotCommit.theme" ] && source "$HOME/.doNotCommit.theme"
  [ -f "$ZSH/themes/$FLARE_ZSH_THEME.zsh-theme" ] && source "$ZSH/themes/$FLARE_ZSH_THEME.zsh-theme"
}
precmd_functions=(${precmd_functions[@]} zsh_theme_refresh)

# kubectl shortcuts
source $HOME/.zshrc.kubeHelper
