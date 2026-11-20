# Login-only. OrbStack appends its bin; it does not take the front of PATH.
if [ -f "$HOME/.orbstack/shell/init.bash" ]; then
  # shellcheck disable=SC1091
  . "$HOME/.orbstack/shell/init.bash"
fi
