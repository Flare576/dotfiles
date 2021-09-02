# This file is loaded before .zshrc
# Change "path" to an -a(rray) -U(nique) (special) type, prevents dup entries
typeset -aU path
# Secrets
if [ -d "$HOME/.doNotCommit.d" ]; then
  for f in "$HOME/.doNotCommit.d"/.doNotCommit*; do [[ $f != *".sw"* ]] && source $f; done
fi
export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
source "$(/usr/local/bin/switch-theme)"

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
alias vk='vi ~/Projects/Personal/qmk_firmware/keyboards/sofle/keymaps/flare576/'
alias vv='vi -S'
function vw(){ vi $(which $1) }

alias chrome='open -a Google\ Chrome'
alias firefox='open -a Firefox'
alias wat='watson'
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

# Fun RPG-CLI integrations
alias rpg=rpg-cli
function zz() {
  dest=$(_z -e "$@" 2>&1)
  rpg-cli cd "$dest"
  cd "$(rpg-cli pwd)"
}
function ls() {
  # don't do if no rpg-cli like on ubuntu images
  if command -v rpg-cli &> /dev/null; then
    # You're here isn't psychic, they only get to look in the current dir...
    rpg-cli ls
  fi
  # but you are a dev, so I guess you can run normal command with params
  command ls $@
}
# if something is on fire, don't forget about the -f flag for the RPG thing
function cd() {
  # don't do if no rpg-cli like on ubuntu images
  if command -v rpg-cli &> /dev/null; then
    rpg-cli cd "$@"
    builtin cd "$(rpg-cli pwd)"
  else
    builtin cd $@
  fi
}
function rup() {
  rpg-cli use potion
}
function rb() {
  rpg-cli battle
}
function re() {
  rpg-cli use escape
  builtin cd ~
}
# make a new dungeon!! https://github.com/facundoolano/rpg-cli/blob/main/shell/README.md#arbitrary-dungeon-levels
function dn() {
    current=$(basename $PWD)
    number_re='^[0-9]+$'

    if [[ $current =~ $number_re ]]; then
        next=$(($current + 1))
        command mkdir -p $next && cd $next && rpg ls
    elif [[ -d 1 ]] ; then
        cd 1 && rpg ls
    else
        command mkdir -p dungeon/1 && cd dungeon/1 && rpg ls
    fi
}
# End RPG-cli integrations

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
  echo "Quarantine: $((secondsPassedQuar / 86400)) days"
}

function wweather() {
  fwatch 600 weather
}

function svtop() {
  if ! command -v npm &> /dev/null; then
    nvm install stable
  fi

  if command -v vtop &> /dev/null; then
    vtop
  else
    npm i -g vtop
    vtop
  fi
}

function wdate() {
  fwatch 1 prettyDate
}

# application shortcuts
source $HOME/.zshrc.kubeHelper
source $HOME/.zshrc.awsHelper
