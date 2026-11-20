HISTSIZE=50000
HISTFILESIZE=50000
# ignorespace:erasedups, not ignoreboth: ignoredups would drop a repeated command
# before zz-atuin.sh can see it, and erasedups already keeps one copy.
HISTCONTROL=ignorespace:erasedups
shopt -s histappend cmdhist

_hdir=${XDG_STATE_HOME:-$HOME/.local/state}/bash
if [ ! -d "$_hdir" ]; then
  mkdir -p "$_hdir"
fi
HISTFILE=$_hdir/history
unset _hdir
