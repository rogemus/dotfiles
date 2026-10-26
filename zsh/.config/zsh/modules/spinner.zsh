#!/usr/bin/env zsh

# ─── Spinner ───────────────────────────────────────────────────────
# Usage: zsh-spinner-start "Working..."; slow-command; zsh-spinner-stop
# Draws on stderr and only when it is a terminal. Pair every start with a stop,
# e.g. with `{ ... } always { zsh-spinner-stop }`, or the cursor stays hidden

# Start the spinner in the background
function zsh-spinner-start {
  [[ -t 2 ]] || return
  setopt local_options no_monitor no_notify
  local msg=$1
  print -n '\e[?25l' >&2
  {
    local -i i=0
    local frames='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    while true; do
      print -n "\r\e[K${frames[i++ % $#frames + 1]} $msg" >&2
      sleep 0.1
    done
  } &
  _zsh_spinner_pid=$!
}

# Stop the spinner and clear its line
function zsh-spinner-stop {
  [[ -n $_zsh_spinner_pid ]] || return
  setopt local_options no_monitor no_notify
  kill $_zsh_spinner_pid 2>/dev/null
  wait $_zsh_spinner_pid 2>/dev/null
  _zsh_spinner_pid=
  print -n '\r\e[K\e[?25h' >&2
}
