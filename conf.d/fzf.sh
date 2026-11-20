# fzf Ctrl-T / Alt-C from the package's static key-bindings file.
# Ctrl-R stays free: hm-session-vars sets FZF_CTRL_R_COMMAND="" and atuin binds it.
# No `fzf --bash` — that forks on every shell.

[ -t 1 ] || return 0
command -v fzf >/dev/null 2>&1 || return 0

_fzf_share=
if [ -n "${HOMEBREW_PREFIX:-}" ] && [ -r "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.bash" ]; then
  _fzf_share=$HOMEBREW_PREFIX/opt/fzf/shell
elif [ -r /usr/share/fzf/key-bindings.bash ]; then
  _fzf_share=/usr/share/fzf
elif [ -r /usr/share/doc/fzf/examples/key-bindings.bash ]; then
  _fzf_share=/usr/share/doc/fzf/examples
else
  _fzf_bin=$(command -v fzf)
  if [ -L "$_fzf_bin" ]; then
    _fzf_target=$(readlink "$_fzf_bin") || _fzf_target=
    case $_fzf_target in
      /*) ;;
      *) _fzf_target=${_fzf_bin%/*}/$_fzf_target ;;
    esac
    _fzf_share=${_fzf_target%/*}/../share/fzf
  fi
  unset _fzf_bin _fzf_target
fi

if [ -n "$_fzf_share" ] && [ -r "$_fzf_share/key-bindings.bash" ]; then
  # shellcheck disable=SC1091
  . "$_fzf_share/key-bindings.bash"
fi
unset _fzf_share
