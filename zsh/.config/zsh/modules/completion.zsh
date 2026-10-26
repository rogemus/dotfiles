#!/usr/bin/env zsh

# ─── Completion ────────────────────────────────────────────────────
# Sourced after zsh-plugin-load so zsh-completions is on fpath.
# The dump is reused as-is and compiled once. Run `update-comp` after installing a tool.
_zcache=${XDG_CACHE_HOME:-$HOME/.cache}/zsh
[[ -d $_zcache ]] || mkdir -p $_zcache
autoload -Uz compinit && compinit -C -d $_zcache/zcompdump
[[ -s $_zcache/zcompdump && ( ! -s $_zcache/zcompdump.zwc || $_zcache/zcompdump -nt $_zcache/zcompdump.zwc ) ]] \
  && zcompile $_zcache/zcompdump

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' completer _complete _approximate
zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path $_zcache/zcompcache
zstyle ':completion:*' list-colors 'di=1;34:ln=36:ex=32'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{blue}-- %d --%f'
unset _zcache

alias update-comp='rm -rf ~/.cache/zsh/zcompdump* ~/.cache/zsh/zcompcache && exec zsh'

# ─── fzf ───────────────────────────────────────────────────────────
eval "$(fzf --zsh)"
bindkey -r '^T' '^[c'
bindkey '^[r' fzf-history-widget # Option-R: recent commands (Ctrl-R stays)
bindkey '^[f' fzf-file-widget    # Option-F: files
bindkey '^[d' fzf-cd-widget      # Option-D: directories

# ─── zoxide (replaces cd) ──────────────────────────────────────────
eval "$(zoxide init zsh --cmd cd)"

# ─── just completions ──────────────────────────────────────────────
#compdef just
source <(JUST_COMPLETE=zsh just)
if [ "$funcstack[1]" = "_just" ]; then
  _clap_dynamic_completer_just "$@"
fi

# ─── bun completions ───────────────────────────────────────────────
[ -s "/Users/kacper.rogowski/.bun/_bun" ] && source "/Users/kacper.rogowski/.bun/_bun"
