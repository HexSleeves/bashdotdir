# Bash entrypoint, sourced by the ~/.bashrc stub Home Manager writes from this
# repo's clone at ~/.config/bash. Interactive shells continue into
# $BASHDOTDIR/bashrc.interactive, login shells into $BASHDOTDIR/bash_profile.

# Non-interactive ssh into the Director sandbox arrives with HOME, USER and
# LOGNAME unset. Fill them before anything reads $HOME: the guard below is
# exported, so a pass that found no path.sh would stop every child shell
# from sourcing it. An unset HOME makes `~` fall back to the passwd entry.
if [ -z "${HOME:-}" ]; then
  HOME=~
  USER=${USER:-$(id -un)}
  LOGNAME=${LOGNAME:-$USER}
  export HOME USER LOGNAME
fi

# Through BASH_ENV this runs under the caller's options: a `#!/bin/bash -eu`
# script must not die on an unset TERM in hm-session-vars, and `bash -x` should
# trace the script, not this file.
_bashrc_opts=$-
set +aeux

# The environment is exported, so a child bash inherits it and skips this.
# Aliases, functions and the prompt are not inherited: a nested shell or a tmux
# pane started from one still needs the interactive part below.
if [ -z "${BASH_DOTDIR_SOURCED:-}" ]; then
  export BASH_DOTDIR_SOURCED=1
  export BASHDOTDIR="${BASHDOTDIR:-$HOME/.config/bash}"

  if [ -f "$BASHDOTDIR/bashenv" ]; then
    # shellcheck disable=SC1091
    . "$BASHDOTDIR/bashenv"
  fi
  if [ -r /usr/share/omarchy/default/bash/env-bootstrap ]; then
    # shellcheck disable=SC1091
    . /usr/share/omarchy/default/bash/env-bootstrap
  fi
  if [ -f "$HOME/.config/shell/path.sh" ]; then
    # shellcheck disable=SC1091
    . "$HOME/.config/shell/path.sh"
  fi
fi

case $- in
*i*)
  if [ -f "$BASHDOTDIR/bashrc.interactive" ]; then
    # shellcheck disable=SC1091
    . "$BASHDOTDIR/bashrc.interactive"
  fi
  ;;
esac

if shopt -q login_shell 2>/dev/null; then
  if [ -f "$BASHDOTDIR/bash_profile" ]; then
    # shellcheck disable=SC1091
    . "$BASHDOTDIR/bash_profile"
  fi
fi

case $_bashrc_opts in *a*) set -a ;; esac
case $_bashrc_opts in *e*) set -e ;; esac
case $_bashrc_opts in *u*) set -u ;; esac
case $_bashrc_opts in
*x*)
  unset _bashrc_opts
  set -x
  ;;
*) unset _bashrc_opts ;;
esac

