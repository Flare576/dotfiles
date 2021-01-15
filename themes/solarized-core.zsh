#
# Solarized Themes Core, based on Cobalt2 by Wes Bos
#
# # README
#
# This theme uses UTF-8 characters - Ensure your font supports them!
# Copy the variables below into a new file, add
# source "$HOME/dotfiles/themes/solarized-core.zsh"
# to the top of the file (Presuming that's where this file is),
# and customize away!

### Easy access to things you might want to adjust
FINAL_BG='008'
FINAL_FG='010'
SEGMENT_SEPARATOR=''

PERSONAL_BG='000'
PERSONAL_ICON='🥃'

PATH_FG='010'
PATH_BG='008'

SYMBOL_BG='006'
SYMBOL_FG='001'
FAILED_ICON='✘'
BACKGROUND_ICON='⚙'
ALIAS_ICON='⚡'

GIT_CLEAN_FG='002'
GIT_DIRTY_FG='005'
GIT_CLEAN_BG='000'
GIT_DIRTY_BG='000'

CURRENT_BG='NONE' # Initial value of "NONE"

# Un-comment the next line when you copy/paste!
# PROMPT='%{%f%b%k%}$(build_prompt) '

### Stop copy/paste line: rest of the file are the utility functions

### Segment drawing
# A few utility functions to make it easy and re-usable to draw segmented prompts

# Begin a segment, terminating prior if present
# $1: Background, default=default
# $2: Foreground, default=default
# $3: Content, default=''
prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="$BG[$1]" || bg="%k"
  [[ -n $2 ]] && fg="$FG[$2]" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n " %{$bg$FG[$CURRENT_BG]%}$SEGMENT_SEPARATOR%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%} "
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

# End the prompt, closing any open segments
prompt_end() {
  #sample
  [[ $FINAL_FG == "NONE" ]] && fg=$CURRENT_BG || fg=$FINAL_FG
  if [[ -n $CURRENT_BG ]]; then
    # echo -n "%{$FG[$CURRENT_BG]$BG[$FINAL_BG]%} $SEGMENT_SEPARATOR"
    echo -n " %{$FG[$fg]$BG[$FINAL_BG]%}$SEGMENT_SEPARATOR"
  fi
  echo -n "%{%k%f%}"
  CURRENT_BG=''
}

### Prompt components
# Each component will draw itself, and hide itself if no information needs to be shown

# Context: user@hostname (who am I and where am I)
prompt_context() {
  local user=`whoami`

  if [[ "$user" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    prompt_segment $PERSONAL_BG default "%(!.%{%F{yellow}%}.)$PERSONAL_ICON"
  fi
}

# Git: branch/detached head, dirty status
prompt_git() {
  local ref dirty
  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    ZSH_THEME_GIT_PROMPT_DIRTY='±'
    dirty=$(parse_git_dirty)
    ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git show-ref --head -s --abbrev |head -n1 2> /dev/null)"
    if [[ -n $dirty ]]; then
      prompt_segment $GIT_DIRTY_BG $GIT_DIRTY_FG
    else
      prompt_segment $GIT_CLEAN_BG $GIT_CLEAN_FG
    fi
    echo -n "${ref/refs\/heads\// }$dirty"
  fi
}

# Dir: current working directory
prompt_dir() {
  prompt_segment $PATH_BG $PATH_FG '%3~'
}

# Status:
# - was there an error
# - am I root
# - are there background jobs?
prompt_status() {
  local symbols
  symbols=()
  [[ $UID -eq 0 ]] && symbols+="$ALIAS_ICON"
  [[ $RETVAL -ne 0 ]] && symbols+="$FAILED_ICON"
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="$BACKGROUND_ICON"

  [[ -n "$symbols" ]] && prompt_segment $SYMBOL_BG $SYMBOL_FG "$symbols"
}

## Main prompt
build_prompt() {
  RETVAL=$?
  prompt_status
  prompt_context
  prompt_dir
  prompt_git
  prompt_end
}
