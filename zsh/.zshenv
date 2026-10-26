# ─── XDG ───────────────────────────────────────────────────────────
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share

# ─── zsh config dir ────────────────────────────────────────────────
# Read by every zsh, so non-login shells (tmux panes, scripts) find the config too
export ZDOTDIR=$HOME/.config/zsh
