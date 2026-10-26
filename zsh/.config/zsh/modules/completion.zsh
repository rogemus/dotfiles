#!/usr/bin/env zsh

# ─── Completion ────────────────────────────────────────────────────
# Sourced after zsh-plugin-load so zsh-completions is on fpath.
# The dump is reused as-is and compiled once. Run `update-comp` after installing a tool.
_zcache=${XDG_CACHE_HOME:-$HOME/.cache}/zsh
[[ -d $_zcache ]] || mkdir -p $_zcache
autoload -Uz compinit && compinit -C -d $_zcache/zcompdump
[[ -s $_zcache/zcompdump && ( ! -s $_zcache/zcompdump.zwc || $_zcache/zcompdump -nt $_zcache/zcompdump.zwc ) ]] \
  && zcompile $_zcache/zcompdump

setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' completer _complete _approximate
zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path $_zcache/zcompcache
zstyle ':completion:*' list-colors 'di=1;34:ln=36:ex=32'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{blue}-- %d --%f'

alias update-comp='rm -rf ~/.cache/zsh/zcompdump* ~/.cache/zsh/zcompcache ~/.cache/zsh/init-*.zsh && exec zsh'

# Source the output of an init command from a cache file instead of forking it on every start.
# The cache is rebuilt when the binary or this file is newer, or after `update-comp`.
# Usage: _zsh_cache_init <name> <binary> <command...>
function _zsh_cache_init {
  local file=$_zcache/init-$1.zsh bin=$commands[$2]
  [[ -n $bin ]] || return
  shift 2
  if [[ ! -s $file || $bin -nt $file || ${(%):-%x} -nt $file ]]; then
    "$@" >| $file || { rm -f $file; return 1 }
  fi
  source $file
}

# ─── fzf ───────────────────────────────────────────────────────────
_zsh_cache_init fzf fzf fzf --zsh
bindkey -r '^T' '^[c'
bindkey '^[r' fzf-history-widget # Option-R: recent commands (Ctrl-R stays)
bindkey '^[f' fzf-file-widget    # Option-F: files
bindkey '^[d' fzf-cd-widget      # Option-D: directories

# ─── zoxide (replaces cd) ──────────────────────────────────────────
_zsh_cache_init zoxide zoxide zoxide init zsh --cmd cd

# ─── just completions ──────────────────────────────────────────────
_zsh_cache_init just just env JUST_COMPLETE=zsh just

# ─── bun completions ───────────────────────────────────────────────
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

unset _zcache
