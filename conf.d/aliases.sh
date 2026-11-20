# Static aliases. Existence checks for fallbacks are builtins (no forks).

alias _=sudo
alias g=git
alias please=sudo
alias vi=vim
alias nv=nvim

alias get=git
alias quit='exit'
alias cd..='cd ..'
alias zz='exit'
alias cls="clear && printf '\e[3J'"

alias tarls='tar -tvf'
alias untar='tar -xf'

alias timestamp="date '+%Y-%m-%d %H:%M:%S'"
alias datestamp="date '+%Y-%m-%d'"
alias isodate="date +%Y-%m-%dT%H:%M:%S%z"
alias utc="date -u +%Y-%m-%dT%H:%M:%SZ"
alias unixepoch='date +%s'

alias urldecode='python3 -c "import sys, urllib.parse as ul; print(ul.unquote_plus(sys.argv[1]))"'
alias urlencode='python3 -c "import sys, urllib.parse as ul; print(ul.quote_plus(sys.argv[1]))"'

alias zshrc='${EDITOR:-vim} "${ZDOTDIR:-$HOME/.config/zsh}/.zshrc"'
alias bashrc='${EDITOR:-vim} "$HOME/.config/bash/bashrc"'
alias print-path='echo "$PATH" | tr ":" "\n"'

alias todos='${VISUAL:-${EDITOR:-vim}} "$HOME/Desktop/todo.txt"'
alias autorotate='jhead -autorot'

alias cc='claude'
alias ccy='claude --dangerously-skip-permissions'

_PI_EXT="$HOME/Developer/pi-vs-claude-code/extensions"
alias pi-min="pi -e $_PI_EXT/minimal.ts -e $_PI_EXT/theme-cycler.ts"
alias pi-focus="pi -e $_PI_EXT/pure-focus.ts"
alias pi-team="pi -e $_PI_EXT/agent-team.ts -e $_PI_EXT/theme-cycler.ts"
alias pi-safe="pi -e $_PI_EXT/damage-control.ts -e $_PI_EXT/minimal.ts -e $_PI_EXT/theme-cycler.ts"
alias pi-tasks="pi -e $_PI_EXT/tilldone.ts -e $_PI_EXT/theme-cycler.ts"
alias pi-coms="pi -e $_PI_EXT/coms-net.ts -e $_PI_EXT/minimal.ts -e $_PI_EXT/theme-cycler.ts"
unset _PI_EXT

if ! command -v eza >/dev/null 2>&1; then
  alias l=ls
  alias ll='ls -lh'
  alias la='ls -lAh'
  alias lsa='ls -aG'
  alias ldot='ls -ld .*'
fi

if ! command -v dust >/dev/null 2>&1; then
  alias biggest='du -s ./* | sort -nr | awk '\''{print $2}'\'' | xargs du -sh'
  alias dux='du -x --max-depth=1 | sort -n'
  alias dud='du -d 1 -h'
  alias duf='du -sh *'
fi
