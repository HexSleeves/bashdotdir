# zoxide without `zoxide init` (that file is ~180 lines and rewrites PROMPT_COMMAND).
# The hook records a directory only after PWD changes, so shell start does not fork.

command -v zoxide >/dev/null 2>&1 || {
  _bash_zoxide_hook() { :; }
  return 0
}

z() {
  if [ "$#" -eq 0 ]; then
    builtin cd -- ~
  elif [ "$#" -eq 1 ] && [ "$1" = - ]; then
    builtin cd -- -
  elif [ "$#" -eq 1 ] && [ -d "$1" ]; then
    builtin cd -- "$1"
  else
    local dest
    dest=$(command zoxide query --exclude "$PWD" -- "$@" </dev/null) || return
    builtin cd -- "$dest"
  fi
}

zi() {
  local dest
  dest=$(command zoxide query --interactive -- "$@") || return
  builtin cd -- "$dest"
}

alias cd=z
alias ccd='builtin cd'

_zoxide_pwd=$PWD
_bash_zoxide_hook() {
  [ "${_zoxide_pwd}" = "$PWD" ] && return 0
  _zoxide_pwd=$PWD
  command zoxide add -- "$PWD" </dev/null >/dev/null 2>&1 || true
}
