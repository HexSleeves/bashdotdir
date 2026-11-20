# Direnv without `direnv hook bash` (that bakes an absolute path).
# Walk parents with stats. Fork `direnv export` only inside a project, or
# while an export is still loaded so leaving the tree can unload it.

command -v direnv >/dev/null 2>&1 || {
  _bash_direnv_hook() { :; }
  return 0
}

_direnv_tree_has_rc() {
  local d=$PWD
  while [ -n "$d" ] && [ "$d" != / ]; do
    [ -e "$d/.envrc" ] && return 0
    d=${d%/*}
  done
  return 1
}

_bash_direnv_hook() {
  if [ -z "${DIRENV_DIR:-}" ]; then
    _direnv_tree_has_rc || return 0
  fi
  local out
  out=$(command direnv export bash </dev/null 2>/dev/null) || return 0
  if [ -n "$out" ]; then
    # shellcheck disable=SC1090
    eval "$out"
    _bash_repath=1
  fi
}
