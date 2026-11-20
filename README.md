# bashdotdir

Bash configuration for my machines, cloned to `~/.config/bash` and named after
`BASHDOTDIR`, the variable the files already key off. The zsh counterpart is
[zdotdir](https://github.com/HexSleeves/zdotdir) at `~/.config/zsh`.

`hm-dotfiles` writes a small `~/.bashrc` that sets `BASHDOTDIR` and sources
`$BASHDOTDIR/bashrc` from here. On the Adobe Mac a login-shell wrapper exports
`BASH_ENV=~/.bashrc`, so non-interactive `bash -c` (sshd, scripts) gets the same
environment that zsh reads from `~/.zshenv`. Linux hosts set `BASH_ENV` through
`systemd` session variables instead.

`modules/common/external-clones.nix` in `hm-dotfiles` clones this repository at
activation and leaves an existing checkout alone, so edits here are pulled by
hand, the same as `zdotdir`.

## Layout

| file | read by |
| --- | --- |
| `bashrc` | `~/.bashrc`, every shell; loads the environment and dispatches |
| `bashenv` | the main environment, sourced once per shell |
| `bashrc.interactive` | interactive shells only; prompt, completion, `conf.d` |
| `bash_profile` | login shells only |
| `conf.d/*.sh` | sourced in name order by `bashrc.interactive` |
