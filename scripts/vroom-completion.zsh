#/bin/zsh
_vroom_completions()
{
  if [ "${#COMP_WORDS[@]}" != "2" ]; then
    return
  fi
  COMPREPLY=($(compgen -W "$(git branch -a | sed 's/[\* ]//g')" -- "${COMP_WORDS[1]}"))
}
complete -F _vroom_completions vroom

