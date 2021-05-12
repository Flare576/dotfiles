# This file is loaded before .zshrc
# Change "path" to an -a(rray) -U(nique) (special) type, prevents dup entries
typeset -aU path
# Secrets
for f in "$HOME/.doNotCommit.d"/.doNotCommit*; do [[ $f != *".sw"* ]] && source $f; done

setopt PUSHDSILENT
export EDITOR=vim
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
alias v='vi .'
alias vv='vi -S'
function vw(){ vi $(which $1) }

alias chrome='open -a Google\ Chrome'
alias firefox='open -a Firefox'
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

alias plcat='plutil -convert xml1 -o -'

source "$HOME/dotfiles/scripts/switchTheme.sh"
alias st="switchTheme"

function gs() {
  git submodule foreach $1
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

  cdate=$(date -r $now "+%a %b %e 1AC  %H:%M:%S")
  echo "$cdate"
  ping -c 1 https://google.com &> /dev/null
  if [ $? ]; then
    echo "Netowork Status: ✅"
  else
    echo "Netowork Status: ❌"
  fi
  #echo "Quarantine: $((secondsPassedQuar / 86400)) days"
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

# ZSH/OMZ "switchTheme" functionality to watch for changes to theme settings
function zsh_theme_refresh() {
  conf="$HOME/dotfiles/.doNotCommit.d/.doNotCommit.theme"
  [ -f "$conf" ] && source "$conf"
  [ -f "$ZSH/themes/$FLARE_ZSH_THEME.zsh-theme" ] && source "$ZSH/themes/$FLARE_ZSH_THEME.zsh-theme"
}
precmd_functions=(${precmd_functions[@]} zsh_theme_refresh)

# application shortcuts
source $HOME/.zshrc.kubeHelper
source $HOME/.zshrc.awsHelper
