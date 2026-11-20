# Ctrl-R calls `atuin search` directly, and zz-prompt.sh's hooks record each
# command. Sourcing `atuin init bash` would pull in bash-preexec (~57KB) and
# rewrite PROMPT_COMMAND.

[ -t 1 ] || return 0
[ "${BASH_VERSINFO[0]:-0}" -ge 4 ] || return 0
command -v atuin >/dev/null 2>&1 || return 0

# `atuin uuid` costs a fork per shell. Mint the same simple-form UUIDv7 here;
# SRANDOM needs bash 5.1.
if [ -z "${ATUIN_SESSION:-}" ] || [ "${ATUIN_SHLVL:-}" != "$SHLVL" ]; then
  if [ -n "${SRANDOM+x}" ] && [ -n "${EPOCHREALTIME:-}" ]; then
    _atuin_us=${EPOCHREALTIME//[!0-9]/}
    printf -v ATUIN_SESSION '%012x7%03x%x%03x%08x%04x' \
      $((_atuin_us / 1000)) $((SRANDOM & 0xfff)) $((8 | (SRANDOM & 3))) \
      $((SRANDOM & 0xfff)) "$SRANDOM" $((SRANDOM & 0xffff))
    unset _atuin_us
  else
    ATUIN_SESSION=$(atuin uuid)
  fi
  export ATUIN_SESSION
  export ATUIN_SHLVL=$SHLVL
fi

_atuin_seen=
_atuin_seeded=
_atuin_id=

# Called from the DEBUG trap before the first command of each prompt line.
# The timestamped history entry identifies the line: a command typed with a
# leading space is not saved (HISTCONTROL in history.sh), so `history 1` still
# shows the previous entry, already recorded, and is skipped.
_bash_atuin_preexec() {
  local entry cmd
  entry=$(HISTTIMEFORMAT='%s ' builtin history 1)
  [ -n "$entry" ] && [ "$entry" != "$_atuin_seen" ] || return 0
  _atuin_seen=$entry
  cmd=${entry#"${entry%%[![:space:]]*}"}
  cmd=${cmd#"${cmd%%[!0-9]*}"}
  cmd=${cmd:2}
  cmd=${cmd#"${cmd%%[!0-9]*}"}
  cmd=${cmd# }
  _atuin_id=$(ATUIN_SHELL=bash command atuin history start --hook -- "$cmd" 2>/dev/null)
}

_bash_atuin_precmd() {
  local st=$1 ms=$2
  # Bash loads HISTFILE after the startup files, so the first prompt is the
  # earliest point where `history 1` shows the previous session's last entry.
  # Seeding with it stops a hidden first command from re-recording that entry.
  if [ -z "$_atuin_seeded" ]; then
    _atuin_seen=$(HISTTIMEFORMAT='%s ' builtin history 1)
    _atuin_seeded=1
  fi
  [ -n "$_atuin_id" ] || return 0
  (command atuin history end --hook --exit "$st" --duration="$((ms * 1000000))" -- "$_atuin_id" >/dev/null 2>&1 &)
  _atuin_id=
}

_atuin_ctrl_r() {
  local output accept=0
  output=$(ATUIN_SHELL=bash ATUIN_QUERY="$READLINE_LINE" command atuin search -i 3>&1 1>&2 2>&3 3>&-) || return
  [ -n "$output" ] || return 0
  case $output in
    __atuin_accept__:*)
      output=${output#__atuin_accept__:}
      accept=1
      ;;
  esac
  READLINE_LINE=$output
  READLINE_POINT=${#READLINE_LINE}
  if [ "$accept" -eq 1 ]; then
    bind '"\e[0n": accept-line'
    printf '\e[5n' >/dev/tty
  fi
}

bind -m emacs-standard -x '"\C-r": _atuin_ctrl_r' 2>/dev/null || true
bind -m vi-command -x '"\C-r": _atuin_ctrl_r' 2>/dev/null || true
bind -m vi-insert -x '"\C-r": _atuin_ctrl_r' 2>/dev/null || true
