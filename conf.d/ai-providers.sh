# Optional exports. Point AI_PROVIDERS_FILE at a gitignored *.local.sh.
# No keychain lookup here; `security find-generic-password` blocks startup.

_ai_file=${AI_PROVIDERS_FILE:-$BASHDOTDIR/conf.d/ai-providers.local.sh}
[ -r "$_ai_file" ] || {
  unset _ai_file
  return 0
}
set -a
# shellcheck disable=SC1090
. "$_ai_file"
set +a
unset _ai_file
