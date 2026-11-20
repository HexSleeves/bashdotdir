# Mise shims are already on PATH (path.sh). Do not `mise activate`: it snapshots
# PATH. Fork `hook-env` only when a config exists, and after that on directory
# changes so leaving the project can unload.

command -v mise >/dev/null 2>&1 || {
  _bash_mise_hook() { :; }
  return 0
}

_mise_tree_has_config() {
  local d=$PWD
  while [ -n "$d" ] && [ "$d" != / ]; do
    if [ -f "$d/mise.toml" ] || [ -f "$d/.mise.toml" ] || [ -f "$d/mise.local.toml" ] || [ -f "$d/.tool-versions" ]; then
      return 0
    fi
    d=${d%/*}
  done
  return 1
}

_bash_mise_hook() {
  [ "${_mise_pwd:-}" = "$PWD" ] && return 0
  _mise_pwd=$PWD
  if [ -z "${_mise_active:-}" ]; then
    _mise_tree_has_config || return 0
  fi
  local out
  out=$(command mise hook-env -s bash -q </dev/null 2>/dev/null) || return 0
  if [ -n "$out" ]; then
    # shellcheck disable=SC1090
    eval "$out"
    _bash_repath=1
    _mise_active=1
  fi
}
