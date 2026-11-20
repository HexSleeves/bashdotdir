# One precmd. Direnv and mise fork only when a project needs them. Starship
# forks once per prompt, which is the prompt itself — not an init script.
# Non-ttys (bash -ic from a pipe) install nothing.

[ -t 1 ] || return 0

type _bash_direnv_hook >/dev/null 2>&1 || _bash_direnv_hook() { :; }
type _bash_mise_hook >/dev/null 2>&1 || _bash_mise_hook() { :; }
type _bash_zoxide_hook >/dev/null 2>&1 || _bash_zoxide_hook() { :; }
type _bash_atuin_preexec >/dev/null 2>&1 || _bash_atuin_preexec() { :; }
type _bash_atuin_precmd >/dev/null 2>&1 || _bash_atuin_precmd() { :; }

_starship_now_ms() {
  local s=${EPOCHREALTIME:-} whole frac
  [ -n "$s" ] || {
    printf '0\n'
    return 0
  }
  whole=${s%%.*}
  frac=${s#*.}
  frac=${frac}000
  frac=${frac:0:3}
  printf '%s\n' "$((whole * 1000 + 10#$frac))"
}

# The trap also fires for `bind -x` widgets (Ctrl-R, fzf's Ctrl-T), which are
# not the command line; consuming the ready flag there would skip the real one.
_bash_debug() {
  [ "${STARSHIP_PREEXEC_READY:-}" = true ] || return 0
  case $BASH_COMMAND in
    _atuin_ctrl_r* | fzf-file-widget | __fzf_*) return 0 ;;
  esac
  STARSHIP_PREEXEC_READY=false
  _bash_atuin_preexec
  STARSHIP_START_MS=$(_starship_now_ms)
}

_bash_starship_precmd() {
  local st=$1 duration=$2
  if ! command -v starship >/dev/null 2>&1 || [ "${TERM:-dumb}" = dumb ]; then
    PS1='\w \$ '
    return 0
  fi
  PS1=$(command starship prompt --status="$st" --cmd-duration="$duration" --terminal-width="${COLUMNS:-80}" </dev/null)
}

_bash_precmd() {
  local st=$? duration=0 now
  if [ -n "${STARSHIP_START_MS:-}" ]; then
    now=$(_starship_now_ms)
    duration=$((now - STARSHIP_START_MS))
    [ "$duration" -lt 0 ] && duration=0
    STARSHIP_START_MS=
  fi
  _bash_atuin_precmd "$st" "$duration"
  _bash_repath=0
  _bash_direnv_hook
  _bash_mise_hook
  if [ "$_bash_repath" = 1 ] && [ -f "$HOME/.config/shell/path.sh" ]; then
    # shellcheck disable=SC1091
    . "$HOME/.config/shell/path.sh"
  fi
  _bash_zoxide_hook
  _bash_starship_precmd "$st" "$duration"
  STARSHIP_PREEXEC_READY=true
  return "$st"
}

PROMPT_COMMAND=_bash_precmd
if [ -n "${EPOCHREALTIME+x}" ]; then
  trap _bash_debug DEBUG
fi
