bak() {
  local now f
  now=$(date +%Y%m%d-%H%M%S)
  for f in "$@"; do
    if [ ! -e "$f" ]; then
      printf 'file not found: %s\n' "$f" >&2
      continue
    fi
    cp -R -- "$f" "$f.$now.bak"
  done
}

pps() {
  command ps aux | command rg "$@" | command rg -v rg
}
