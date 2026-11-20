# Tool aliases. `command -v` is a builtin. `cd` stays builtin until zoxide.sh.

_have() { command -v "$1" >/dev/null 2>&1; }

if _have eza; then
  alias ls='eza --group-directories-first --icons=auto'
  alias ll='eza -lh --git --color-scale=all --group-directories-first --icons=auto'
  alias la='eza -lah --git --color-scale=all --group-directories-first --icons=auto'
  alias lsa='eza -a --group-directories-first --icons=auto'
  alias ldot='eza -ld --git --icons=auto .*'
  alias lt='eza --tree --level=2 --icons=auto'
  alias tree='eza --tree --icons=auto'
  alias l='eza --group-directories-first --icons=auto'
fi

if _have bat; then
  alias cat='bat --paging=never'
  alias ccat='/bin/cat'
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
  export BAT_THEME="${BAT_THEME:-Monokai Extended}"
  export BAT_STYLE="${BAT_STYLE:-numbers,changes,header}"
fi

if _have rg; then
  alias grep=rg
  alias ggrep='/usr/bin/grep'
fi

if _have fd; then
  alias find=fd
  alias ffind='/usr/bin/find'
fi

if _have dust; then
  alias du=dust
  alias ddu='/usr/bin/du'
fi

if _have duf; then
  alias df=duf
  alias ddf='/bin/df'
fi

if _have procs; then
  alias ps=procs
fi

if _have btm; then
  alias top=btm
  alias htop=btm
  alias ttop='/usr/bin/top'
fi

if _have delta; then
  export GIT_PAGER=delta
  alias gdiff='git diff'
  alias gshow='git show'
fi

if _have doggo; then
  alias dig=doggo
  alias ddig='/usr/bin/dig'
fi

if _have hexyl; then
  alias xxd=hexyl
  alias hd=hexyl
fi

if _have tldr; then
  alias help=tldr
  alias man=tldr
fi

if _have gping; then
  alias ping=gping
  alias pping='/sbin/ping'
fi

if _have lazygit; then
  alias lg=lazygit
fi

if _have difft; then
  alias gdifft='git difftool --tool=difftastic'
  alias difftastic=difft
fi

alias glog='git log --oneline --graph --decorate --all'
alias gst='git status'
alias gco='git checkout'
alias gcm='git commit -m'
alias gp='git push'
alias gpl='git pull'

if _have ouch; then
  alias compress='ouch compress'
  alias decompress='ouch decompress'
  alias lsarchive='ouch list'
fi

if _have jless; then
  alias jv=jless
fi

if _have watchexec; then
  alias watch=watchexec
fi

if _have dua; then
  alias dui='dua interactive'
fi

if _have bandwhich; then
  alias bwich='sudo bandwhich'
fi

if _have choose; then
  alias field=choose
fi

if _have hyperfine; then
  alias bench=hyperfine
fi

if _have tokei; then
  alias cloc=tokei
  alias loc=tokei
fi

alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -i'
alias mkdir='mkdir -pv'

alias ..='builtin cd ..'
alias ...='builtin cd ../..'
alias ....='builtin cd ../../..'
alias .....='builtin cd ../../../..'
alias d='dirs -v'

_i=1
while [ "$_i" -le 9 ]; do
  alias "$_i"="builtin cd +${_i}"
  _i=$((_i + 1))
done
unset _i
unset -f _have
