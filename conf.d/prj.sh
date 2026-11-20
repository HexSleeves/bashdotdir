# Project jumper: wraps `prj` so a selected directory becomes a cd. Written out
# instead of `eval "$(prj -i bash)"` so startup does not fork.

command -v prj >/dev/null 2>&1 || return 0

prj() {
  local sel
  sel=$(command prj "$@")
  if [ -n "$sel" ] && [ -d "$sel" ]; then
    builtin cd -- "$sel" || return
  else
    printf '%s\n' "$sel"
  fi
}
