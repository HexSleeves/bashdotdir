# Defaults that profile.sh / hm-session-vars may already have set.

export EDITOR="${EDITOR:-nvim}"
export VISUAL="${VISUAL:-$EDITOR}"
export PAGER="${PAGER:-less}"

shopt -s checkwinsize

_projects=${XDG_PROJECTS_DIR:-$HOME/Projects}
if [ -z "${CDPATH:-}" ] && [ -d "$_projects" ]; then
  CDPATH=".:$_projects"
fi
unset _projects
